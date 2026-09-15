<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { RouterLink } from 'vue-router'
import { fetchPackages } from '@/services/packages'
import PackageCard from '@/components/packages/PackageCard.vue'
import PackageCardSkeleton from '@/components/packages/PackageCardSkeleton.vue'

// --- Hero carousel -------------------------------------------------------
const heroSlides = [
  {
    image:
      'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=1200&q=80',
    alt: 'Candlelit outdoor dining table set among vineyards',
    eyebrow: '✦ ✦',
    title: 'Plan Your Occasion in Minutes',
    subtitle: 'Fully halaal catering, from halaal vendors, for every event',
    ctaTo: '/large-events',
    ctaLabel: 'Browse Now →',
  },
  {
    image:
      'https://images.unsplash.com/photo-1555244162-803834f70033?auto=format&fit=crop&w=1200&q=80',
    alt: 'Corporate buffet spread set up for a brunch event',
    eyebrow: '✦ ✦',
    title: 'Catering That Fits Your Boardroom',
    subtitle: 'From brunch meetings to full-day conferences',
    ctaTo: '/small-events',
    ctaLabel: 'View Corporate Menus →',
  },
  {
    image:
      'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=1200&q=80',
    alt: 'Intimate candlelit private dinner table setting',
    eyebrow: '✦ ✦',
    title: 'Make Tonight Feel Different',
    subtitle: 'Private dining, plated course by course, at home',
    ctaTo: '/small-events',
    ctaLabel: 'Explore Private Dinners →',
  },
]

const activeSlide = ref(0)
const isPaused = ref(false)
let slideTimer = null

function goToSlide(index) {
  activeSlide.value = (index + heroSlides.length) % heroSlides.length
  restartAutoplay()
}

function nextSlide() {
  goToSlide(activeSlide.value + 1)
}

function prevSlide() {
  goToSlide(activeSlide.value - 1)
}

function restartAutoplay() {
  clearInterval(slideTimer)
  if (!isPaused.value) {
    slideTimer = setInterval(nextSlide, 6000)
  }
}

function pauseAutoplay() {
  clearInterval(slideTimer)
}

function togglePause() {
  isPaused.value = !isPaused.value
  if (isPaused.value) {
    pauseAutoplay()
  } else {
    restartAutoplay()
  }
}

onMounted(restartAutoplay)

// Without this, navigating away from Home doesn't stop the carousel's
// setInterval — it keeps firing in the background for the rest of the
// session (reassigning activeSlide on a ref nothing renders anymore),
// which is wasted work at best and a leak if the component ever remounts.
onBeforeUnmount(() => clearInterval(slideTimer))

// --- Package grid: async load with loading / error / empty states -------
// Homepage shows only the curated `featured` set (is_featured in the DB); the
// full, filterable catalogue lives on the /packages page.
const allPackages = ref([])
const status = ref('loading') // 'loading' | 'success' | 'error'

async function loadPackages() {
  status.value = 'loading'
  try {
    allPackages.value = await fetchPackages()
    status.value = 'success'
  } catch {
    status.value = 'error'
  }
}

onMounted(loadPackages)

const featuredPackages = computed(() => allPackages.value.filter((pkg) => pkg.featured))
</script>

<template>
  <main id="main-content">
    <section
      class="hero"
      aria-roledescription="carousel"
      aria-label="Featured event types"
      @mouseenter="pauseAutoplay"
      @mouseleave="!isPaused && restartAutoplay()"
      @focusin="pauseAutoplay"
      @focusout="!isPaused && restartAutoplay()"
    >
      <div
        v-for="(slide, index) in heroSlides"
        :key="slide.title"
        class="hero__slide"
        :class="{ 'hero__slide--active': index === activeSlide }"
        :aria-hidden="index !== activeSlide"
      >
        <div class="hero__panel">
          <p class="hero__eyebrow">{{ slide.eyebrow }}</p>
          <h1 class="hero__title">{{ slide.title }}</h1>
          <p class="hero__subtitle">{{ slide.subtitle }}</p>
          <RouterLink :to="slide.ctaTo" class="hero__cta">{{ slide.ctaLabel }}</RouterLink>
        </div>
        <img
          class="hero__image"
          :src="slide.image"
          :alt="slide.alt"
          :loading="index === 0 ? 'eager' : 'lazy'"
          :fetchpriority="index === 0 ? 'high' : 'auto'"
        />
      </div>

      <button class="hero__arrow hero__arrow--prev" aria-label="Previous slide" @click="prevSlide">
        ‹
      </button>
      <button class="hero__arrow hero__arrow--next" aria-label="Next slide" @click="nextSlide">
        ›
      </button>
      <button
        class="hero__pause"
        :aria-label="isPaused ? 'Play slideshow' : 'Pause slideshow'"
        @click="togglePause"
      >
        {{ isPaused ? '▶' : '❚❚' }}
      </button>

      <div class="hero__dots" role="tablist" aria-label="Choose a slide">
        <button
          v-for="(slide, index) in heroSlides"
          :key="`dot-${slide.title}`"
          class="hero__dot"
          :class="{ 'hero__dot--active': index === activeSlide }"
          role="tab"
          :aria-selected="index === activeSlide"
          :aria-label="`Show slide ${index + 1}: ${slide.title}`"
          @click="goToSlide(index)"
        ></button>
      </div>
    </section>

    <section class="packages">
      <div class="packages__header">
        <div>
          <p class="packages__eyebrow">Handpicked For You</p>
          <h2 class="packages__title">Featured Packages</h2>
        </div>
        <RouterLink to="/packages" class="packages__view-all">View All Packages →</RouterLink>
      </div>

      <div v-if="status === 'loading'" class="packages__grid" aria-busy="true">
        <PackageCardSkeleton v-for="n in 4" :key="n" />
      </div>

      <div v-else-if="status === 'error'" class="packages__state">
        <p>Couldn't load packages right now.</p>
        <button class="packages__retry" @click="loadPackages">Try Again</button>
      </div>

      <template v-else>
        <div v-if="featuredPackages.length" class="packages__grid">
          <PackageCard v-for="pkg in featuredPackages" :key="pkg.package_id" :pkg="pkg" />
        </div>
        <div v-else class="packages__state">
          <p>No featured packages right now.</p>
          <RouterLink to="/packages" class="packages__retry">View All Packages</RouterLink>
        </div>
      </template>
    </section>

    <section class="tour-banner">
      <img
        class="tour-banner__image"
        src="https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=1400&q=80"
        alt="African savanna at sunset"
        loading="lazy"
      />
      <div class="tour-banner__overlay">
        <p class="tour-banner__eyebrow">For Tour Operators</p>
        <h2 class="tour-banner__title">Special Tour Food Packages</h2>
        <p class="tour-banner__subtitle">
          En-route dining options customised for luxury private game reserves and day-tour
          operators.
        </p>
        <RouterLink to="/tours" class="tour-banner__cta">Explore Tours →</RouterLink>
      </div>
    </section>
  </main>
</template>

<style scoped>
main {
  max-width: var(--content-width);
  margin: 0 auto;
  padding: 1.5rem;
  width: 100%;
}

/* Hero carousel */
.hero {
  position: relative;
  border-radius: var(--radius-md);
  overflow: hidden;
  min-height: 340px;
}

.hero__slide {
  position: absolute;
  inset: 0;
  display: grid;
  grid-template-columns: 1fr 1fr;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.5s ease;
}

.hero__slide--active {
  position: relative;
  opacity: 1;
  visibility: visible;
}

.hero__image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  grid-column: 1 / -1;
  grid-row: 1;
  min-height: 340px;
}

.hero__panel {
  grid-column: 1 / -1;
  grid-row: 1;
  z-index: 2;
  background: linear-gradient(
    100deg,
    rgba(20, 38, 29, 0.92) 0%,
    rgba(20, 38, 29, 0.75) 45%,
    rgba(20, 38, 29, 0) 75%
  );
  color: var(--color-cream);
  padding: 2.5rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 0.9rem;
  max-width: 60%;
}

.hero__eyebrow {
  color: var(--color-gold);
  letter-spacing: 0.15em;
}

.hero__title {
  font-size: 2.2rem;
  color: var(--color-white);
  max-width: 14ch;
}

.hero__subtitle {
  font-size: 0.95rem;
  opacity: 0.9;
  max-width: 34ch;
}

.hero__cta {
  align-self: flex-start;
  background: var(--color-gold);
  color: var(--color-brown-deep);
  font-weight: 600;
  border-radius: var(--radius-full);
  padding: 0.75rem 1.5rem;
  margin-top: 0.5rem;
}

.hero__cta:hover {
  box-shadow: 0 4px 14px rgba(207, 157, 67, 0.4);
}

.hero__arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  z-index: 3;
  width: 2.2rem;
  height: 2.2rem;
  border-radius: 50%;
  border: none;
  background: rgba(255, 255, 255, 0.85);
  color: var(--color-ink);
  font-size: 1.3rem;
  line-height: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero__arrow--prev {
  left: 1rem;
}

.hero__arrow--next {
  right: 1rem;
}

.hero__pause {
  position: absolute;
  bottom: 1rem;
  right: 1rem;
  z-index: 3;
  width: 1.9rem;
  height: 1.9rem;
  border-radius: 50%;
  border: none;
  background: rgba(255, 255, 255, 0.85);
  color: var(--color-ink);
  font-size: 0.75rem;
  line-height: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero__dots {
  position: absolute;
  bottom: 1rem;
  left: 50%;
  transform: translateX(-50%);
  z-index: 3;
  display: flex;
  gap: 0.4rem;
}

.hero__dot {
  width: 0.5rem;
  height: 0.5rem;
  border-radius: 50%;
  border: none;
  background: rgba(255, 255, 255, 0.5);
  padding: 0;
}

.hero__dot--active {
  background: var(--color-white);
  width: 1.3rem;
  border-radius: var(--radius-full);
  transition: width 0.2s ease;
}

/* Packages */
.packages {
  margin-top: 3rem;
  display: flex;
  flex-direction: column;
  gap: 1.75rem;
}

.packages__header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 1rem;
  flex-wrap: wrap;
}

.packages__eyebrow {
  color: var(--color-gold);
  font-size: 0.8rem;
  font-weight: 600;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  margin-bottom: 0.35rem;
}

.packages__title {
  font-size: 1.7rem;
}

.packages__view-all {
  font-size: 0.9rem;
  font-weight: 600;
  color: var(--color-brown);
  white-space: nowrap;
}

.packages__view-all:hover {
  color: var(--color-gold);
}

.packages__grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.25rem;
}

.packages__state {
  text-align: center;
  padding: 3rem 0;
  color: var(--color-muted);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.packages__retry {
  background: transparent;
  border: 1px solid var(--color-line);
  border-radius: var(--radius-full);
  padding: 0.6rem 1.5rem;
  font-size: 0.85rem;
  font-weight: 500;
  color: var(--color-brown);
}

.packages__retry:hover {
  border-color: var(--color-gold);
  color: var(--color-gold);
}

/* Tour banner */
.tour-banner {
  margin-top: 3rem;
  position: relative;
  border-radius: var(--radius-md);
  overflow: hidden;
  min-height: 220px;
  display: flex;
  align-items: center;
}

.tour-banner__image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.tour-banner__overlay {
  position: relative;
  z-index: 2;
  background: linear-gradient(
    100deg,
    rgba(43, 29, 18, 0.88) 0%,
    rgba(43, 29, 18, 0.55) 55%,
    rgba(43, 29, 18, 0) 85%
  );
  color: var(--color-cream);
  padding: 2.25rem;
  max-width: 65%;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.tour-banner__eyebrow {
  color: var(--color-gold);
  font-size: 0.8rem;
  font-weight: 600;
}

.tour-banner__title {
  font-size: 1.6rem;
  color: var(--color-white);
}

.tour-banner__subtitle {
  font-size: 0.9rem;
  opacity: 0.9;
  max-width: 42ch;
}

.tour-banner__cta {
  align-self: flex-start;
  background: var(--color-gold);
  color: var(--color-brown-deep);
  font-weight: 600;
  border-radius: var(--radius-full);
  padding: 0.65rem 1.4rem;
  margin-top: 0.5rem;
  font-size: 0.9rem;
}

@media (max-width: 900px) {
  .packages__grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .hero__panel,
  .tour-banner__overlay {
    max-width: 85%;
  }
}

@media (max-width: 560px) {
  .packages__grid {
    grid-template-columns: 1fr;
  }
  .hero,
  .hero__slide,
  .hero__image {
    min-height: 420px;
  }
  .hero__panel {
    max-width: 100%;
    background: linear-gradient(180deg, rgba(20, 38, 29, 0.92) 40%, rgba(20, 38, 29, 0.6) 100%);
  }
}

@media (prefers-reduced-motion: reduce) {
  .hero__slide {
    transition: none;
  }
}
</style>
