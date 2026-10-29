# Сборка: от чистой машины до работающего продукта

## Закреплённые версии

| Инструмент | Версия | Источник истины |
| --- | --- | --- |
| Python | 3.11 | `backend/requirements.txt`, `ci.yml`, `scripts/doctor.sh` |
| Node.js | 18+ (сборка фронтенда) | `frontend/package.json`, `ci.yml` |
| PostgreSQL | 16 | `docker-compose.yml`, `infra/yandex-cloud/` |
| Python-зависимости | точные версии (`==`) | `backend/requirements.txt` |
| npm-зависимости | lockfile | `frontend/package-lock.json` (`npm ci`) |
| Alembic | 1.14 | ревизия `backend/alembic/versions` |

## Уровень A — исходный код

Локально нужен только Python 3.11: тесты работают на SQLite.

```bash
make doctor     # инструменты, .env, порты; ничего не меняет
make install
make test       # pytest, 23 файла
make lint       # ruff
make typecheck  # mypy
make alembic-check
make docs-check
```

## Уровень B — артефакты

```bash
make build-frontend   # frontend/dist
```

Backend артефактом является образ `backend/Dockerfile`.

## Уровень C — интеграционная среда

```bash
cp .env.example .env    # обязательны SECRET_KEY, MINIO_ROOT_PASSWORD,
                        # KEYCLOAK_ADMIN_PASSWORD, DATABASE_URL
make compose-up
make alembic-upgrade DATABASE_URL='postgresql+asyncpg://...'
make seed               # опционально
make smoke-test
```

Минимальный набор сервисов (без Keycloak/Redis/MinIO):

```bash
make compose-up SERVICES="backend frontend nginx"
```

## Уровень D — контейнерная сборка

```bash
docker compose build
docker compose up -d
./scripts/smoke-test.sh http://localhost:8000 http://localhost:3000
```

## Уровень E — чистое развёртывание

```bash
docker compose down -v          # осознанно: удаляет данные
make compose-up
make alembic-upgrade DATABASE_URL='...'   # схема с нуля
pg_dump → pg_restore → make smoke-test    # проверка копии
```

Автоматизировано в `.github/workflows/portability.yml`.

## Переменные окружения

Полный список — `.env.example`. Обязательные (без них compose не стартует):
`SECRET_KEY`, `MINIO_ROOT_PASSWORD`, `KEYCLOAK_ADMIN_PASSWORD`, `DATABASE_URL`.
Опциональные интеграции: `GIGACHAT_CREDENTIALS`, `KEYCLOAK_*`, `S3_*`,
`NOTIFICATIONS_*`.

## Типовые ошибки

| Ошибка | Причина | Решение |
| --- | --- | --- |
| `DATABASE_URL must be set` | пустой `.env` | заполнить обязательные значения |
| `/readyz` не 200 | БД недоступна или миграции не применены | `make alembic-current`, логи backend |
| `Target database is not up to date` | ревизия отстаёт | `make alembic-upgrade` |
| Тесты «загрязняют» dev-базу | экспортированный `DATABASE_URL` | `conftest.py` принудительно ставит `test.db` — не переопределяйте |
| Фронтенд не видит API | `VITE_API_URL`/CORS | см. `frontend/.env.example`, `CORS_ORIGINS` |
| `npm ci` падает | рассинхронизация lockfile | править `package.json` и lockfile вместе |

## Доказательство

`ci.yml` — уровни A–B, `portability.yml` — уровни C–E. Матрица —
[docs/verification/matrix.md](docs/verification/matrix.md).
