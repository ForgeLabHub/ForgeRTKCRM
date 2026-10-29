# Развёртывание

Существующие подробности: [DEPLOYMENT.md](../DEPLOYMENT.md),
[architecture/deployment-yandex-cloud.md](../architecture/deployment-yandex-cloud.md),
[architecture/deployment-current.md](../architecture/deployment-current.md).
Здесь — контрольный список и честное описание контуров.

## Контуры

| Контур | Что используется | Где описано |
| --- | --- | --- |
| Локальный | `docker compose up` (backend, frontend, nginx, keycloak, redis, minio) | этот файл, `docker-compose.yml` |
| Основной прод | Yandex Cloud: ВМ + nginx + Managed PostgreSQL + Object Storage | `infra/yandex-cloud/` |
| Альтернативный | Render + Vercel + Supabase | `render.yaml`, `frontend/vercel.json` |

**Важно:** базовый `docker-compose.yml` поднимает и Keycloak, и Redis, и MinIO. Если
нужен минимальный набор, запускайте подмножество:

```bash
make compose-up SERVICES="backend frontend nginx"
```

Keycloak при этом не обязателен для входа: локальный JWT-вход остаётся запасным
вариантом (см. [KEYCLOAK.md](../KEYCLOAK.md)).

## Обязательные значения `.env`

| Переменная | Без неё |
| --- | --- |
| `SECRET_KEY` | compose не стартует (fail closed) |
| `MINIO_ROOT_PASSWORD` | compose не стартует |
| `KEYCLOAK_ADMIN_PASSWORD` | compose не стартует |
| `DATABASE_URL` | compose не стартует |

Опциональные: `GIGACHAT_*` (без них вкладка «Сводка» сообщает, что сервис не
настроен), `NOTIFICATIONS_*`, `CORS_ORIGINS`.

## Порядок первого развёртывания

```bash
cp .env.example .env      # заполнить обязательные значения
make doctor               # проверить хост
make compose-up
make alembic-upgrade DATABASE_URL='...'    # если база пустая и миграции не применены автоматически
make seed                 # опционально: демо-данные
make smoke-test
```

## Перед продом

1. TLS на nginx, `CORS_ORIGINS` — точный список домены, не `*`.
2. `SECRET_KEY` — вне репозитория и вне копий конфигурации.
3. Резервные копии PostgreSQL и бакета; проверенное восстановление.
4. Keycloak: отдельный realm и клиент, публичный URL согласован с `KEYCLOAK_PUBLIC_URL`.
5. Демо-пароли из README (`admin123` и др.) не должны существовать в проде —
   `scripts/anonymize_case_data.py` для обезличивания кейсовых данных.
