import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import TermsView from '../views/TermsView.vue'
import PrivacyView from '../views/PrivacyView.vue'
import Packages from '../views/Packages.vue'
import PackageDetail from '../views/PackageDetail.vue'
import Cart from '../views/Cart.vue'
import Checkout from '../views/Checkout.vue'
import Payment from '../views/Payment.vue'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import ForgotPassword from '../views/ForgotPassword.vue'
import Dashboard from '../views/Dashboard.vue'
import BookingHistory from '../views/BookingHistory.vue'
import Confirmation from '../views/Confirmation.vue'
import AboutView from '../views/AboutView.vue'
import NotFound from '../views/NotFound.vue'

// Import the new pages
import LargeEvents from '../views/LargeEvents.vue'
import SmallEvents from '../views/SmallEvents.vue'
import Tours from '../views/Tours.vue'

import { useAuthStore } from '@/stores/auth'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  // Always land at the top of a new page, but restore scroll position on
  // back/forward navigation (e.g. returning to a scrolled-down Packages
  // list). Without this, going from a scrolled Packages page to a Package
  // Detail page (or any other route) keeps the old scroll offset, landing
  // the visitor mid-page on unrelated content.
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) return savedPosition
    if (to.hash) return { el: to.hash, behavior: 'smooth' }
    return { top: 0 }
  },
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
      meta: { title: 'Occasion | Catering for every occasion' },
    },
    {
      path: '/packages',
      name: 'packages',
      component: Packages,
      meta: { title: 'Packages | Occasion' },
    },
    {
      path: '/large-events',
      name: 'large-events',
      component: LargeEvents,
      meta: { title: 'Large Events | Occasion' },
    },
    {
      path: '/small-events',
      name: 'small-events',
      component: SmallEvents,
      meta: { title: 'Small Events | Occasion' },
    },
    {
      path: '/tours',
      name: 'tours',
      component: Tours,
      meta: { title: 'Tours | Occasion' },
    },
    {
      path: '/about',
      name: 'about',
      component: AboutView,
      meta: { title: 'About Us | Occasion' },
    },
    {
      path: '/login',
      name: 'login',
      component: Login,
      meta: { title: 'Login | Occasion' },
    },
    {
      path: '/register',
      name: 'register',
      component: Register,
      meta: { title: 'Sign Up | Occasion' },
    },
    {
      path: '/forgot-password',
      name: 'forgot-password',
      component: ForgotPassword,
      meta: { title: 'Reset Password | Occasion' },
    },
    {
      path: '/terms',
      name: 'terms',
      component: TermsView,
      meta: { title: 'Terms & Conditions | Occasion' },
    },
    {
      path: '/privacy',
      name: 'privacy',
      component: PrivacyView,
      meta: { title: 'Privacy Policy | Occasion' },
    },
    {
      path: '/cart',
      name: 'cart',
      component: Cart,
      meta: { title: 'Your Cart | Occasion' },
    },
    {
      path: '/packages/:id',
      name: 'package-detail',
      component: PackageDetail,
      meta: { title: 'Package Details | Occasion' },
    },
    {
      path: '/checkout',
      name: 'checkout',
      component: Checkout,
      meta: { title: 'Checkout | Occasion' },
    },
    {
      path: '/payment/:bookingId',
      name: 'payment',
      component: Payment,
      meta: { title: 'Payment | Occasion' },
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: Dashboard,
      meta: { requiresAuth: true, title: 'Dashboard | Occasion' },
    },
    {
      path: '/bookings',
      name: 'booking-history',
      component: BookingHistory,
      meta: { requiresAuth: true, title: 'Booking History | Occasion' },
    },
    {
      path: '/confirmation/:bookingId?',
      name: 'confirmation',
      component: Confirmation,
      meta: { title: 'Booking Confirmation | Occasion' },
    },
    // Catch-all — keeps an unrecognised URL from rendering a blank page
    // between the navbar and footer. Must stay last.
    {
      path: '/:pathMatch(.*)*',
      name: 'not-found',
      component: NotFound,
      meta: { title: 'Page Not Found | Occasion' },
    },
  ],
})

// Account pages (Dashboard, Booking History) assume a logged-in user — send
// anyone who isn't back to Login, remembering where they were headed so we
// can return them there once auth.login() (stubbed for now) succeeds.
router.beforeEach((to) => {
  const auth = useAuthStore()
  if (to.meta.requiresAuth && !auth.isLoggedIn) {
    return { path: '/login', query: { redirect: to.fullPath } }
  }
  return true
})

// The <title> in index.html is static, so without this every route shows
// the same browser tab title/history entry ("Occasion | Catering for every
// occasion") whether you're on Home, Cart, or Checkout — makes tabs and
// browser history indistinguishable when someone has a few pages open.
router.afterEach((to) => {
  document.title = to.meta.title || 'Occasion | Catering for every occasion'
})

export default router