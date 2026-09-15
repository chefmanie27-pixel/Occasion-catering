<script setup>
import { ref, computed } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { useCartStore } from '@/stores/cart'
import { useBookingsStore } from '@/stores/bookings'
import { useAuthStore } from '@/stores/auth'
import { validateCoupon } from '@/utils/coupons'

// Shell for the checkout/booking flow — guest count, date selection, summary,
// then POST /api/bookings (see API contract draft, TICKET-013). Payment
// (PayFast redirect) is a later, separate step per the plan's Section 3.1
// (payment is the last swap, not the first) — this page hands off to
// Confirmation.vue once the booking itself is created.

const router = useRouter()
const cart = useCartStore()
const bookings = useBookingsStore()
const auth = useAuthStore()

// Default to the guest count already set per-package on PackageDetail/Cart
// (the largest of them, if packages differ) rather than a fixed 20, so the
// number shown here doesn't silently disagree with what the customer saw
// in their cart.
const cartGuestCounts = cart.items.map((item) => item.guest_count).filter(Boolean)
const guestCount = ref(cartGuestCounts.length ? Math.max(...cartGuestCounts) : 20)
const eventDate = ref('')
const eventTime = ref('')
const specialRequests = ref('')
const contactName = ref('')
// Logged-in users shouldn't have to retype an email we already have —
// prefill from the auth store. Still an editable field (in case someone
// wants the confirmation to go to a different address), just not blank.
const contactEmail = ref(auth.user?.email || '')
const contactPhone = ref('')

const error = ref('')
const isSubmitting = ref(false)

// Formats a Date as a local YYYY-MM-DD string (not toISOString, which
// shifts by the browser's UTC offset and can land on the wrong day).
function toDateInputValue(date) {
  const y = date.getFullYear()
  const m = String(date.getMonth() + 1).padStart(2, '0')
  const d = String(date.getDate()).padStart(2, '0')
  return `${y}-${m}-${d}`
}

// Bookings can't be made for any date in the current week — the earliest
// selectable date is always the Monday of *next* week, regardless of what
// day today is. This gives the kitchen/staffing team a guaranteed minimum
// lead time instead of same-week or next-day bookings slipping through.
const now = new Date()
const dayOfWeek = now.getDay() // Sun=0 .. Sat=6
const daysSinceMonday = (dayOfWeek + 6) % 7 // Mon=0 .. Sun=6
const currentWeekMonday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - daysSinceMonday)
const nextWeekMonday = new Date(currentWeekMonday)
nextWeekMonday.setDate(currentWeekMonday.getDate() + 7)

const minBookableDate = toDateInputValue(nextWeekMonday)
const minBookableDateLabel = nextWeekMonday.toLocaleDateString('en-ZA', {
  weekday: 'long',
  day: 'numeric',
  month: 'long',
  year: 'numeric',
})

// Each cart item keeps its own guest_count (set per-package on
// PackageDetail), and this field is the single "overall event" guest count
// shown here. Since one event only has one guest count, moving this
// stepper pushes the new value onto every cart item via setGuestCount()
// below — that keeps pricing (and the Cart page, if the customer goes back)
// in sync with what's shown here instead of silently ignoring it.
const subtotal = computed(() =>
  cart.items.reduce((sum, pkg) => sum + pkg.base_price * (pkg.guest_count || guestCount.value), 0),
)

// Applies a new guest count both to the field shown here and to every
// package in the cart, so the Subtotal/Total actually move when this is
// changed instead of staying pinned to whatever was set back on
// PackageDetail.
function setGuestCount(value) {
  const next = Math.max(1, Number(value) || 1)
  guestCount.value = next
  cart.items.forEach((_, index) => cart.updateGuestCount(index, next))
}

const serviceFee = computed(() => Math.round(subtotal.value * 0.05))

const couponInput = ref('')
const appliedCoupon = ref(null)
const couponError = ref('')

const discount = computed(() =>
  appliedCoupon.value ? Math.round(subtotal.value * appliedCoupon.value.discountRate) : 0,
)

const total = computed(() => subtotal.value + serviceFee.value - discount.value)

function applyCoupon() {
  couponError.value = ''
  if (!couponInput.value.trim()) return
  const result = validateCoupon(couponInput.value)
  if (!result.valid) {
    couponError.value = result.message
    appliedCoupon.value = null
    return
  }
  appliedCoupon.value = { code: result.code, discountRate: result.discountRate, message: result.message }
  couponInput.value = ''
}

function removeCoupon() {
  appliedCoupon.value = null
  couponError.value = ''
}

function removePackage(index) {
  cart.removeItem(index)
}

async function handleSubmit() {
  error.value = ''

  // Guest checkout: no account is required to select and pay for a
  // package — the backend accepts bookings without a token and attaches
  // them to the contact details entered below.
  if (!cart.items.length) {
    error.value = 'Your cart is empty — add a package before checking out.'
    return
  }
  if (!eventDate.value) {
    error.value = 'Please choose an event date.'
    return
  }
  if (eventDate.value < minBookableDate) {
    error.value = `We can't take bookings for the current week — please choose a date on or after ${minBookableDateLabel}.`
    return
  }
  if (guestCount.value < 1) {
    error.value = 'Guest count must be at least 1.'
    return
  }
  if (!contactName.value || !contactPhone.value || !contactEmail.value) {
    error.value = 'Please add a contact name, email and phone number.'
    return
  }
  if (!/^\S+@\S+\.\S+$/.test(contactEmail.value)) {
    error.value = 'Please enter a valid email address.'
    return
  }

  isSubmitting.value = true

  try {
    // Server recomputes prices/service fee/coupon discount from scratch —
    // this payload's total/discount fields are for display only, the
    // amount PayFast actually charges comes from the backend.
    const payload = {
      event_date: eventDate.value,
      event_time: eventTime.value || null,
      guest_count: guestCount.value,
      special_requests: specialRequests.value || null,
      contact_name: contactName.value,
      contact_email: contactEmail.value,
      contact_phone: contactPhone.value,
      coupon_code: appliedCoupon.value?.code || null,
      items: cart.items.map((item) => ({
        package_id: item.package_id,
        guest_count: item.guest_count || guestCount.value,
      })),
    }

    const booking = await bookings.createBooking(payload)
    cart.clear()
    // Hands off to the real PayFast sandbox redirect (src/views/Payment.vue),
    // which calls POST /api/payments/initiate and auto-submits the hidden
    // form to PayFast's hosted payment page.
    router.push(`/payment/${booking.booking_id}`)
  } catch (err) {
    error.value = err.message || 'Something went wrong creating your booking. Please try again.'
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <main id="main-content" class="checkout">
    <header class="checkout__header">
      <h1>Checkout</h1>
      <p>Confirm your guest count and event date, then review your booking summary.</p>
    </header>

    <div v-if="!cart.items.length" class="checkout__empty">
      <p>Your cart is empty.</p>
      <RouterLink to="/packages" class="checkout__browse-link">Browse Packages</RouterLink>
    </div>

    <form v-else class="checkout__layout" @submit.prevent="handleSubmit">
      <div class="checkout__form-col">
        <p v-if="error" class="checkout__error" role="alert">{{ error }}</p>

        <section class="checkout__section">
          <h2 class="checkout__section-title">Event Details</h2>

          <div class="checkout__field-row">
            <label class="checkout__field">
              <span class="checkout__label">Event Date</span>
              <input v-model="eventDate" type="date" :min="minBookableDate" required />
              <span class="checkout__hint">
                Earliest available date is {{ minBookableDateLabel }} — we can't book the current
                week.
              </span>
            </label>

            <label class="checkout__field">
              <span class="checkout__label">Preferred Time</span>
              <input v-model="eventTime" type="time" />
            </label>
          </div>

          <label class="checkout__field">
            <span class="checkout__label">Guest Count</span>
            <div class="checkout__stepper">
              <button
                type="button"
                class="checkout__stepper-btn"
                :disabled="guestCount <= 1"
                @click="setGuestCount(guestCount - 5)"
              >
                −
              </button>
              <input
                :value="guestCount"
                type="number"
                min="1"
                class="checkout__stepper-input"
                @change="setGuestCount($event.target.value)"
              />
              <button type="button" class="checkout__stepper-btn" @click="setGuestCount(guestCount + 5)">
                +
              </button>
            </div>
          </label>

          <label class="checkout__field">
            <span class="checkout__label">Special Requests (optional)</span>
            <textarea
              v-model="specialRequests"
              rows="3"
              placeholder="Dietary requirements, venue access notes, timing preferences..."
            ></textarea>
          </label>
        </section>

        <section class="checkout__section">
          <h2 class="checkout__section-title">Contact Details</h2>

          <div class="checkout__field-row">
            <label class="checkout__field">
              <span class="checkout__label">Full Name</span>
              <input v-model="contactName" type="text" placeholder="Your name" required />
            </label>

            <label class="checkout__field">
              <span class="checkout__label">Phone Number</span>
              <input v-model="contactPhone" type="tel" placeholder="e.g. 082 123 4567" required />
            </label>
          </div>

          <label class="checkout__field">
            <span class="checkout__label">Email Address</span>
            <input
              v-model="contactEmail"
              type="email"
              placeholder="you@example.com"
              autocomplete="email"
              required
            />
            <span class="checkout__hint">
              <template v-if="auth.isLoggedIn">
                Using the email on your account — we'll send your booking confirmation here.
              </template>
              <template v-else> We'll send your booking confirmation here. </template>
            </span>
          </label>
        </section>
      </div>

      <aside class="checkout__summary">
        <h2 class="checkout__section-title">Booking Summary</h2>

        <ul class="checkout__items">
          <li v-for="(pkg, index) in cart.items" :key="`${pkg.package_id}-${index}`" class="checkout__item">
            <img :src="pkg.image_url" :alt="pkg.name" class="checkout__item-image" />
            <div class="checkout__item-body">
              <p class="checkout__item-name">{{ pkg.name }}</p>
              <p class="checkout__item-meta">R{{ pkg.base_price }} / person</p>
            </div>
            <button
              type="button"
              class="checkout__item-remove"
              aria-label="Remove package"
              @click="removePackage(index)"
            >
              ✕
            </button>
          </li>
        </ul>

        <div class="checkout__coupon">
          <template v-if="!appliedCoupon">
            <label class="checkout__field">
              <span class="checkout__label">Promo Code</span>
              <div class="checkout__coupon-row">
                <input v-model="couponInput" type="text" placeholder="e.g. OCCASION10" @keyup.enter.prevent="applyCoupon" />
                <button type="button" class="checkout__coupon-apply" @click="applyCoupon">Apply</button>
              </div>
            </label>
            <p v-if="couponError" class="checkout__coupon-error" role="alert">{{ couponError }}</p>
          </template>
          <div v-else class="checkout__coupon-applied">
            <span>“{{ appliedCoupon.code }}” applied — {{ appliedCoupon.message }}</span>
            <button type="button" class="checkout__coupon-remove" @click="removeCoupon">Remove</button>
          </div>
        </div>

        <dl class="checkout__totals">
          <div class="checkout__totals-row">
            <dt>Guests</dt>
            <dd>{{ guestCount }}</dd>
          </div>
          <div class="checkout__totals-row">
            <dt>Subtotal</dt>
            <dd>R{{ subtotal.toLocaleString() }}</dd>
          </div>
          <div class="checkout__totals-row">
            <dt>Service Fee (5%)</dt>
            <dd>R{{ serviceFee.toLocaleString() }}</dd>
          </div>
          <div v-if="appliedCoupon" class="checkout__totals-row checkout__totals-row--discount">
            <dt>Discount ({{ appliedCoupon.code }})</dt>
            <dd>−R{{ discount.toLocaleString() }}</dd>
          </div>
          <div class="checkout__totals-row checkout__totals-row--total">
            <dt>Total</dt>
            <dd>R{{ total.toLocaleString() }}</dd>
          </div>
        </dl>

        <button type="submit" class="checkout__submit" :disabled="isSubmitting">
          {{ isSubmitting ? 'Placing Booking…' : 'Confirm Booking' }}
        </button>
        <p class="checkout__disclaimer">
          You'll be redirected to secure payment after confirming your booking details.
        </p>
      </aside>
    </form>
  </main>
</template>

<style scoped>
.checkout {
  max-width: var(--content-width);
  margin: 0 auto;
  padding: 2.5rem 1.5rem 4rem;
}

.checkout__header {
  margin-bottom: 2rem;
}

.checkout__header h1 {
  font-size: 2rem;
  margin-bottom: 0.4rem;
}

.checkout__header p {
  color: var(--color-muted);
  font-size: 0.95rem;
}

.checkout__empty {
  text-align: center;
  padding: 4rem 0;
  color: var(--color-muted);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.checkout__coupon {
  border-top: 1px solid var(--color-line);
  border-bottom: 1px solid var(--color-line);
  padding: 1rem 0;
  margin: 0.25rem 0;
}

.checkout__coupon-row {
  display: flex;
  gap: 0.5rem;
}

.checkout__coupon-row input {
  flex: 1;
  border: 1px solid var(--color-line);
  border-radius: var(--radius-sm);
  padding: 0.6rem 0.75rem;
  font-family: var(--font-body);
  font-size: 0.85rem;
}

.checkout__coupon-apply {
  border: 1px solid var(--color-brown-deep);
  background: var(--color-brown-deep);
  color: var(--color-cream);
  border-radius: var(--radius-sm);
  padding: 0.6rem 1rem;
  font-size: 0.85rem;
  font-weight: 600;
  white-space: nowrap;
}

.checkout__coupon-error {
  font-size: 0.78rem;
  color: #a63d3d;
  margin-top: 0.4rem;
}

.checkout__coupon-applied {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.75rem;
  font-size: 0.82rem;
  color: #3e9a5f;
  font-weight: 500;
}

.checkout__coupon-remove {
  background: none;
  border: none;
  color: var(--color-muted);
  font-size: 0.78rem;
  text-decoration: underline;
  white-space: nowrap;
}

.checkout__totals-row--discount {
  color: #3e9a5f;
}

.checkout__browse-link {
  background: var(--color-gold);
  color: var(--color-brown-deep);
  font-weight: 600;
  border-radius: var(--radius-full);
  padding: 0.7rem 1.5rem;
}

.checkout__layout {
  display: grid;
  grid-template-columns: 1.6fr 1fr;
  gap: 2rem;
  align-items: start;
}

.checkout__form-col {
  display: flex;
  flex-direction: column;
  gap: 1.75rem;
}

.checkout__error {
  background: #fbeaea;
  color: #a63d3d;
  border-radius: var(--radius-sm);
  padding: 0.65rem 0.9rem;
  font-size: 0.85rem;
}

.checkout__section {
  background: var(--color-white);
  border: 1px solid var(--color-line);
  border-radius: var(--radius-md);
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1.1rem;
}

.checkout__section-title {
  font-size: 1.15rem;
  margin-bottom: 0.25rem;
}

.checkout__field-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.checkout__field {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.checkout__label {
  font-size: 0.85rem;
  font-weight: 600;
}

.checkout__field input,
.checkout__field textarea {
  border: 1px solid var(--color-line);
  border-radius: var(--radius-sm);
  padding: 0.7rem 0.9rem;
  font-family: var(--font-body);
  font-size: 0.9rem;
  color: var(--color-ink);
  background: var(--color-white);
}

.checkout__field input:focus,
.checkout__field textarea:focus {
  outline: none;
  border-color: var(--color-gold);
}

.checkout__field textarea {
  resize: vertical;
}

.checkout__hint {
  font-size: 0.78rem;
  color: var(--color-muted);
}

.checkout__stepper {
  display: flex;
  align-items: center;
  gap: 0.6rem;
}

.checkout__stepper-btn {
  width: 2.4rem;
  height: 2.4rem;
  border-radius: var(--radius-sm);
  border: 1px solid var(--color-line);
  background: var(--color-white);
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--color-brown);
  flex-shrink: 0;
}

.checkout__stepper-btn:hover:not(:disabled) {
  border-color: var(--color-gold);
  color: var(--color-gold);
}

.checkout__stepper-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.checkout__stepper-input {
  width: 5rem;
  text-align: center;
  border: 1px solid var(--color-line);
  border-radius: var(--radius-sm);
  padding: 0.6rem;
  font-family: var(--font-body);
  font-size: 0.95rem;
}

.checkout__summary {
  background: var(--color-white);
  border: 1px solid var(--color-line);
  border-radius: var(--radius-md);
  padding: 1.5rem;
  position: sticky;
  top: 5.5rem;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.checkout__items {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.9rem;
}

.checkout__item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.checkout__item-image {
  width: 3rem;
  height: 3rem;
  object-fit: cover;
  border-radius: var(--radius-sm);
  flex-shrink: 0;
}

.checkout__item-body {
  flex: 1;
  min-width: 0;
}

.checkout__item-name {
  font-size: 0.9rem;
  font-weight: 600;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.checkout__item-meta {
  font-size: 0.8rem;
  color: var(--color-muted);
}

.checkout__item-remove {
  background: none;
  border: none;
  color: var(--color-muted);
  font-size: 0.9rem;
  flex-shrink: 0;
  padding: 0.25rem;
}

.checkout__item-remove:hover {
  color: #a63d3d;
}

.checkout__totals {
  border-top: 1px solid var(--color-line);
  padding-top: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.55rem;
}

.checkout__totals-row {
  display: flex;
  justify-content: space-between;
  font-size: 0.88rem;
  color: var(--color-muted);
}

.checkout__totals-row--total {
  border-top: 1px solid var(--color-line);
  padding-top: 0.6rem;
  margin-top: 0.2rem;
  font-size: 1.05rem;
  font-weight: 700;
  color: var(--color-ink);
}

.checkout__submit {
  background: var(--color-gold);
  color: var(--color-brown-deep);
  border: none;
  border-radius: var(--radius-sm);
  padding: 0.85rem;
  font-weight: 700;
  font-size: 1rem;
  transition: box-shadow 0.15s ease, transform 0.15s ease;
}

.checkout__submit:hover:not(:disabled) {
  box-shadow: 0 4px 14px rgba(207, 157, 67, 0.4);
  transform: translateY(-1px);
}

.checkout__submit:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.checkout__disclaimer {
  font-size: 0.78rem;
  color: var(--color-muted);
  text-align: center;
}

@media (max-width: 900px) {
  .checkout__layout {
    grid-template-columns: 1fr;
  }
  .checkout__summary {
    position: static;
  }
}

@media (max-width: 560px) {
  .checkout__field-row {
    grid-template-columns: 1fr;
  }
}
</style>
