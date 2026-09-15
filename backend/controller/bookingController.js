const crypto = require('crypto');
const { Op, fn, col, where } = require('sequelize');
const { sequelize, Booking, BookingItem, Customer, CateringPackage, Payment, User } = require('../models');

// Guest checkout has no logged-in user, but every Booking still needs a
// Customer row (customer_id is a required FK). Rather than changing that
// schema, we transparently find-or-create a User+Customer from the contact
// details on the booking form:
//  - If the email already belongs to an account, the guest booking is
//    attached to that account (same as most "checkout as guest" flows).
//  - Otherwise a new account is created with an unusable random password —
//    it exists purely to own the booking. The person is never told
//    credentials and isn't logged into it; they can always use "Forgot
//    password" later if they want to claim it.
async function findOrCreateGuestCustomer({ contact_name, contact_email, contact_phone }, t) {
  const existingUser = await User.findOne({
    where: where(fn('LOWER', col('email')), contact_email.toLowerCase()),
    transaction: t,
  });

  if (existingUser) {
    const existingCustomer = await Customer.findOne({ where: { user_id: existingUser.user_id }, transaction: t });
    if (existingCustomer) return existingCustomer;
    // Account exists but (unusually) has no Customer row yet — create one.
    const [firstName, ...rest] = contact_name.trim().split(' ');
    return Customer.create(
      { user_id: existingUser.user_id, first_name: firstName || contact_name, last_name: rest.join(' ') || '', phone: contact_phone || null },
      { transaction: t },
    );
  }

  const randomPassword = crypto.randomBytes(24).toString('hex');
  const newUser = await User.create(
    {
      email: contact_email.toLowerCase(),
      password_hash: randomPassword, // hashed by the User model's beforeCreate hook
      name: contact_name,
      phone: contact_phone || null,
      role: 'customer',
    },
    { transaction: t },
  );

  const [firstName, ...rest] = contact_name.trim().split(' ');
  return Customer.create(
    { user_id: newUser.user_id, first_name: firstName || contact_name, last_name: rest.join(' ') || '', phone: contact_phone || null },
    { transaction: t },
  );
}

// Mirrors occasion-frontend/src/utils/coupons.js. There's no Coupons table
// yet, so this is the same demo list kept in sync on both sides — but
// unlike the frontend, this copy is what actually determines the amount
// PayFast charges, since a client-sent discount_amount can't be trusted.
const COUPONS = {
  OCCASION10: 0.1,
  WELCOME5: 0.05,
};
const SERVICE_FEE_RATE = 0.05;

// POST /api/bookings - Create a booking
// Body: {
//   event_date, event_time, guest_count, special_requests,
//   contact_name, contact_email, contact_phone,
//   coupon_code, discount_amount,
//   items: [{ package_id, guest_count?, quantity? }]
// }
exports.createBooking = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const {
      event_date,
      event_time,
      guest_count,
      special_requests,
      contact_name,
      contact_email,
      contact_phone,
      coupon_code,
      items,
    } = req.body;

    if (!event_date || !guest_count || !contact_name || !contact_email || !contact_phone) {
      await t.rollback();
      return res.status(400).json({
        success: false,
        error: 'event_date, guest_count, contact_name, contact_email and contact_phone are required',
      });
    }

    // Mirrors the frontend rule: no bookings for any date in the current
    // week — the earliest allowed date is the Monday of next week. Checked
    // again here so the rule holds even for requests that bypass the
    // checkout form (e.g. a direct API call).
    const requestedDate = new Date(`${event_date}T00:00:00`);
    if (Number.isNaN(requestedDate.getTime())) {
      await t.rollback();
      return res.status(400).json({ success: false, error: 'event_date is not a valid date' });
    }
    const now = new Date();
    const dayOfWeek = now.getDay(); // Sun=0 .. Sat=6
    const daysSinceMonday = (dayOfWeek + 6) % 7; // Mon=0 .. Sun=6
    const currentWeekMonday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - daysSinceMonday);
    const minBookableDate = new Date(currentWeekMonday);
    minBookableDate.setDate(currentWeekMonday.getDate() + 7);
    if (requestedDate < minBookableDate) {
      await t.rollback();
      return res.status(400).json({
        success: false,
        error: `Bookings can't be made for the current week. Please choose a date on or after ${minBookableDate.toISOString().split('T')[0]}.`,
      });
    }

    if (!Array.isArray(items) || items.length === 0) {
      await t.rollback();
      return res.status(400).json({ success: false, error: 'At least one package item is required' });
    }

    // Logged-in customer: use their existing profile. Guest (no req.user,
    // since this route uses optionalAuth): find-or-create one from the
    // contact details so guests can check out without an account.
    let customer;
    if (req.user) {
      customer = await Customer.findOne({ where: { user_id: req.user.user_id }, transaction: t });
      if (!customer) {
        await t.rollback();
        return res.status(400).json({ success: false, error: 'No customer profile for this account' });
      }
    } else {
      customer = await findOrCreateGuestCustomer({ contact_name, contact_email, contact_phone }, t);
    }

    const packageIds = [...new Set(items.map((i) => i.package_id))];
    const packages = await CateringPackage.findAll({ where: { package_id: packageIds }, transaction: t });
    const packageMap = new Map(packages.map((p) => [p.package_id, p]));

    const missing = packageIds.filter((id) => !packageMap.has(id));
    if (missing.length) {
      await t.rollback();
      return res.status(400).json({ success: false, error: `Unknown package_id(s): ${missing.join(', ')}` });
    }

    // Prices are looked up server-side from CateringPackage — never trust a
    // price the client might send — so a tampered request can't book a
    // package for less than it costs.
    let subtotal = 0;
    const lineItems = items.map((item) => {
      const pkg = packageMap.get(item.package_id);
      const quantity = item.quantity && item.quantity > 0 ? item.quantity : 1;
      const itemGuestCount = item.guest_count && item.guest_count > 0 ? item.guest_count : guest_count;
      const lineTotal = Number(pkg.base_price) * itemGuestCount * quantity;
      subtotal += lineTotal;
      return {
        package_id: pkg.package_id,
        menu_item_id: item.menu_item_id || null,
        quantity,
        line_total: lineTotal.toFixed(2),
      };
    });

    const serviceFee = Math.round(subtotal * SERVICE_FEE_RATE);

    const couponRate = coupon_code ? COUPONS[coupon_code.trim().toUpperCase()] : undefined;
    const discountAmount = couponRate ? Math.round(subtotal * couponRate) : 0;

    const totalAmount = Math.max(subtotal + serviceFee - discountAmount, 0).toFixed(2);

    const booking = await Booking.create(
      {
        customer_id: customer.customer_id,
        event_date,
        event_time: event_time || null,
        guest_count,
        special_requests: special_requests || null,
        contact_name,
        contact_email,
        contact_phone,
        event_type: req.body.event_type || 'general',
        status: 'pending_payment',
        total_amount: totalAmount,
      },
      { transaction: t },
    );

    await BookingItem.bulkCreate(
      lineItems.map((li) => ({ ...li, booking_id: booking.booking_id })),
      { transaction: t },
    );

    await Payment.create(
      {
        booking_id: booking.booking_id,
        amount: totalAmount,
        method: 'payfast',
        status: 'pending',
      },
      { transaction: t },
    );

    await t.commit();

    const fullBooking = await Booking.findByPk(booking.booking_id, {
      include: [{ model: BookingItem, include: [CateringPackage] }, { model: Payment }],
    });

    res.status(201).json({ success: true, data: fullBooking });
  } catch (error) {
    await t.rollback();
    console.error('Create booking error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create booking',
    });
  }
};

// GET /api/bookings - Get user's bookings
exports.getUserBookings = async (req, res) => {
  try {
    const customer = await Customer.findOne({ where: { user_id: req.user.user_id } });
    if (!customer) {
      return res.json({ success: true, data: [] });
    }

    const bookings = await Booking.findAll({
      where: { customer_id: customer.customer_id },
      include: [{ model: BookingItem, include: [CateringPackage] }, { model: Payment }],
      order: [['booking_id', 'DESC']],
    });

    res.json({
      success: true,
      data: bookings
    });
  } catch (error) {
    console.error('Get bookings error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch bookings'
    });
  }
};

// GET /api/bookings/:id - Get single booking
exports.getBookingById = async (req, res) => {
  try {
    const { id } = req.params;

    const booking = await Booking.findByPk(id, {
      include: [{ model: BookingItem, include: [CateringPackage] }, { model: Payment }],
    });

    if (!booking) {
      return res.status(404).json({ success: false, error: 'Booking not found' });
    }

    // Logged-in users can only see their own booking (or any, if admin).
    // Guests (no req.user — this route uses optionalAuth) have no account
    // to check ownership against; the booking_id itself is what Payment.vue
    // and Confirmation.vue use to look it up right after checkout, so we
    // allow the lookup through rather than locking guests out of their own
    // just-created booking.
    if (req.user && req.user.role !== 'admin') {
      const customer = await Customer.findOne({ where: { user_id: req.user.user_id } });
      if (!customer || booking.customer_id !== customer.customer_id) {
        return res.status(403).json({ success: false, error: 'Access denied' });
      }
    }

    res.json({
      success: true,
      data: booking
    });
  } catch (error) {
    console.error('Get booking error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch booking'
    });
  }
};

// PUT /api/bookings/:id/status - Update booking status
exports.updateBookingStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ['pending_payment', 'confirmed', 'completed', 'cancelled'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ success: false, error: `status must be one of: ${validStatuses.join(', ')}` });
    }

    const booking = await Booking.findByPk(id);
    if (!booking) {
      return res.status(404).json({ success: false, error: 'Booking not found' });
    }

    if (req.user.role !== 'admin') {
      const customer = await Customer.findOne({ where: { user_id: req.user.user_id } });
      if (!customer || booking.customer_id !== customer.customer_id) {
        return res.status(403).json({ success: false, error: 'Access denied' });
      }
      // Customers may only cancel their own booking, and only while it's
      // still upcoming (pending payment or confirmed) — everything else
      // (marking paid/completed, or touching a booking that's already
      // completed/cancelled) is server- or admin-driven.
      const cancellableStatuses = ['pending_payment', 'confirmed'];
      if (status !== 'cancelled' || !cancellableStatuses.includes(booking.status)) {
        return res.status(403).json({ success: false, error: 'You can only cancel an upcoming booking' });
      }
    }

    booking.status = status;
    await booking.save();

    res.json({
      success: true,
      data: booking
    });
  } catch (error) {
    console.error('Update booking error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update booking'
    });
  }
};
