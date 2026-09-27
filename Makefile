# Makefile — Appbase Infrastructure

.PHONY: up down logs ps reset

## Jalankan semua service (background)
up:
	docker compose up -d

## Jalankan hanya infra (db + redis + mailpit), tanpa app
infra:
	docker compose up db redis mailpit -d

## Stop semua
down:
	docker compose down

## Reset data (hapus semua volume)
reset:
	docker compose down -v

## Lihat logs
logs:
	docker compose logs -f

## Status service
ps:
	docker compose ps
