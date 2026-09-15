<script setup>
import { ref } from 'vue'
import { RouterLink } from 'vue-router'

const email = ref('')
const subscribed = ref(false)

function handleSubscribe() {
  if (!email.value) return
  // Wired to a real endpoint once the backend newsletter route exists.
  subscribed.value = true
  email.value = ''
}

const quickLinks = [
  { to: '/', label: 'Home' },
  { to: '/packages', label: 'Packages' },
  { to: '/large-events', label: 'Large Events' },
  { to: '/small-events', label: 'Small Events' },
  { to: '/tours', label: 'Tours' },
  { to: '/about', label: 'About Us' },
]
</script>

<template>
  <footer class="footer">
    <div class="footer__grid">
      <div class="footer__brand">
        <div class="footer__brand-name">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path
              d="M12 3c-4 0-6 3.5-6 7v3l-2 3h16l-2-3v-3c0-3.5-2-7-6-7Z"
              stroke="var(--color-gold)"
              stroke-width="1.6"
              stroke-linejoin="round"
            />
          </svg>
          Occasion
        </div>
        <p class="footer__blurb">
          Your local partner in creating unforgettable moments with delicious food and warm
          South African hospitality.
        </p>
        <div class="footer__social">
          <a href="#" aria-label="Facebook">FB</a>
          <a href="#" aria-label="Instagram">IG</a>
          <a href="#" aria-label="Phone">Tel</a>
          <a href="#" aria-label="Email">Mail</a>
        </div>
      </div>

      <div class="footer__col">
        <h3>Quick Links</h3>
        <ul>
          <li v-for="link in quickLinks" :key="link.to">
            <RouterLink :to="link.to">{{ link.label }}</RouterLink>
          </li>
        </ul>
      </div>

      <div class="footer__col">
        <h3>Contact Us</h3>
        <ul class="footer__contact">
          <li>021 712 7373</li>
          <li>info@occasion.co.za</li>
          <li>Cape Town, South Africa</li>
        </ul>
      </div>

      <div class="footer__col footer__newsletter">
        <h3>Newsletter</h3>
        <p>Subscribe for updates and exclusive offers.</p>
        <form class="footer__form" @submit.prevent="handleSubscribe">
          <input
            v-model="email"
            type="email"
            placeholder="Your email address"
            required
            aria-label="Email address"
          />
          <button type="submit">Subscribe</button>
        </form>
        <p v-if="subscribed" class="footer__confirm">You're on the list.</p>
      </div>
    </div>

    <div class="footer__bottom">
      <span>&copy; {{ new Date().getFullYear() }} Occasion. All rights reserved.</span>
      <span class="footer__legal">
        <RouterLink to="/terms">Terms &amp; Conditions</RouterLink>
        <RouterLink to="/privacy">Privacy Policy</RouterLink>
      </span>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  background: var(--color-brown-deep);
  color: var(--color-cream-soft);
  margin-top: auto;
}

.footer__grid {
  max-width: var(--content-width);
  margin: 0 auto;
  padding: 3rem 1.5rem 2rem;
  display: grid;
  grid-template-columns: 1.5fr 1fr 1fr 1.3fr;
  gap: 2rem;
}

.footer__brand-name {
  font-family: var(--font-display);
  font-size: 1.2rem;
  font-weight: 700;
  color: var(--color-white);
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.75rem;
}

.footer__blurb {
  font-size: 0.85rem;
  color: var(--color-cream-soft);
  opacity: 0.75;
  max-width: 28ch;
  margin-bottom: 1rem;
}

.footer__social {
  display: flex;
  gap: 0.75rem;
}

.footer__social a {
  font-size: 0.75rem;
  color: var(--color-gold-soft);
  border: 1px solid rgba(227, 192, 127, 0.35);
  border-radius: var(--radius-full);
  width: 1.9rem;
  height: 1.9rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.footer__col h3 {
  font-family: var(--font-body);
  font-size: 0.9rem;
  color: var(--color-gold);
  font-weight: 600;
  margin-bottom: 0.9rem;
}

.footer__col ul {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.55rem;
}

.footer__col a,
.footer__contact li {
  font-size: 0.85rem;
  color: var(--color-cream-soft);
  opacity: 0.8;
}

.footer__col a:hover {
  opacity: 1;
  color: var(--color-gold-soft);
}

.footer__newsletter p {
  font-size: 0.85rem;
  opacity: 0.75;
  margin-bottom: 0.9rem;
}

.footer__form {
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.footer__form input {
  border: none;
  border-radius: var(--radius-sm);
  padding: 0.6rem 0.8rem;
  font-size: 0.85rem;
  font-family: var(--font-body);
}

.footer__form button {
  background: var(--color-gold);
  color: var(--color-brown-deep);
  border: none;
  border-radius: var(--radius-sm);
  padding: 0.6rem 0.8rem;
  font-weight: 600;
  font-size: 0.85rem;
}

.footer__confirm {
  margin-top: 0.5rem;
  font-size: 0.8rem;
  color: var(--color-gold-soft);
}

.footer__bottom {
  max-width: var(--content-width);
  margin: 0 auto;
  padding: 1.25rem 1.5rem;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  display: flex;
  justify-content: space-between;
  font-size: 0.78rem;
  opacity: 0.65;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.footer__legal {
  display: flex;
  gap: 1.25rem;
}

@media (max-width: 860px) {
  .footer__grid {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 520px) {
  .footer__grid {
    grid-template-columns: 1fr;
  }
}
</style>
