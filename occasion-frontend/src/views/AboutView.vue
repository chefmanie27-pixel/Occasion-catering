<script setup>
const values = [
  {
    title: 'Quality Ingredients',
    description: 'We use the finest local, flavourful ingredients to create fresh, memorable meals.',
    icon: 'leaf',
  },
  {
    title: 'Exceptional Service',
    description: 'From planning to the last bite, our team is dedicated to a stress-free experience.',
    icon: 'star',
  },
  {
    title: 'Made With Care',
    description: 'Every dish is prepared with passion, attention to detail, and a personal touch.',
    icon: 'heart',
  },
  {
    title: 'Community Focused',
    description: 'We support local suppliers and are proud to celebrate South African flavours.',
    icon: 'people',
  },
]

const stats = [
  { value: '6+', label: "Years of Chef's Experience" },
  { value: '3', label: 'Ways We Cater — Large, Small & Tours' },
  { value: '100%', label: 'Local & Fresh Ingredients' },
  { value: 'New', label: 'Business, Full Passion' },
]
</script>

<template>
  <main id="main-content" class="about">
    <!-- Hero -->
    <section class="hero">
      <div class="hero__text">
        <p class="eyebrow"> About Occasion</p>
        <h1 class="hero__title">Good Food.<br />Great Moments.</h1>
        <p class="hero__subtitle">
          Occasion is a South African catering company passionate about bringing people
          together through exceptional food, warm hospitality, and unforgettable
          experiences. We are fully halaal, sourcing from halaal vendors.
        </p>
        <a href="#story" class="btn btn--primary">Our Story →</a>
      </div>
      <img
        class="hero__image"
        src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=1000&q=80"
        alt="Table set with flowers and candlelight for an outdoor dinner"
      />
    </section>

    <!-- Our Story -->
    <section id="story" class="story">
      <img
        class="story__image"
        src="https://images.unsplash.com/photo-1555244162-803834f70033?auto=format&fit=crop&w=800&q=80"
        alt="Spread of catering dishes served in rustic bowls"
      />
      <div class="story__text">
        <p class="eyebrow"> Our Story </p>
        <h2 class="story__title">From a Simple Idea to Meaningful Moments</h2>
        <p class="story__paragraph">
          Occasion started with a simple belief: every occasion deserves great food
          and genuine care.
        </p>
        <p class="story__paragraph">
          From intimate dinners to large celebrations and tours across beautiful
          landscapes, we've grown by staying true to our values: quality, care, and
          community.
        </p>
        <p class="story__paragraph">
          We're just getting started but every booking gets the same care, quality,
          and attention to detail we'd want for our own occasion.
        </p>
        <p class="story__signature">Thank you for being part of our journey.</p>
      </div>
    </section>

    <!-- What Drives Us -->
    <section class="values">
      <p class="eyebrow eyebrow--center"> Our Values </p>
      <h2 class="values__title">What Drives Us</h2>

      <div class="values__grid">
        <div v-for="value in values" :key="value.title" class="value-card">
          <div class="value-card__icon">
            <svg
              v-if="value.icon === 'leaf'"
              width="22"
              height="22"
              viewBox="0 0 24 24"
              fill="none"
              aria-hidden="true"
            >
              <path
                d="M5 19c8-1 13-6 14-14C11 6 6 11 5 19Z"
                stroke="var(--color-forest)"
                stroke-width="1.6"
                stroke-linejoin="round"
              />
            </svg>
            <svg
              v-else-if="value.icon === 'star'"
              width="22"
              height="22"
              viewBox="0 0 24 24"
              fill="none"
              aria-hidden="true"
            >
              <path
                d="m12 3 2.6 5.8 6.2.6-4.7 4.2 1.4 6.2L12 16.9l-5.5 2.9 1.4-6.2-4.7-4.2 6.2-.6L12 3Z"
                stroke="var(--color-forest)"
                stroke-width="1.6"
                stroke-linejoin="round"
              />
            </svg>
            <svg
              v-else-if="value.icon === 'heart'"
              width="22"
              height="22"
              viewBox="0 0 24 24"
              fill="none"
              aria-hidden="true"
            >
              <path
                d="M12 20s-7-4.4-9.5-9A5 5 0 0 1 12 6a5 5 0 0 1 9.5 5c-2.5 4.6-9.5 9-9.5 9Z"
                stroke="var(--color-forest)"
                stroke-width="1.6"
                stroke-linejoin="round"
              />
            </svg>
            <svg v-else width="22" height="22" viewBox="0 0 24 24" fill="none" aria-hidden="true">
              <circle cx="9" cy="8" r="2.6" stroke="var(--color-forest)" stroke-width="1.6" />
              <circle cx="17" cy="9" r="2.2" stroke="var(--color-forest)" stroke-width="1.6" />
              <path
                d="M3 19c.5-3 2.7-5 6-5s5.5 2 6 5"
                stroke="var(--color-forest)"
                stroke-width="1.6"
                stroke-linecap="round"
              />
              <path
                d="M14.5 14.2c2.6.4 4.2 2.2 4.6 4.8"
                stroke="var(--color-forest)"
                stroke-width="1.6"
                stroke-linecap="round"
              />
            </svg>
          </div>
          <h3 class="value-card__title">{{ value.title }}</h3>
          <p class="value-card__description">{{ value.description }}</p>
        </div>
      </div>
    </section>

    <!-- Why Choose Occasion -->
    <section class="why">
      <div class="why__text">
        <p class="eyebrow">Why Choose Occasion?</p>
        <p class="why__paragraph">
          We go beyond catering — we create experiences that leave lasting memories.
        </p>
      </div>

      <div class="why__stats">
        <div v-for="stat in stats" :key="stat.label" class="why__stat">
          <p class="why__stat-value">{{ stat.value }}</p>
          <p class="why__stat-label">{{ stat.label }}</p>
        </div>
      </div>
    </section>
  </main>
</template>

<style scoped>
.about {
  max-width: var(--content-width);
  margin: 0 auto;
  padding: 2.5rem 1.5rem 4rem;
  display: flex;
  flex-direction: column;
  gap: 4.5rem;
}

.eyebrow {
  color: var(--color-gold);
  font-size: 0.8rem;
  font-weight: 600;
  letter-spacing: 0.08em;
}

.eyebrow--center {
  text-align: center;
}

.btn {
  display: inline-flex;
  align-self: flex-start;
  border-radius: var(--radius-sm);
  padding: 0.75rem 1.5rem;
  font-size: 0.9rem;
  font-weight: 600;
}

.btn--primary {
  background: var(--color-forest);
  color: var(--color-cream);
}

.btn--primary:hover {
  background: var(--color-forest-deep);
}

/* Hero */
.hero {
  display: grid;
  grid-template-columns: 0.85fr 1.15fr;
  gap: 3rem;
  align-items: center;
}

.hero__text {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.hero__title {
  font-size: 2.6rem;
}

.hero__subtitle {
  color: var(--color-muted);
  max-width: 42ch;
}

.hero__image {
  width: 100%;
  height: 100%;
  max-height: 400px;
  object-fit: cover;
  border-radius: var(--radius-md);
}

/* Our Story */
.story {
  display: grid;
  grid-template-columns: 0.9fr 1.1fr;
  gap: 3rem;
  align-items: center;
}

.story__image {
  width: 100%;
  height: 100%;
  max-height: 340px;
  object-fit: cover;
  border-radius: var(--radius-md);
}

.story__text {
  display: flex;
  flex-direction: column;
  gap: 0.85rem;
}

.story__title {
  font-size: 2rem;
  max-width: 16ch;
}

.story__paragraph {
  color: var(--color-muted);
  max-width: 48ch;
}

.story__signature {
  font-family: var(--font-display);
  font-style: italic;
  font-size: 1.15rem;
  color: var(--color-gold);
  margin-top: 0.5rem;
}

/* What Drives Us */
.values {
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.values__title {
  font-size: 2rem;
  margin-bottom: 1rem;
}

.values__grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.5rem;
}

.value-card {
  background: var(--color-cream-soft);
  border-radius: var(--radius-md);
  padding: 2rem 1.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
}

.value-card__icon {
  width: 3rem;
  height: 3rem;
  border-radius: 50%;
  background: var(--color-white);
  display: flex;
  align-items: center;
  justify-content: center;
}

.value-card__title {
  font-size: 1.05rem;
}

.value-card__description {
  color: var(--color-muted);
  font-size: 0.9rem;
}

/* Why Choose Occasion */
.why {
  background: var(--color-cream-soft);
  border-radius: var(--radius-md);
  padding: 2.5rem;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
}

.why__text {
  max-width: 30ch;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.why__paragraph {
  color: var(--color-muted);
  font-size: 0.95rem;
}

.why__stats {
  display: flex;
  gap: 2.5rem;
  flex-wrap: wrap;
}

.why__stat-value {
  font-family: var(--font-display);
  font-size: 1.9rem;
  color: var(--color-gold);
}

.why__stat-label {
  font-size: 0.85rem;
  color: var(--color-muted);
  max-width: 20ch;
}

@media (max-width: 900px) {
  .hero,
  .story {
    grid-template-columns: 1fr;
  }
  .story__image {
    order: -1;
  }
  .values__grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .why {
    flex-direction: column;
    align-items: flex-start;
  }
}

@media (max-width: 560px) {
  .values__grid {
    grid-template-columns: 1fr;
  }
  .why__stats {
    gap: 1.5rem;
  }
}
</style>
