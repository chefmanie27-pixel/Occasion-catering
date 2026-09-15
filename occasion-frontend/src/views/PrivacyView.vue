<script setup>
const lastUpdated = 'September 2026'

const sections = [
  {
    title: '1. Introduction',
    body: [
      'This Privacy Policy explains how Occasion ("we", "us", "our") collects, uses, stores, and protects your personal information when you use our website and Services, in line with South Africa\'s Protection of Personal Information Act (POPIA).',
      'By using the Site or making a booking, you consent to the collection and use of your information as described here. If you do not agree, please do not provide your personal information or use the Site.',
    ],
  },
  {
    title: '2. Information We Collect',
    body: [
      'Account information: your name, email address, phone number, and password (stored in encrypted/hashed form, never as plain text).',
      'Booking information: event date, time, guest count, contact details, special requests, and the packages or services you select.',
      'Payment information: we do not store your card or bank account details. Payments are processed by PayFast, our third-party payment provider, who handle and secure this information under their own privacy and security policies.',
      'Communications: messages you send us via email, phone, or contact forms, which we may keep for record-keeping and customer service purposes.',
      'Technical information: basic usage data such as browser type and pages visited, which helps us keep the Site working properly and secure.',
    ],
  },
  {
    title: '3. How We Use Your Information',
    body: [
      'To create and manage your account, and to process, confirm, and fulfil your bookings.',
      'To communicate with you about your booking — confirmations, reminders, changes, or issues that need your attention.',
      'To respond to enquiries, complaints, or support requests.',
      'To send you marketing communications (such as our newsletter) only where you have opted in — you can unsubscribe at any time.',
      'To detect, investigate, and prevent fraud, abuse, or security incidents.',
      'To meet our legal, tax, and accounting obligations.',
    ],
  },
  {
    title: '4. Sharing Your Information',
    body: [
      'We do not sell your personal information. We share it only where necessary, including with:',
      '• PayFast, to process your payments securely.',
      '• Service providers who help us run the Site (such as hosting and email delivery), bound by confidentiality and data protection obligations.',
      '• Legal or regulatory authorities, where required by law or to protect our rights, safety, or property.',
    ],
  },
  {
    title: '5. Data Security',
    body: [
      'We use reasonable technical and organisational measures to protect your personal information, including encrypted password storage and secure connections (HTTPS) for data in transit. No system is completely secure, but we work to keep your information safe and to respond quickly if something goes wrong.',
    ],
  },
  {
    title: '6. Data Retention',
    body: [
      'We keep your personal information for as long as your account is active, and for a reasonable period afterward to meet legal, tax, dispute-resolution, and record-keeping requirements. You can ask us to delete your account and associated personal information at any time, subject to information we are legally required to retain.',
    ],
  },
  {
    title: '7. Your Rights',
    body: [
      'Under POPIA, you have the right to:',
      '• Access the personal information we hold about you.',
      '• Ask us to correct or update inaccurate or incomplete information.',
      '• Ask us to delete your personal information, subject to legal retention requirements.',
      '• Object to certain processing, including marketing communications.',
      '• Lodge a complaint with the Information Regulator of South Africa if you believe your information has been mishandled.',
      'To exercise any of these rights, contact us using the details below.',
    ],
  },
  {
    title: '8. Cookies',
    body: [
      'We use essential cookies and similar technologies to keep you logged in, remember items in your cart, and understand basic Site usage. You can control cookies through your browser settings, though some features of the Site may not work correctly if you disable them.',
    ],
  },
  {
    title: '9. Children\'s Privacy',
    body: [
      'Our Services are intended for adults making bookings on behalf of themselves or an organisation. We do not knowingly collect personal information from children without appropriate consent.',
    ],
  },
  {
    title: '10. Changes to This Policy',
    body: [
      `We may update this Privacy Policy from time to time to reflect changes in our practices or legal requirements. The "last updated" date at the top shows when it was last revised. We encourage you to review this page periodically.`,
    ],
  },
  {
    title: '11. Contact Us',
    body: [
      'If you have questions about this Privacy Policy or how we handle your personal information, please contact us:',
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
      <h1 class="legal__title">Privacy Policy</h1>
      <p class="legal__updated">Last updated: {{ lastUpdated }}</p>
    </section>

    <section class="legal__body">
      <p class="legal__intro">
        Your privacy matters to us. This policy explains what personal information we
        collect, why we collect it, and how we protect it.
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
