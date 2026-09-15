<script setup>
const lastUpdated = 'September 2026'

const sections = [
  {
    title: '1. About These Terms',
    body: [
      'These Terms & Conditions ("Terms") govern your use of the Occasion website and mobile experience (the "Site") and any booking, purchase, or engagement you make with Occasion ("we", "us", "our") for catering packages, large events, small events, or tours (collectively, "Services").',
      'By creating an account, making a booking, or otherwise using the Site, you agree to be bound by these Terms. If you do not agree, please do not use the Site or our Services.',
    ],
  },
  {
    title: '2. Who Can Use Occasion',
    body: [
      'You must be at least 18 years old, or the age of majority in your jurisdiction, to create an account or make a booking. By registering, you confirm that the information you provide (name, email, phone number, and any other details requested) is accurate and that you will keep it up to date.',
      'You are responsible for keeping your login credentials confidential and for all activity that occurs under your account. Let us know immediately at info@occasion.co.za if you suspect unauthorised use of your account.',
    ],
  },
  {
    title: '3. Bookings and Availability',
    body: [
      'A booking request is only confirmed once you have completed payment (or the applicable deposit, where offered) and received a confirmation with a booking reference number. Until then, dates and packages are not guaranteed and remain subject to availability.',
      'You are responsible for the accuracy of the event date, time, guest count, contact details, and any special requests submitted at checkout. Errors identified after confirmation may incur additional charges or require rescheduling, subject to availability.',
      'We reserve the right to decline or cancel a booking — for example, where the requested date or guest count cannot reasonably be accommodated, where information provided is false or incomplete, or where a booking appears fraudulent. If we cancel a confirmed, paid booking through no fault of yours, we will provide a full refund of amounts paid for that booking.',
    ],
  },
  {
    title: '4. Pricing and Payment',
    body: [
      'Prices are shown in South African Rand (ZAR) and include applicable taxes unless stated otherwise. Package prices are typically shown per person; your total reflects the package price, guest count, and any add-ons selected at checkout.',
      'Payments are processed securely through PayFast, a third-party payment gateway. We do not store your full card or bank details on our servers. Once PayFast confirms your payment (including via their server-to-server notification), your booking status updates automatically; in rare cases this can take a short while after your payment completes.',
      'If a payment fails, is cancelled, or cannot be verified, your booking will remain in a pending state and your date will not be secured. You may retry payment from your booking history at any time before your event date, subject to availability.',
    ],
  },
  {
    title: '5. Cancellations, Changes, and Refunds',
    body: [
      'You may request to cancel or amend a booking by contacting us at info@occasion.co.za or 021 712 7373 with your booking reference number. Because catering involves advance purchasing of ingredients and staff scheduling, refund amounts depend on how close to the event date the cancellation is requested:',
      '• More than 14 days before the event: full refund, less any non-recoverable third-party costs already incurred.',
      '• 7–14 days before the event: 50% refund.',
      '• Less than 7 days before the event: refunds are assessed case by case and are not guaranteed, as ingredients and staffing are typically already committed.',
      'Approved refunds are returned to the original payment method via PayFast and may take several business days to reflect, depending on your bank.',
      'If we are unable to deliver the Services you booked due to a cause within our control, you are entitled to a full refund or, where you prefer, a rescheduled booking of equivalent value.',
    ],
  },
  {
    title: '6. Your Responsibilities on the Day',
    body: [
      'Please tell us about any dietary requirements, allergies, or intolerances among your guests as early as possible, and no later than the timeframe stated on your package or communicated to you by our team — we cannot guarantee changes made with insufficient notice.',
      'Where an event takes place at a venue you have arranged, you are responsible for ensuring the venue is accessible, safe, and suitable for our team to set up, prepare, and serve food (including any required permissions, power, water, and space).',
      'You are responsible for the conduct of your guests. We reserve the right to pause or end service if our staff or equipment are put at risk, or if the venue or guest conduct is unsafe.',
    ],
  },
  {
    title: '7. Allergies and Food Safety',
    body: [
      'We take food safety seriously and follow standard hygiene practices in preparing and serving our menus. However, our kitchens and events handle a wide range of ingredients, and we cannot guarantee a completely allergen-free environment.',
      'If any guest has a severe allergy, please flag this explicitly when booking and again with our on-site team, so we can take extra precautions. The final decision on whether a dish is safe for a specific guest rests with that guest and, where relevant, their caregiver or medical adviser.',
    ],
  },
  {
    title: '8. Intellectual Property',
    body: [
      'All content on the Site — including text, recipes, photography, package descriptions, logos, and design — belongs to Occasion or its licensors and is protected by copyright and other intellectual property laws. You may not copy, reproduce, or use this content commercially without our written permission.',
    ],
  },
  {
    title: '9. Limitation of Liability',
    body: [
      'To the fullest extent permitted by law, Occasion will not be liable for any indirect, incidental, or consequential loss arising from your use of the Site or our Services, including loss of enjoyment of an event caused by circumstances outside our reasonable control (such as extreme weather, load-shedding, or third-party venue issues).',
      'Nothing in these Terms limits liability that cannot lawfully be limited, including liability for death or personal injury caused by our negligence, or liability arising from gross negligence or wilful misconduct.',
    ],
  },
  {
    title: '10. Changes to These Terms',
    body: [
      `We may update these Terms from time to time to reflect changes in our Services, legal requirements, or business practices. The "last updated" date at the top of this page shows when the Terms were last revised. Continuing to use the Site after changes take effect means you accept the updated Terms.`,
    ],
  },
  {
    title: '11. Contact Us',
    body: [
      'If you have questions about these Terms, please reach out:',
      'Email: info@occasion.co.za',
      'Phone: 021 712 7373',
      'Address: Cape Town, South Africa',
    ],
  },
]
</script>

<template>
  <main id="main-content" class="legal">
    <section class="legal__hero">
      <p class="legal__eyebrow">Legal</p>
      <h1 class="legal__title">Terms &amp; Conditions</h1>
      <p class="legal__updated">Last updated: {{ lastUpdated }}</p>
    </section>

    <section class="legal__body">
      <p class="legal__intro">
        Please read these Terms carefully before booking with Occasion. They explain how
        bookings, payments, cancellations, and your use of this Site work.
      </p>

      <article v-for="section in sections" :key="section.title" class="legal__section">
        <h2>{{ section.title }}</h2>
        <p v-for="(paragraph, index) in section.body" :key="index">{{ paragraph }}</p>
      </article>
    </section>
  </main>
</template>

<style scoped>
.legal {
  padding-bottom: 4rem;
}

.legal__hero {
  background: var(--color-cream-soft);
  border-bottom: 1px solid var(--color-line);
  padding: 3.5rem 1.5rem 2.5rem;
  text-align: center;
}

.legal__eyebrow {
  color: var(--color-gold);
  font-weight: 600;
  font-size: 0.85rem;
  margin-bottom: 0.4rem;
}

.legal__title {
  font-size: 2.2rem;
  margin-bottom: 0.4rem;
}

.legal__updated {
  color: var(--color-muted);
  font-size: 0.9rem;
}

.legal__body {
  max-width: 42rem;
  margin: 2.5rem auto 0;
  padding: 0 1.5rem;
}

.legal__intro {
  color: var(--color-muted);
  margin-bottom: 2rem;
  font-size: 1rem;
}

.legal__section {
  margin-bottom: 2.2rem;
}

.legal__section h2 {
  font-size: 1.2rem;
  margin-bottom: 0.7rem;
  color: var(--color-brown-deep);
}

.legal__section p {
  font-size: 0.95rem;
  line-height: 1.7;
  color: var(--color-ink, #2c2420);
  margin-bottom: 0.6rem;
}

@media (max-width: 560px) {
  .legal__title {
    font-size: 1.7rem;
  }
}
</style>
