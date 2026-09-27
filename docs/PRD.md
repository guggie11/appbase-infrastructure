# PRD V1.1 — Appbase (Boilerplate)

| Metadata | Nilai |
|---|---|
| **Status** | Draft |
| **Versi** | 1.1.0 |
| **Tanggal** | September 2026 |
| **Author** | - |
| **Owner** | - |
| **Reviewer** | - |
| **Approved** | - |

| Versi | Tanggal | Perubahan |
|---|---|---|
| 1.0.0 | Sep 2026 | Initial draft |
| 1.1.0 | Sep 2026 | Adopsi NFR, framing produk, 3 repo, FSD, Orval, Argon2, CSRF, pnpm, uv, error contract, testing stack |

---

## Table of Contents

1. [Latar Belakang](#1-latar-belakang)
2. [Tujuan Produk](#2-tujuan-produk)
3. [Non-tujuan V1.0](#3-non-tujuan-v10)
4. [Asumsi Produk](#4-asumsi-produk)
5. [Persona & Peran](#5-persona--peran)
6. [Prinsip Produk](#6-prinsip-produk)
7. [Overview Stack](#7-overview-stack)
8. [Repository Structure](#8-repository-structure)
9. [Architecture](#9-architecture)
10. [Database Schema](#10-database-schema)
11. [Modules V1.0](#11-modules-v10)
12. [Security Features](#12-security-features)
13. [Error Contract](#13-error-contract)
14. [Non-Functional Requirements](#14-non-functional-requirements)
15. [GitHub Actions CI/CD](#15-github-actions-cicd)
16. [GitHub Labels](#16-github-labels)
17. [Phases & Milestones](#17-phases--milestones)
18. [Epics](#18-epics)
19. [Product Backlog](#19-product-backlog)
20. [Sprint 1 — Ready to Start](#20-sprint-1--ready-to-start)
21. [Way of Working — AI Agent + GitHub SSOT](#21-way-of-working--ai-agent--github-ssot)
22. [Definition of Done V1.0](#22-definition-of-done-v10)

---

## 1. Latar Belakang

Setiap project baru mengulang pekerjaan yang sama: menyiapkan autentikasi, otorisasi, layout dashboard, manajemen pengguna, validasi, kontrak API, database migration, testing, observability, dan deployment lokal. Pengulangan ini memperlambat delivery dan menghasilkan implementasi keamanan serta struktur kode yang tidak konsisten antar project.

**Appbase** menyelesaikan masalah ini dengan menyediakan fondasi yang:

- Aman secara default
- Konsisten antara frontend dan backend
- Type-safe dari OpenAPI hingga pemanggilan API di frontend (via Orval)
- Mudah dikustomisasi tanpa perlu membongkar fondasi
- Memiliki contoh pola implementasi yang dapat diikuti modul bisnis baru
- Dapat dijalankan secara lokal dengan sedikit konfigurasi

---

## 2. Tujuan Produk

1. Mengurangi waktu bootstrap project internal atau aplikasi administrasi baru
2. Menyediakan pola baku untuk authentication, authorization, CRUD, file upload, audit, testing, dan error handling
3. Memastikan keamanan diterapkan di backend, bukan hanya melalui visibilitas UI
4. Membuat kontrak frontend-backend tetap sinkron melalui OpenAPI code generation
5. Menyediakan developer experience yang sederhana, terdokumentasi, dan reproducible

---

## 3. Non-tujuan V1.0

- Multi-tenancy / SaaS
- Payment gateway, billing, subscription, invoice
- Identity provider untuk aplikasi lain
- Visual page builder atau workflow builder
- Mobile app native / PWA
- Analytics bisnis domain-spesifik
- Real-time collaboration / WebSocket
- Two-Factor Authentication → masuk V1.1
- OAuth / SSO (Google, Microsoft Entra ID) → masuk V1.1
- Internationalization (i18n) → masuk V1.1
- MFA, passkeys → masuk V1.2

---

## 4. Asumsi Produk

- MVP adalah aplikasi single-tenant
- Source code dibagi menjadi **tiga repository**: `appbase-frontend`, `appbase-backend`, `appbase-infrastructure`
- Setiap repository dapat dibangun dan diuji secara mandiri
- Integrasi lokal dan release lintas repository dikoordinasikan oleh `appbase-infrastructure`
- Frontend dan API dikembangkan terpisah; di production berada di bawah site yang sama (misalnya `/` dan `/api`)
- Authentication menggunakan JWT dengan httpOnly cookie (bukan localStorage)
- PostgreSQL adalah source of truth utama
- Redis digunakan untuk cache, rate limiting, dan token store
- `appbase-infrastructure/docs/PRD.md` adalah SSOT requirement produk lintas repository

---

## 5. Persona & Peran

### Super Admin
Pengelola tertinggi aplikasi yang dapat mengakses seluruh modul, mengatur administrator, role, permission, menu, dan konfigurasi sistem. Role sistem ini tidak dapat dihapus atau diturunkan hak aksesnya.

### Admin
Pengguna administratif yang mengelola user dan data operasional sesuai permission yang diberikan oleh Super Admin.

### User
Pengguna terautentikasi yang mengakses dashboard, profil, dan fitur yang diizinkan sesuai rolenya.

### Developer / Integrator
Pengembang yang memakai boilerplate sebagai fondasi project baru, menambahkan modul bisnis, menjalankan migration, dan mengintegrasikan API.

---

## 6. Prinsip Produk

- **Secure by default** — konfigurasi awal harus aman untuk penggunaan umum
- **Backend-enforced authorization** — UI hanya mencerminkan akses; backend selalu memverifikasi permission
- **Modular** — fitur opsional tidak boleh mengotori core application
- **Convention over invention** — pola CRUD, error, loading, form, dan testing dibuat konsisten
- **Vertical delivery** — sebuah Story menghasilkan kemampuan yang dapat diuji dari UI hingga database
- **Accessible & responsive** — alur utama dapat digunakan dengan keyboard dan pada layar mobile maupun desktop
- **Observable** — kegagalan penting dapat ditelusuri tanpa mencatat password, token, atau data sensitif
- **Type-safe end-to-end** — dari OpenAPI schema hingga pemanggilan API di frontend

---

## 7. Overview Stack

| Layer | Stack |
|---|---|
| **Frontend** | React 19, TypeScript, Vite, Tailwind CSS v4, shadcn/ui |
| **Frontend State** | TanStack Query (server state), Zustand (client/UI state) |
| **Frontend Routing** | React Router DOM v7 |
| **Frontend Forms** | React Hook Form + Zod |
| **Frontend Tables** | TanStack Table |
| **Frontend API Client** | Orval (generated dari OpenAPI), Axios |
| **Frontend Animation** | Framer Motion |
| **Frontend Charts** | Recharts |
| **Frontend Icons** | Lucide React, React Icons |
| **Frontend Notifications** | Sonner (toast) |
| **Frontend Testing** | Vitest, Testing Library, MSW, Playwright |
| **Frontend Package Manager** | pnpm |
| **Backend** | FastAPI, Python, Pydantic, pydantic-settings |
| **Backend ORM** | SQLAlchemy 2.x, Psycopg 3 |
| **Backend Migration** | Alembic |
| **Backend Auth** | JWT (access + refresh), Argon2 via `pwdlib` |
| **Backend Rate Limit** | SlowAPI + Redis |
| **Backend HTTP Client** | HTTPX |
| **Backend Testing** | pytest |
| **Backend Package Manager** | uv |
| **Backend Linting** | Ruff, Pyright |
| **Database** | PostgreSQL |
| **Cache / Store** | Redis |
| **File Storage** | MinIO (opsional, V1.0) |
| **Email Dev** | Mailpit |
| **Infrastructure** | Docker Compose, GitHub Actions |
| **API Contract** | OpenAPI (FastAPI auto-generate) + Orval codegen |

---

## 8. Repository Structure

### Tiga repo terpisah di GitHub

```
github.com/guggie11/appbase-frontend
github.com/guggie11/appbase-backend
github.com/guggie11/appbase-infrastructure   ← NEW
```

Workspace lokal:
```
appbase-workspace/
├── appbase-frontend/
├── appbase-backend/
└── appbase-infrastructure/
```

---

### Frontend (`appbase-frontend`)

Menggunakan Feature-Sliced Design (FSD):

```
appbase-frontend/
├── .github/
│   └── workflows/
│       ├── ci.yml              ← lint, type-check, test, build
│       └── deploy.yml
├── docs/
│   └── CHANGELOG.md
├── public/
├── src/
│   ├── app/                    ← providers, router, global styles
│   ├── pages/                  ← satu komponen per route
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── users/
│   │   ├── roles/
│   │   ├── menus/
│   │   ├── profile/
│   │   ├── audit-log/
│   │   └── settings/
│   ├── widgets/                ← blok UI kompleks
│   │   ├── sidebar/
│   │   ├── header/
│   │   └── layout/
│   ├── features/               ← fitur yang bisa dipakai ulang
│   │   ├── auth/
│   │   ├── user-management/
│   │   └── role-management/
│   ├── entities/               ← business entities & model
│   │   ├── user/
│   │   ├── role/
│   │   └── menu/
│   └── shared/
│       ├── api/
│       │   └── generated/      ← AUTO-GENERATED dari Orval (jangan edit manual)
│       ├── ui/                 ← base components (shadcn/ui)
│       ├── lib/
│       │   ├── apiClient.ts
│       │   └── utils.ts
│       ├── hooks/
│       │   ├── useAuth.ts
│       │   └── usePermission.ts
│       ├── store/              ← Zustand stores
│       │   ├── authStore.ts
│       │   └── uiStore.ts
│       └── types/
├── tests/
│   ├── unit/                   ← Vitest
│   └── e2e/                    ← Playwright
├── .env.example
├── BACKLOG.md
├── orval.config.ts             ← konfigurasi code generation
├── package.json
├── pnpm-lock.yaml
├── tailwind.config.ts
├── tsconfig.json
├── vite.config.ts
└── Dockerfile
```

---

### Backend (`appbase-backend`)

```
appbase-backend/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── deploy.yml
├── docs/
│   └── CHANGELOG.md
├── src/
│   └── app/
│       ├── main.py
│       ├── api/
│       │   └── v1/
│       │       ├── auth/
│       │       ├── users/
│       │       ├── roles/
│       │       ├── permissions/
│       │       ├── menus/
│       │       ├── dashboard/
│       │       ├── profile/
│       │       ├── audit_logs/
│       │       └── settings/
│       ├── core/
│       │   ├── config.py
│       │   ├── security.py
│       │   ├── database.py
│       │   └── redis.py
│       ├── middleware/
│       │   ├── auth_guard.py
│       │   ├── permission_guard.py
│       │   ├── audit_logger.py
│       │   └── correlation_id.py    ← NEW: request tracing
│       ├── models/
│       ├── schemas/
│       └── common/
├── migrations/
│   ├── versions/
│   └── env.py
├── contracts/
│   └── openapi.json             ← AUTO-EXPORT, dikonsumsi frontend via Orval
├── scripts/
│   └── export_openapi.py
├── tests/
│   ├── unit/
│   └── integration/
├── .env.example
├── BACKLOG.md
├── alembic.ini
├── pyproject.toml               ← konfigurasi uv + ruff + pyright
├── uv.lock
└── Dockerfile
```

---

### Infrastructure (`appbase-infrastructure`)

```
appbase-infrastructure/
├── .github/
│   └── workflows/
│       ├── ci.yml               ← integration test & E2E lintas repo
│       └── deploy.yml
├── compose/
│   ├── compose.yaml             ← full stack local dev
│   └── compose.override.example.yaml
├── environments/
│   ├── local/
│   ├── staging/
│   └── production/
├── ingress/                     ← reverse proxy config
├── observability/               ← logging, tracing config
├── tests/
│   ├── e2e/                     ← Playwright E2E lintas repo
│   └── smoke/
├── docs/
│   ├── PRD.md                   ← SSOT utama (dokumen ini)
│   ├── ARCHITECTURE.md
│   ├── DATABASE.md
│   ├── RUNBOOK.md
│   ├── CHANGELOG.md
│   └── adr/                     ← Architecture Decision Records
├── scripts/
└── BACKLOG.md
```

---

## 9. Architecture

```
┌──────────────────────────────────────────────────┐
│                   CLIENT                         │
│   React 19 + TypeScript + Tailwind v4            │
│   shadcn/ui | FSD | TanStack Query & Table       │
│   Orval Generated Client | Zustand               │
│   Framer Motion | Recharts | Sonner              │
└────────────────────┬─────────────────────────────┘
                     │ HTTPS / REST API
                     │ httpOnly Cookie (JWT)
                     │ CORS Whitelist + CSRF
┌────────────────────▼─────────────────────────────┐
│                  BACKEND                         │
│   FastAPI + Pydantic + SQLAlchemy 2.x            │
│   JWT (Access 15m + Refresh 7d)                  │
│   RBAC | Argon2 | SlowAPI | Correlation ID       │
│   OpenAPI auto-generate → contracts/openapi.json │
└────────────────────┬─────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
┌───────────────┐        ┌────────────────┐
│  PostgreSQL   │        │     Redis      │
│  primary DB   │        │  cache/session │
│  Alembic      │        │  rate limit    │
│  migrations   │        │  token store   │
└───────────────┘        └────────────────┘
                                  │
                    ┌─────────────┘
                    ▼
          ┌─────────────────┐
          │     Mailpit     │
          │  (email dev)    │
          └─────────────────┘
```

**OpenAPI Contract Flow:**
```
Backend FastAPI
  → auto-generate openapi.json
  → contracts/openapi.json
  → Orval codegen
  → frontend src/shared/api/generated/
  → type-safe API calls di frontend
```

**Pattern:** Tiga repo terpisah. Stateless backend — session di Redis, data di PostgreSQL. Type-safe end-to-end via OpenAPI + Orval.

---

## 10. Database Schema

```sql
-- ============================================================
-- CORE AUTH & USER
-- ============================================================
users (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name                VARCHAR(100) NOT NULL,
  email               VARCHAR(150) UNIQUE NOT NULL,
  password_hash       VARCHAR(255),              -- nullable (future OIDC)
  avatar              VARCHAR(255),
  status              VARCHAR(20) DEFAULT 'pending',  -- pending|active|inactive|suspended
  is_verified         BOOLEAN DEFAULT false,
  last_login_at       TIMESTAMP,
  failed_login_count  INT DEFAULT 0,
  locked_until        TIMESTAMP,
  deleted_at          TIMESTAMP,                 -- soft delete
  created_at          TIMESTAMP DEFAULT NOW(),
  updated_at          TIMESTAMP DEFAULT NOW()
)

email_verifications (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
  token_hash  VARCHAR(255) NOT NULL,
  expires_at  TIMESTAMP NOT NULL,
  used_at     TIMESTAMP,
  created_at  TIMESTAMP DEFAULT NOW()
)

-- ============================================================
-- RBAC
-- ============================================================
roles (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        VARCHAR(100) NOT NULL,
  slug        VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  is_system   BOOLEAN DEFAULT false,    -- role sistem tidak bisa dihapus
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMP DEFAULT NOW(),
  updated_at  TIMESTAMP DEFAULT NOW()
)

permissions (
  id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name    VARCHAR(100) NOT NULL,
  slug    VARCHAR(100) UNIQUE NOT NULL,  -- format: resource.action (users.read)
  module  VARCHAR(100) NOT NULL,
  action  VARCHAR(50) NOT NULL,          -- read|create|update|delete
  created_at TIMESTAMP DEFAULT NOW()
)

role_permissions (
  role_id         UUID REFERENCES roles(id) ON DELETE CASCADE,
  permission_id   UUID REFERENCES permissions(id) ON DELETE CASCADE,
  PRIMARY KEY (role_id, permission_id)
)

user_roles (
  user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
  role_id     UUID REFERENCES roles(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, role_id)
)

-- ============================================================
-- MENU
-- ============================================================
menus (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  label       VARCHAR(100) NOT NULL,
  icon        VARCHAR(100),
  path        VARCHAR(255),
  parent_id   UUID REFERENCES menus(id),
  order_index INT DEFAULT 0,
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMP DEFAULT NOW(),
  updated_at  TIMESTAMP DEFAULT NOW()
)

menu_roles (
  menu_id     UUID REFERENCES menus(id) ON DELETE CASCADE,
  role_id     UUID REFERENCES roles(id) ON DELETE CASCADE,
  PRIMARY KEY (menu_id, role_id)
)

-- ============================================================
-- SECURITY
-- ============================================================
password_resets (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
  token_hash  VARCHAR(255) NOT NULL,
  expires_at  TIMESTAMP NOT NULL,
  used_at     TIMESTAMP,
  created_at  TIMESTAMP DEFAULT NOW()
)

refresh_tokens (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
  token_hash  VARCHAR(255) UNIQUE NOT NULL,
  expires_at  TIMESTAMP NOT NULL,
  revoked_at  TIMESTAMP,
  ip_address  VARCHAR(45),
  user_agent  TEXT,
  created_at  TIMESTAMP DEFAULT NOW()
)

login_attempts (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email       VARCHAR(150) NOT NULL,
  ip_address  VARCHAR(45),
  success     BOOLEAN NOT NULL,
  created_at  TIMESTAMP DEFAULT NOW()
  -- Strategy: cleanup otomatis data > 90 hari via scheduled job
)

password_histories (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID REFERENCES users(id) ON DELETE CASCADE,
  password_hash   VARCHAR(255) NOT NULL,
  created_at      TIMESTAMP DEFAULT NOW()
  -- Simpan maksimal 5 history per user
)

-- ============================================================
-- AUDIT & CONFIG
-- ============================================================
audit_logs (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID REFERENCES users(id) ON DELETE SET NULL,
  action         VARCHAR(50) NOT NULL,
  module         VARCHAR(100) NOT NULL,
  entity_id      VARCHAR(100),
  old_value      JSONB,
  new_value      JSONB,
  ip_address     VARCHAR(45),
  user_agent     TEXT,
  request_id     VARCHAR(100),           -- correlation ID
  created_at     TIMESTAMP DEFAULT NOW()
  -- Strategy: retensi 1 tahun, partisi per bulan untuk performa
)

app_settings (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key         VARCHAR(100) UNIQUE NOT NULL,
  value       TEXT,
  type        VARCHAR(20) DEFAULT 'string',  -- string|boolean|number|json
  is_public   BOOLEAN DEFAULT false,
  is_secret   BOOLEAN DEFAULT false,         -- secret tidak dikembalikan ke frontend
  updated_by  UUID REFERENCES users(id),
  updated_at  TIMESTAMP DEFAULT NOW(),
  created_at  TIMESTAMP DEFAULT NOW()
)
```

**Index yang wajib ada:**
```sql
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_refresh_tokens_token_hash ON refresh_tokens(token_hash);
CREATE INDEX idx_login_attempts_email_created ON login_attempts(email, created_at);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_module ON audit_logs(module);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
```

**Migration Strategy:**
- Setiap perubahan schema wajib lewat Alembic migration
- `alembic upgrade head` setelah setiap deploy
- Setiap migration harus reversible (`downgrade`)

---

## 11. Modules V1.0

| Module | Fitur |
|---|---|
| **Auth** | Login, Logout, Refresh Token, Forgot Password, Reset Password, Email Verification |
| **Security** | Rate limiting, Account lockout, Session revoke, Token blacklist, Password history, CSRF protection |
| **User Management** | CRUD (status: pending/active/inactive/suspended), assign role, force logout |
| **Role & Permission** | CRUD role, permission matrix format `resource.action`, effective permissions |
| **Menu Management** | Dynamic menu dari DB, visibility per role, parent-child (max 3 level), ordering |
| **Profile** | Edit profil, ganti password, upload avatar, kelola active sessions |
| **Dashboard** | Statistik cards + grafik line & bar |
| **Audit Log** | Read-only log, filter by user/module/date, correlation ID |
| **App Settings** | Key-value config, public/private/secret flag |
| **Email** | Verification, reset password, user invitation via Mailpit (dev) |

---

## 12. Security Features

### Authentication & Session
- JWT Access Token expire **15 menit**
- JWT Refresh Token expire **7 hari**
- Refresh token rotation — token lama langsung di-revoke saat dipakai
- Token disimpan di **httpOnly cookie** (`Secure`, `SameSite=Lax`)
- Token blacklist di Redis saat logout
- Revoke all sessions (force logout semua device)

### Password Hashing
- **Argon2** via `pwdlib` (lebih aman dari Bcrypt untuk GPU attack)
- Password history — tidak bisa pakai **5 password terakhir**

### Brute Force Protection
- Max **5 kali** login gagal → akun terkunci **15 menit**
- Login attempt log per IP dan per email
- Rate limiting per endpoint via SlowAPI + Redis

### CSRF Protection
- Semua request mutasi berbasis cookie wajib punya CSRF protection
- Double Submit Cookie pattern atau SameSite=Lax + Origin check

### API Security
- CORS whitelist — hanya domain terdaftar yang diizinkan
- HTTPS only di production
- SQL injection protection via SQLAlchemy ORM
- XSS protection via Pydantic strict validation
- Security headers: `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`
- Secret berasal dari environment variable, bukan source code

### Password Policy
- Minimal **8 karakter**
- Wajib: huruf besar + huruf kecil + angka + simbol
- Validasi via Pydantic validator
- Pesan error spesifik per kriteria

### Audit Trail
- Semua aksi auth dicatat (login, logout, gagal login, reset password)
- Semua CRUD user/role/permission dicatat dengan `old_value` & `new_value`
- IP address, user agent, dan `request_id` (correlation ID) dicatat
- Secret, password, token tidak boleh masuk audit log

---

## 13. Error Contract

Semua error API menggunakan format yang konsisten:

```json
{
  "error": {
    "code": "USERS_EMAIL_ALREADY_EXISTS",
    "message": "Email sudah digunakan.",
    "details": [],
    "request_id": "req_01j9k..."
  }
}
```

Format sukses:
```json
{
  "data": { ... },
  "message": "Berhasil"
}
```

Format paginated:
```json
{
  "data": [ ... ],
  "meta": {
    "page": 1,
    "per_page": 10,
    "total": 100,
    "total_pages": 10
  }
}
```

**Error code convention:** `MODULE_DESCRIPTION` dalam huruf kapital, contoh:
- `AUTH_INVALID_CREDENTIALS`
- `AUTH_ACCOUNT_LOCKED`
- `USERS_EMAIL_ALREADY_EXISTS`
- `ROLES_CANNOT_DELETE_SYSTEM_ROLE`

**HTTP Status yang digunakan:**

| Status | Kapan |
|---|---|
| 200 | Sukses |
| 201 | Resource created |
| 400 | Bad request / validasi gagal |
| 401 | Tidak terautentikasi |
| 403 | Tidak punya permission |
| 404 | Resource tidak ditemukan |
| 409 | Conflict (email duplikat, dll) |
| 422 | Unprocessable entity (Pydantic error) |
| 423 | Locked (account lockout) |
| 429 | Rate limit exceeded |
| 500 | Internal server error |

---

## 14. Non-Functional Requirements

### 14.1 Performance
- API list umum: p95 < **500ms** di environment production normal
- Navigasi frontend tidak boleh memblokir input user
- Route utama menggunakan code splitting (lazy loading)
- Query yang sering digunakan memiliki index database yang terverifikasi
- File binary tidak diproksikan melalui API untuk alur upload normal

### 14.2 Accessibility
- Alur inti dapat digunakan dengan keyboard navigasi
- Focus state terlihat jelas di semua komponen interaktif
- Semua input memiliki label dan error association yang benar
- Kontras warna mengikuti **WCAG 2.2 AA** untuk teks dan kontrol utama
- Animasi menghormati `prefers-reduced-motion`

### 14.3 Browser Compatibility
Mendukung **2 versi terbaru** dari:

| Browser | |
|---|---|
| Google Chrome | ✅ |
| Microsoft Edge | ✅ |
| Mozilla Firefox | ✅ |
| Safari | ✅ |

Layout minimum diuji pada lebar: **360px, 768px, 1024px, 1440px**

### 14.4 Observability
- Setiap HTTP request memiliki **Correlation ID / Request ID** yang unik
- Log production berbentuk **structured JSON** (bukan plain text)
- Log tidak memuat credential, token, cookie, atau payload sensitif
- Error yang penting dapat ditelusuri via request_id tanpa expose internal stack trace
- Error reporting eksternal dan tracing disediakan sebagai integrasi opsional

### 14.5 Availability & Data Integrity
- Operasi multi-write penting menggunakan **database transaction**
- Migration dapat dijalankan deterministik dari environment kosong
- Endpoint health membedakan **liveness** dan **readiness**
- Backup dan restore PostgreSQL terdokumentasi

---

## 15. GitHub Actions CI/CD

### Frontend — `ci.yml`
```yaml
trigger: push & PR ke branch main dan dev

steps:
  1. Checkout code
  2. Setup pnpm + Node.js
  3. Install dependencies (pnpm install --frozen-lockfile)
  4. TypeScript check (tsc --noEmit)
  5. ESLint check
  6. Vitest (unit tests)
  7. Build check (vite build)
  8. Playwright E2E (opsional, hanya di PR ke main)
```

### Backend — `ci.yml`
```yaml
trigger: push & PR ke branch main dan dev

steps:
  1. Checkout code
  2. Setup uv + Python
  3. Install dependencies (uv sync)
  4. Ruff lint + format check
  5. Pyright type check
  6. pytest (unit + integration, dengan PostgreSQL service container)
  7. Alembic upgrade head (di test DB)
  8. Export openapi.json dan cek tidak ada breaking change
```

### Infrastructure — `ci.yml`
```yaml
trigger: push & PR ke branch main dan dev

steps:
  1. Checkout semua repo (frontend + backend + infrastructure)
  2. Build Docker images
  3. docker compose up
  4. Playwright E2E lintas repo
  5. Smoke test
```

### Deploy — `deploy.yml`
```yaml
trigger: merge ke branch main

steps:
  1. Build Docker image
  2. Push ke container registry
  3. Deploy ke server (SSH / webhook)
  4. Run alembic upgrade head
  5. Health check (liveness + readiness)
  6. Rollback otomatis jika health check gagal
```

### Branch Strategy
```
main        ← production, protected, hanya via PR + CI pass
dev         ← staging, protected, hanya via PR + CI pass
feat/[story-id]-[slug]   ← dari dev
fix/[story-id]-[slug]    ← dari dev
```

---

## 16. GitHub Labels

### Type
| Label | Warna | Keterangan |
|---|---|---|
| `type: epic` | `#7B2FBE` | Kumpulan stories satu modul besar |
| `type: story` | `#0075CA` | User story yang bisa dikerjakan |
| `type: task` | `#BFD4F2` | Sub-task teknis dari sebuah story |
| `type: bug` | `#D73A4A` | Sesuatu yang tidak berfungsi |
| `type: spike` | `#E4E669` | Research / investigasi teknis |
| `type: chore` | `#EDEDED` | Setup, config, dependency update |

### Priority
| Label | Warna | Keterangan |
|---|---|---|
| `priority: critical` | `#B60205` | Blocker, harus selesai dulu |
| `priority: high` | `#E4430A` | Sprint ini wajib dikerjakan |
| `priority: medium` | `#F9A825` | Bisa sprint ini atau berikutnya |
| `priority: low` | `#0E8A16` | Nice to have |

### Status (Scrum Flow)
| Label | Warna | Keterangan |
|---|---|---|
| `status: product-backlog` | `#C5DEF5` | Masuk backlog, belum direfine |
| `status: ready` | `#0052CC` | Sudah direfine, siap masuk sprint |
| `status: in-sprint` | `#5319E7` | Masuk sprint aktif |
| `status: in-progress` | `#FBCA04` | Sedang dikerjakan |
| `status: in-review` | `#FF7619` | PR open, menunggu review |
| `status: done` | `#006B75` | Selesai dan merged |

### Phase
| Label | Warna |
|---|---|
| `phase: 0-setup` | `#F1E05A` |
| `phase: 1-auth` | `#E99695` |
| `phase: 2-user-role` | `#B4A7D6` |
| `phase: 3-menu-dashboard` | `#A2C4C9` |
| `phase: 4-profile-audit` | `#D5A6BD` |
| `phase: 5-stabilization` | `#B6D7A8` |

### Scope & Special
| Label | Warna |
|---|---|
| `scope: frontend` | `#61DAFB` |
| `scope: backend` | `#009688` |
| `scope: database` | `#FF9800` |
| `scope: devops` | `#607D8B` |
| `scope: infra` | `#546E7A` |
| `security` | `#D93F0B` |
| `blocked` | `#000000` |
| `needs-clarification` | `#CC317C` |

---

## 17. Phases & Milestones

| Phase | Milestone | Fokus | Sprint |
|---|---|---|---|
| **Phase 0** | `v0.1-setup` | Infrastruktur, 3 repo setup, skeleton | Sprint 1 |
| **Phase 1** | `v0.2-auth` | Authentication + Security layer | Sprint 2–3 |
| **Phase 2** | `v0.3-user-role` | User, Role & Permission Management | Sprint 4–5 |
| **Phase 3** | `v0.4-menu-dashboard` | Menu dinamis & Dashboard | Sprint 6 |
| **Phase 4** | `v0.5-profile-audit` | Profile, Audit Log, App Settings | Sprint 7 |
| **Phase 5** | `v1.0-stable` | Stabilisasi, bug fix, dokumentasi, E2E | Sprint 8 |

---

## 18. Epics

| Epic ID | Nama Epic | Phase | Milestone |
|---|---|---|---|
| EP-01 | Infrastructure & DevOps Setup | 0 | v0.1-setup |
| EP-02 | Authentication | 1 | v0.2-auth |
| EP-03 | Security Layer | 1 | v0.2-auth |
| EP-04 | User Management | 2 | v0.3-user-role |
| EP-05 | Role & Permission Management | 2 | v0.3-user-role |
| EP-06 | Menu Management | 3 | v0.4-menu-dashboard |
| EP-07 | Dashboard | 3 | v0.4-menu-dashboard |
| EP-08 | Profile & Session | 4 | v0.5-profile-audit |
| EP-09 | Audit Log | 4 | v0.5-profile-audit |
| EP-10 | App Settings | 4 | v0.5-profile-audit |
| EP-11 | Testing & Quality | 5 | v1.0-stable |

---

## 19. Product Backlog

### EP-01 · Infrastructure & DevOps Setup
`phase: 0-setup`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-000a | Buat tiga repo GitHub (frontend, backend, infrastructure) | devops | critical | ready |
| S-000b | Setup GitHub Labels (Scrum-based) di ketiga repo | devops | critical | ready |
| S-000c | Setup GitHub Projects — Kanban board 6 kolom | devops | critical | ready |
| S-000d | Buat semua GitHub Issues dari Product Backlog | devops | critical | ready |
| S-000e | Setup branch protection rules (main & dev) di ketiga repo | devops | critical | ready |
| S-000f | Push PRD.md, CHANGELOG.md ke docs/ di repo infrastructure | devops | critical | ready |
| S-000g | Setup repo infrastructure: Docker Compose (app + db + redis + mailpit) | infra | critical | ready |
| S-001 | Setup repo backend: FastAPI + uv + folder structure + .env.example | backend | critical | ready |
| S-002 | Setup repo frontend: Vite + React 19 + TS + Tailwind v4 + pnpm + FSD structure | frontend | critical | ready |
| S-003 | Konfigurasi koneksi PostgreSQL & Redis di backend | backend, database | critical | ready |
| S-004 | Setup Alembic & initial migration (semua tabel + index) | backend, database | critical | ready |
| S-005 | Setup ESLint + Prettier + Vitest di frontend | frontend, devops | medium | ready |
| S-006 | Setup Ruff + Pyright di backend | backend, devops | medium | ready |
| S-007 | Setup OpenAPI export script (`scripts/export_openapi.py`) | backend | high | ready |
| S-008 | Setup Orval di frontend (baca openapi.json, generate ke `shared/api/generated/`) | frontend | high | ready |
| S-009 | CI workflow frontend (tsc, lint, vitest, build) | devops | high | ready |
| S-010 | CI workflow backend (ruff, pyright, pytest, alembic, openapi export) | devops | high | ready |
| S-011 | CI workflow infrastructure (docker compose up, smoke test) | devops, infra | medium | product-backlog |
| S-012 | Deploy workflow staging | devops | medium | product-backlog |

---

### EP-02 · Authentication
`phase: 1-auth`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-013 | API: Register user baru → status pending, kirim email verifikasi | backend | high | ready |
| S-014 | API: Login → return JWT access token + refresh token (httpOnly cookie) | backend | critical | ready |
| S-015 | API: Logout → revoke refresh token + blacklist access token di Redis | backend | critical | ready |
| S-016 | API: Refresh token rotation | backend | critical | ready |
| S-017 | API: Forgot password → kirim email reset link | backend | high | ready |
| S-018 | API: Reset password via token | backend | high | ready |
| S-019 | API: Verifikasi email via token → status active | backend | high | ready |
| S-020 | FE: Halaman Login (form, validasi, error handling, animasi) | frontend | critical | ready |
| S-021 | FE: Halaman Forgot Password | frontend | high | product-backlog |
| S-022 | FE: Halaman Reset Password | frontend | high | product-backlog |
| S-023 | FE: AuthContext — token state, user state, persist session | frontend | critical | ready |
| S-024 | FE: Axios interceptor — auto attach token + auto refresh saat 401 | frontend | critical | ready |
| S-025 | FE: Halaman Email Verification (tampilkan status verifikasi) | frontend | high | product-backlog |

---

### EP-03 · Security Layer
`phase: 1-auth` | `security`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-026 | Account lockout setelah 5x login gagal → terkunci 15 menit | backend, security | critical | ready |
| S-027 | Catat setiap login attempt (email, IP, success/fail) | backend, security | high | ready |
| S-028 | Rate limiting per endpoint (SlowAPI + Redis) | backend, security | high | ready |
| S-029 | CORS whitelist via environment variable | backend, security | critical | ready |
| S-030 | Password policy: Argon2 + min 8 char + kombinasi wajib | backend, security | high | ready |
| S-031 | Password history: tidak bisa pakai 5 password terakhir | backend, security | medium | product-backlog |
| S-032 | Token blacklist di Redis saat logout | backend, security | high | ready |
| S-033 | CSRF protection untuk semua request mutasi berbasis cookie | backend, security | high | ready |
| S-034 | Correlation ID middleware — setiap request punya request_id unik | backend | high | ready |
| S-035 | Security headers (X-Content-Type-Options, X-Frame-Options, dll) | backend, security | medium | product-backlog |
| S-036 | API: Revoke semua session aktif (force logout all devices) | backend, security | high | product-backlog |

---

### EP-04 · User Management
`phase: 2-user-role`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-037 | API: List user (pagination, search, filter by status & role) | backend | high | product-backlog |
| S-038 | API: Create user → status pending + kirim undangan email | backend | high | product-backlog |
| S-039 | API: Update user (name, email) | backend | high | product-backlog |
| S-040 | API: Soft delete user (set deleted_at) | backend | medium | product-backlog |
| S-041 | API: Update status user (pending/active/inactive/suspended) | backend | high | product-backlog |
| S-042 | API: Assign role ke user | backend | high | product-backlog |
| S-043 | API: Upload avatar user | backend | medium | product-backlog |
| S-044 | FE: Halaman list user (TanStack Table + search + filter + pagination) | frontend | high | product-backlog |
| S-045 | FE: Modal create & edit user | frontend | high | product-backlog |
| S-046 | FE: Status badge + assign role di halaman user | frontend | high | product-backlog |

---

### EP-05 · Role & Permission Management
`phase: 2-user-role`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-047 | API: CRUD Role (system role dilindungi dari delete) | backend | high | product-backlog |
| S-048 | API: Seed Permission otomatis dari modul (format: resource.action) | backend | high | product-backlog |
| S-049 | API: Assign permission ke role (matrix) | backend | high | product-backlog |
| S-050 | Backend: Middleware permission guard (@require_permission) | backend | critical | product-backlog |
| S-051 | FE: Halaman list role | frontend | high | product-backlog |
| S-052 | FE: Permission matrix per role (TanStack Table + checkbox) | frontend | high | product-backlog |
| S-053 | FE: Route guard → redirect 403 | frontend | critical | product-backlog |
| S-054 | FE: UI guard — `usePermission` hook + `<Can>` component | frontend | high | product-backlog |

---

### EP-06 · Menu Management
`phase: 3-menu-dashboard`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-055 | API: CRUD Menu (parent-child max 3 level, ordering, cycle prevention) | backend | high | product-backlog |
| S-056 | API: Get dynamic menu berdasarkan role user + cache Redis 5 menit | backend | high | product-backlog |
| S-057 | FE: Halaman menu management (tree view + drag-drop ordering) | frontend | high | product-backlog |
| S-058 | FE: Sidebar dinamis dari API berdasarkan role, accordion, collapsible | frontend | critical | product-backlog |

---

### EP-07 · Dashboard
`phase: 3-menu-dashboard`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-059 | API: Stats summary (total user per status, total role, login hari ini) | backend | high | product-backlog |
| S-060 | API: Login activity data (per hari, 30 hari terakhir) | backend | medium | product-backlog |
| S-061 | FE: Stat cards komponen (animasi Framer Motion) | frontend | high | product-backlog |
| S-062 | FE: Line chart — aktivitas login (Recharts, responsif) | frontend | medium | product-backlog |
| S-063 | FE: Bar chart — distribusi user per role (Recharts) | frontend | medium | product-backlog |

---

### EP-08 · Profile & Session
`phase: 4-profile-audit`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-064 | API: Get & update profil (nama, avatar) | backend | high | product-backlog |
| S-065 | API: Ganti password (verifikasi password lama + history check) | backend | high | product-backlog |
| S-066 | API: List session aktif + revoke session tertentu | backend | medium | product-backlog |
| S-067 | FE: Halaman profil (edit, upload avatar, ganti password) | frontend | high | product-backlog |
| S-068 | FE: Tab active sessions + tombol revoke | frontend | medium | product-backlog |

---

### EP-09 · Audit Log
`phase: 4-profile-audit` | `security`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-069 | Backend: Auto-log middleware + catat request_id + tidak log secret | backend | high | product-backlog |
| S-070 | API: List audit log (filter + pagination, hanya admin) | backend | high | product-backlog |
| S-071 | FE: Halaman audit log (TanStack Table + filter + export CSV) | frontend | high | product-backlog |

---

### EP-10 · App Settings
`phase: 4-profile-audit`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-072 | API: Get & update app settings (secret tidak dikembalikan ke FE) | backend | medium | product-backlog |
| S-073 | FE: Halaman settings (editor key-value, badge public/private/secret) | frontend | medium | product-backlog |

---

### EP-11 · Testing & Quality
`phase: 5-stabilization`

| Story ID | User Story | Scope | Priority | Status |
|---|---|---|---|---|
| S-074 | Setup Playwright E2E di repo infrastructure (login, CRUD user flow) | frontend, infra | high | product-backlog |
| S-075 | Unit test backend: auth endpoints (login, logout, refresh, lockout) | backend | high | product-backlog |
| S-076 | Unit test backend: permission guard middleware | backend | high | product-backlog |
| S-077 | MSW mock setup untuk unit test frontend | frontend | medium | product-backlog |
| S-078 | Accessibility audit: keyboard navigation + WCAG 2.2 AA check | frontend | medium | product-backlog |
| S-079 | Performance audit: p95 API response time check di staging | backend | medium | product-backlog |
| S-080 | Structured JSON logging + request_id di semua log | backend | high | product-backlog |
| S-081 | README lengkap di ketiga repo (setup local, run, deploy) | devops, infra | high | product-backlog |

---

## 20. Sprint 1 — Ready to Start

Sprint Goal: **"Tiga repo siap, skeleton berjalan, CI aktif."**

| Story ID | Story | Scope |
|---|---|---|
| S-000a | Buat tiga repo GitHub | devops |
| S-000b | Setup GitHub Labels | devops |
| S-000c | Setup GitHub Projects Kanban | devops |
| S-000d | Buat semua GitHub Issues dari backlog | devops |
| S-000e | Branch protection rules | devops |
| S-000f | Push PRD ke docs/ repo infrastructure | devops |
| S-000g | Infrastructure repo: Docker Compose setup | infra |
| S-001 | Setup repo backend (FastAPI + uv) | backend |
| S-002 | Setup repo frontend (Vite + React + pnpm + FSD) | frontend |
| S-003 | Konfigurasi PostgreSQL & Redis | backend |
| S-004 | Setup Alembic & initial migration | backend |
| S-005 | ESLint + Vitest frontend | frontend |
| S-006 | Ruff + Pyright backend | backend |
| S-007 | OpenAPI export script | backend |
| S-008 | Orval setup frontend | frontend |
| S-009 | CI workflow frontend | devops |
| S-010 | CI workflow backend | devops |

---

## 21. Way of Working — AI Agent + GitHub SSOT

### SSOT Hierarchy
```
1. GitHub Issues                  ← source of truth tasks & progress
2. BACKLOG.md (per repo)          ← mirror ringkas GitHub Issues
3. appbase-infrastructure/
   docs/PRD.md                    ← source of truth produk (dokumen ini)
   docs/DATABASE.md               ← source of truth schema
   docs/CHANGELOG.md              ← history keputusan
   docs/adr/                      ← Architecture Decision Records
```

### GitHub Projects — Kanban Columns
```
Product Backlog → Ready → In Sprint → In Progress → In Review → Done
```

### Alur Kerja AI Agent
```
START
  │
  ▼
1. LOOKUP
   → Baca GitHub Issues: label status: ready atau in-sprint
   → Baca PRD.md untuk konteks produk
   → Baca DATABASE.md jika task menyangkut schema
  │
  ▼
2. CLARIFY (jika ada ambiguitas)
   → Comment di GitHub Issue
   → Tambah label: needs-clarification
   → Tunggu jawaban sebelum lanjut
  │
  ▼
3. BRANCH
   → Buat dari dev
   → Naming: feat/[story-id]-[slug] atau fix/[story-id]-[slug]
  │
  ▼
4. BUILD
   → Implementasi sesuai story & acceptance criteria
   → Tidak keluar dari scope story
   → Ikuti error contract dan pola yang sudah ada
  │
  ▼
5. TEST
   → CI harus pass (lint + type check + test)
   → Tidak ada breaking change di openapi.json tanpa koordinasi
  │
  ▼
6. PR
   → PR ke branch dev
   → Judul: [Story ID] Deskripsi singkat
   → Body: "Closes #[issue-number]"
   → Update CHANGELOG.md
   → Update label: status: in-review
  │
  ▼
7. REVIEW
   → Tunggu approval manusia
  │
  ▼
8. MERGE
   → Issue closed otomatis
   → BACKLOG.md diupdate
   → status: done
```

### Commit Convention
```
feat(#14): tambah login endpoint JWT access + refresh token
fix(#26): perbaiki account lockout tidak reset setelah login sukses
docs(#7): update DATABASE.md dengan tabel email_verifications
security(#33): tambah CSRF protection untuk semua mutasi
chore(#1): setup repo backend dengan uv dan FastAPI
refactor(#50): pisah permission guard ke middleware terpisah
test(#75): tambah unit test login endpoint dengan lockout scenario
```

### BACKLOG.md Format
```markdown
# Backlog

> Mirror dari GitHub Issues. Source of truth: GitHub Issues.
> Last sync: [tanggal]

## In Sprint
- [ ] #14 S-014 API: Login + JWT `backend` `critical`

## Ready
- [ ] #13 S-013 API: Register user `backend` `high`

## In Progress
- [ ] #3 S-003 Konfigurasi PostgreSQL & Redis `backend` `critical`

## Done (Sprint 1)
- [x] #1 S-000a Buat tiga repo GitHub
```

---

## 22. Definition of Done V1.0

- [ ] Semua 11 epic selesai end-to-end (frontend + backend)
- [ ] CI pass di semua PR (lint, type check, test, build)
- [ ] Semua Alembic migration tersedia, clean, dan reversible
- [ ] `openapi.json` tersedia dan Orval generated client up-to-date
- [ ] Security checklist terpenuhi (lihat section 12)
- [ ] NFR terpenuhi: p95 < 500ms, WCAG 2.2 AA dasar, structured logging
- [ ] Error contract konsisten di semua endpoint
- [ ] README lengkap di ketiga repo: setup local, run, deploy
- [ ] `.env.example` tersedia di ketiga repo dengan semua variable terdokumentasi
- [ ] Tidak ada `TODO` atau hardcoded secret di codebase
- [ ] Semua endpoint API terdokumentasi via FastAPI auto-docs
- [ ] Playwright E2E: minimal alur login dan CRUD user berjalan
- [ ] CHANGELOG.md up-to-date di ketiga repo
- [ ] Test coverage backend: minimal 70%

---

*Dokumen ini adalah SSOT utama produk. Disimpan di `appbase-infrastructure/docs/PRD.md`.*
*Setiap keputusan arsitektur besar wajib dicatat di `docs/adr/`.*
*Update terakhir: September 2026 — v1.1.0*
