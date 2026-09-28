# Docker Compose — Appbase Local Dev

Menjalankan stack lengkap secara lokal:

| Service  | URL / Port | Keterangan |
|----------|-----------|------------|
| **app** (FastAPI) | http://localhost:8000 | Backend API |
| **db** (PostgreSQL) | localhost:5432 | DB: appbase / user: appbase |
| **redis** | localhost:6379 | Cache + rate limit + token store |
| **mailpit** | http://localhost:8025 | Email UI dev |
| **mailpit SMTP** | localhost:1025 | SMTP untuk dev |

## Cara Pakai

```bash
# Jalankan semua service (kecuali app — untuk dev lokal biasanya run manual)
docker compose up db redis mailpit -d

# Atau jalankan semua termasuk app
docker compose up -d

# Stop semua
docker compose down

# Reset data (hapus volume)
docker compose down -v
```

## Prasyarat

- Docker & Docker Compose v2 terinstall
- File `.env` di `../appbase-backend/` sudah diisi (lihat `.env.example`)

## Koneksi dari Host

```
DATABASE_URL=postgresql+psycopg://appbase:appbase@localhost:5432/appbase
REDIS_URL=redis://localhost:6379/0
SMTP_HOST=localhost
SMTP_PORT=1025
```

## Production

```bash
docker compose -f docker-compose.prod.yml up -d
```
