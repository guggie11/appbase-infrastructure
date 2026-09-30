# Appbase

[![CI Backend](https://github.com/guggie11/appbase-backend/actions/workflows/ci.yml/badge.svg)](https://github.com/guggie11/appbase-backend/actions/workflows/ci.yml)
[![CI Frontend](https://github.com/guggie11/appbase-frontend/actions/workflows/ci.yml/badge.svg)](https://github.com/guggie11/appbase-frontend/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-v1.0.0-blue.svg)](https://github.com/guggie11/appbase-infrastructure/releases/tag/v1.0.0)

**The production-ready boilerplate for internal admin applications.**

Appbase is a full-stack GitHub Template that provides everything you need to build secure, role-based internal tools — authentication, RBAC, dynamic menus, audit logs, and more — out of the box. Clone it once, ship it forever.

---

## Preview

| Dashboard | User Management | Audit Logs |
|-----------|----------------|------------|
| [Screenshot Dashboard] | [Screenshot Users] | [Screenshot Audit Logs] |

> **Demo:** [appbase-demo.example.com](https://appbase-demo.example.com) *(coming soon)*

---

## Features

- 🔐 **Authentication** — JWT access + refresh tokens, email verification, password reset
- 👥 **User Management** — Invite flow, soft delete, profile management
- 🛡️ **RBAC** — Role-based access control with fine-grained permissions per endpoint
- 📋 **Dynamic Menus** — Menus configured from DB, visibility driven by user roles
- 📊 **Dashboard** — Summary stats, activity feed, ready-to-extend widgets
- 📜 **Audit Logs** — Immutable log of every state-changing action with actor, IP, timestamp
- 🔔 **Notifications** — In-app notification system with read/unread state
- ⚙️ **Settings** — Per-tenant configuration panel
- 🚦 **Rate Limiting** — SlowAPI integration on auth endpoints
- 📧 **Email Integration** — SMTP with Mailpit for local development
- 🐳 **Docker-first** — One command to run the full stack in production mode
- 🧪 **Test Suite** — pytest (backend) + Vitest + Playwright (frontend) with CI pre-configured

---

## Tech Stack

### Frontend
| Technology | Version | Purpose |
|------------|---------|---------|
| React | 19 | UI framework |
| TypeScript | 6 | Type safety |
| Vite | 8 | Build tool |
| TailwindCSS | 4 | Styling |
| TanStack Query | 5 | Server state / caching |
| TanStack Table | 8 | Data tables |
| Zustand | 5 | Client state |
| React Router | 7 | Routing |
| React Hook Form | 7 | Form management |
| Orval | 7 | OpenAPI → typed hooks codegen |
| Vitest | 3 | Unit testing |
| Playwright | 1.46 | E2E testing |

### Backend
| Technology | Version | Purpose |
|------------|---------|---------|
| Python | 3.11+ | Language |
| FastAPI | 0.115+ | API framework |
| SQLAlchemy | 2 (async) | ORM |
| Alembic | 1.13+ | Database migrations |
| PostgreSQL | 16 | Primary database |
| Redis | 7 | Token blacklist / cache |
| Pydantic v2 | — | Validation & settings |
| python-jose | — | JWT signing |
| pwdlib (argon2) | — | Password hashing |
| SlowAPI | — | Rate limiting |
| uv | — | Package manager |

### Infrastructure
| Technology | Purpose |
|------------|---------|
| Docker + Compose | Container orchestration |
| Nginx | Reverse proxy (production) |
| Mailpit | Local email testing |
| GitHub Actions | CI/CD |

---

## Quick Start

**Prerequisites:** Docker, Docker Compose, Git

```bash
# 1. Clone all three repos into a shared workspace
mkdir my-project && cd my-project
git clone https://github.com/guggie11/appbase-infrastructure infrastructure
git clone https://github.com/guggie11/appbase-backend backend
git clone https://github.com/guggie11/appbase-frontend frontend

# 2. Set up backend environment
cp backend/.env.example backend/.env
# Edit backend/.env with your values (DB, Redis, SMTP, SECRET_KEY)

# 3. Start the full stack
cd infrastructure
make up

# 4. Run database migrations
docker exec appbase-app alembic upgrade head

# 5. Create the first super admin
docker exec -it appbase-app python scripts/create_superadmin.py
```

The API is now running at **http://localhost:8000** and the frontend at **http://localhost:5173** (dev) or **http://localhost:80** (production Docker).

---

## Project Structure

Appbase is organized as three separate repositories that work together:

```
my-project/
├── infrastructure/          # ← appbase-infrastructure (this repo)
│   ├── docker-compose.yml       # Dev stack (all services)
│   ├── docker-compose.prod.yml  # Production stack
│   ├── Dockerfile.backend
│   ├── Dockerfile.frontend
│   ├── nginx.conf
│   └── Makefile
│
├── backend/                 # ← appbase-backend
│   ├── src/app/
│   │   ├── api/v1/          # Route handlers (auth, users, roles, menus…)
│   │   ├── core/            # Config, security, database session
│   │   ├── models/          # SQLAlchemy ORM models
│   │   ├── schemas/         # Pydantic request/response schemas
│   │   ├── middleware/      # Audit log, CORS
│   │   └── utils/           # Email, token helpers
│   ├── alembic/             # Migration scripts
│   └── tests/
│
└── frontend/                # ← appbase-frontend
    └── src/
        ├── app/             # App shell (router, providers)
        ├── pages/           # Route-level components
        ├── features/        # Feature slices (FSD)
        ├── entities/        # Domain entities
        ├── widgets/         # Composite UI blocks
        └── shared/          # Shared utilities, UI primitives
```

---

## Using as a GitHub Template

### 1. Create your project from this template

Click **"Use this template"** → **"Create a new repository"** on each of the three repos:
- `guggie11/appbase-infrastructure` → `your-org/your-project-infrastructure`
- `guggie11/appbase-backend` → `your-org/your-project-backend`
- `guggie11/appbase-frontend` → `your-org/your-project-frontend`

### 2. Initial setup after cloning

```bash
# Rename Docker container/network names in docker-compose files
sed -i 's/appbase/your-project/g' docker-compose.yml docker-compose.prod.yml

# Set up secrets in your CI (GitHub → Settings → Secrets)
# Required: DATABASE_URL, SECRET_KEY, REDIS_URL, SMTP_HOST
```

### 3. Configure environment

```bash
cp backend/.env.example backend/.env
# Set: DATABASE_URL, SECRET_KEY, REDIS_URL, SMTP_HOST, FRONTEND_URL, CORS_ORIGINS
```

### 4. Run migrations and seed data

```bash
cd infrastructure && make up
docker exec appbase-app alembic upgrade head
docker exec -it appbase-app python scripts/create_superadmin.py
```

### 5. Versioning convention

Appbase uses semantic versioning. When you fork:

| Appbase release | Your project tag |
|-----------------|-----------------|
| `v1.0.0` | `v1.0.0-base` |
| `v1.1.0` | `v1.1.0-base` (after cherry-pick) |

Tag your fork immediately after creation so you know which base version you started from.

### 6. Backporting upstream fixes (cherry-pick strategy)

```bash
# Add the upstream remote (one-time)
git remote add upstream https://github.com/guggie11/appbase-backend.git
git fetch upstream

# Cherry-pick a specific fix from upstream
git cherry-pick <commit-sha>

# Or merge a range of upstream commits
git cherry-pick v1.0.0..v1.0.1
```

Recommended: track upstream releases in your project's CHANGELOG so you always know your drift from the base.

---

## Development Guide

### Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Docker | 24+ | [docs.docker.com](https://docs.docker.com/get-docker/) |
| Docker Compose | v2 | Included with Docker Desktop |
| Python | 3.11+ | [python.org](https://python.org) |
| uv | latest | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Node.js | 20+ | [nodejs.org](https://nodejs.org) |
| pnpm | 9+ | `npm i -g pnpm` |

### Local Development Mode

Run infrastructure services only (DB, Redis, Mailpit), then run backend and frontend natively for hot reload:

```bash
# Terminal 1 — infra only
cd infrastructure
make infra   # starts db + redis + mailpit only

# Terminal 2 — backend
cd backend
uv sync
uv run alembic upgrade head
uv run fastapi dev src/app/main.py

# Terminal 3 — frontend
cd frontend
pnpm install
pnpm dev
```

### Production Docker Mode

```bash
cd infrastructure
make up   # builds and starts all services including app + nginx
```

Access:
- API: http://localhost:8000
- Frontend: http://localhost:80
- Mailpit: http://localhost:8025
- API Docs: http://localhost:8000/docs

### Running Tests

**Backend:**
```bash
cd backend
uv run pytest tests/ -v
```

**Frontend (unit):**
```bash
cd frontend
pnpm test
```

**Frontend (E2E):**
```bash
cd frontend
pnpm test:e2e
```

### Alembic Migration Workflow

```bash
# Generate a new migration after changing models
uv run alembic revision --autogenerate -m "add_feature_x"

# Apply pending migrations
uv run alembic upgrade head

# Roll back one step
uv run alembic downgrade -1

# View migration history
uv run alembic history --verbose
```

---

## Configuration Reference

All environment variables are read from `backend/.env`. Copy `.env.example` as your starting point.

| Variable | Default | Description |
|----------|---------|-------------|
| `APP_NAME` | `Appbase` | Application display name |
| `DEBUG` | `False` | Enable debug mode (never `True` in production) |
| `DATABASE_URL` | `postgresql+psycopg://appbase:appbase@localhost:5432/appbase` | PostgreSQL connection string |
| `REDIS_URL` | `redis://localhost:6379/0` | Redis connection string |
| `SECRET_KEY` | *(required)* | JWT signing key — generate with `openssl rand -hex 32` |
| `ALGORITHM` | `HS256` | JWT algorithm |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | `15` | Access token lifetime |
| `REFRESH_TOKEN_EXPIRE_DAYS` | `7` | Refresh token lifetime |
| `CORS_ORIGINS` | `http://localhost:5173` | Comma-separated allowed origins |
| `SMTP_HOST` | `localhost` | SMTP server host |
| `SMTP_PORT` | `1025` | SMTP server port (1025 = Mailpit dev) |
| `FRONTEND_URL` | `http://localhost:5173` | Used in email links |

---

## Architecture

```
                          ┌─────────────────────────────────┐
                          │           Browser                │
                          └────────────────┬────────────────┘
                                           │ HTTPS
                          ┌────────────────▼────────────────┐
                          │           Nginx (prod)           │
                          │  /        → frontend (React)     │
                          │  /api/*   → backend (FastAPI)    │
                          └────────┬──────────────┬──────────┘
                                   │              │
               ┌───────────────────▼──┐    ┌──────▼───────────────────┐
               │   FastAPI Backend    │    │   React Frontend (Vite)   │
               │                      │    │                            │
               │  /api/v1/auth        │    │  TanStack Query            │
               │  /api/v1/users       │    │  Zustand store             │
               │  /api/v1/roles       │    │  Orval-generated hooks     │
               │  /api/v1/menus       │    │  React Router v7           │
               │  /api/v1/audit-logs  │    └────────────────────────────┘
               │  /api/v1/notifs      │
               └───────┬──────┬───────┘
                        │      │
          ┌─────────────▼──┐  ┌▼──────────────┐
          │  PostgreSQL 16  │  │   Redis 7      │
          │  (primary data) │  │  (token BL /  │
          └─────────────────┘  │   cache)      │
                               └───────────────┘
```

---

## Roadmap

### v1.0.0 — Current ✅
- [x] JWT authentication (access + refresh tokens)
- [x] Email verification & password reset
- [x] User management (CRUD, invite, soft delete)
- [x] Role-based access control (RBAC)
- [x] Dynamic menus driven by DB + role visibility
- [x] Audit log (middleware, query, export)
- [x] In-app notifications
- [x] Dashboard with summary stats
- [x] Settings panel
- [x] Docker Compose (dev + prod)
- [x] CI pipelines (backend + frontend)
- [x] GitHub Template setup

### v1.1.0 — In Progress 🚧
- [ ] Multi-tenancy support
- [ ] OAuth2 / SSO (Google, Microsoft)
- [ ] File upload (S3-compatible)
- [ ] Advanced dashboard widgets
- [ ] OpenAPI client auto-update CI step

### v1.2.0 — Planned 📋
- [ ] Webhook system
- [ ] Two-factor authentication (TOTP)
- [ ] Dark mode
- [ ] Internationalization (i18n)
- [ ] Prometheus metrics endpoint
- [ ] Helm chart for Kubernetes deployment

---

## Contributing

Contributions, issues, and feature requests are welcome. Please read the contribution guidelines before submitting a PR.

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/your-feature`
3. Commit using conventional commits: `git commit -m "feat: add oauth2 support"`
4. Push and open a Pull Request against `main`
5. Ensure all CI checks pass before requesting review

**Branch naming:** `feat/`, `fix/`, `docs/`, `chore/`  
**Commit style:** [Conventional Commits](https://www.conventionalcommits.org/)

---

## License

MIT © 2024 [guggie11](https://github.com/guggie11)

See [LICENSE](LICENSE) for full text.
