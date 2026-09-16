A South African e-commerce catering-booking platform serving three customer types through one system:

- **Large events** - weddings, corporate functions, celebrations
- **Small events** - private dinners, date nights, family gatherings
- **Tour-operator food packages**

Customers browse packages, configure event details (date, guest count, menu customisation), register/log in, review and pay via PayFast (sandbox mode), then track booking history from a dashboard.

## Tech Stack

| Layer | Stack |
|---|---|
| Frontend | Vue 3 (Composition API) + Vite, Vue Router, Pinia, Axios |
| Backend | Node.js + Express.js |
| Database | MySQL via Sequelize |
| Auth | JWT + bcrypt |
| Payments | PayFast (sandbox) with ITN webhook |

## Quick Start

```bash
# Clone
git clone <repo-url>
cd occasion

# Frontend
cd occasion-frontend
npm install
npm run dev          # Vite dev server

# Backend (second terminal)
cd backend
npm install
cp .env.example .env # fill in DB + PayFast sandbox + JWT secrets
npm run seed         # populate mock data
npm run dev          # Express server

## Project Structure

```
occasion/
├── occasion-frontend/   # Vue 3 SPA
├── backend/    # Express REST API
└── docs/                # Planning and design docs
```

## Documentation

- **[Development Plan](docs/Occasion_Development_Plan.dox)** — architecture, database design, API endpoints, timeline, MVP scope, risks
- **[Contributing](CONTRIBUTING.md)** — branching strategy, PR checklist, commit conventions

## Team

| Member | Primary focus |
|---|---|
| Azhar | TL, Vue frontend, frontend-backend integration |
| Rushin | Design system, Vue components |
| Qaasim | MySQL schema, API endpoints |
| Karah | Auth, booking logic, backend flows |
