# Build: from a clean machine to a working product

English version of [../BUILD.md](../../BUILD.md).

## Pinned versions

| Tool | Version | Source of truth |
| --- | --- | --- |
| Python | 3.11 | `backend/requirements.txt`, `ci.yml`, `scripts/doctor.sh` |
| Node.js | 18+ (frontend build) | `frontend/package.json`, `ci.yml` |
| PostgreSQL | 16 | `docker-compose.yml`, `infra/yandex-cloud/` |
| Python dependencies | exact versions (`==`) | `backend/requirements.txt` |
| npm dependencies | lockfile | `frontend/package-lock.json` (`npm ci`) |
| Alembic | 1.14 | the revision in `backend/alembic/versions` |

## Level A — source code

Locally only Python 3.11 is needed: the tests run on SQLite.

```bash
make doctor     # tools, .env, ports; changes nothing
make install
make test       # pytest, 23 files
make lint       # ruff
make typecheck  # mypy
make alembic-check
make docs-check
```

## Level B — artefacts

```bash
make build-frontend   # frontend/dist
```

The backend artefact is the image built from `backend/Dockerfile`.

## Level C — integration environment

```bash
cp .env.example .env    # SECRET_KEY, MINIO_ROOT_PASSWORD,
                        # KEYCLOAK_ADMIN_PASSWORD, DATABASE_URL are mandatory
make compose-up
make alembic-upgrade DATABASE_URL='postgresql+asyncpg://...'
make seed               # optional
make smoke-test
```

A minimal set of services (without Keycloak/Redis/MinIO):

```bash
make compose-up SERVICES="backend frontend nginx"
```

## Level D — container build

```bash
docker compose build
docker compose up -d
./scripts/smoke-test.sh http://localhost:8000 http://localhost:3000
```

## Level E — clean deployment

```bash
docker compose down -v          # deliberately: deletes data
make compose-up
make alembic-upgrade DATABASE_URL='...'   # schema from scratch
pg_dump → pg_restore → make smoke-test    # verifying a copy
```

Automated in `.github/workflows/portability.yml`.

## Environment variables

The full list is in `.env.example`. Mandatory (without them compose does not start):
`SECRET_KEY`, `MINIO_ROOT_PASSWORD`, `KEYCLOAK_ADMIN_PASSWORD`, `DATABASE_URL`.
Optional integrations: `GIGACHAT_CREDENTIALS`, `KEYCLOAK_*`, `S3_*`, `NOTIFICATIONS_*`.

## Typical errors

| Error | Cause | Solution |
| --- | --- | --- |
| `DATABASE_URL must be set` | empty `.env` | fill in the mandatory values |
| `/readyz` is not 200 | the database is unreachable or migrations are not applied | `make alembic-current`, backend logs |
| `Target database is not up to date` | the revision is behind | `make alembic-upgrade` |
| Tests "pollute" the dev database | an exported `DATABASE_URL` | `conftest.py` forces `test.db` — do not override it |
| The frontend cannot see the API | `VITE_API_URL`/CORS | see `frontend/.env.example`, `CORS_ORIGINS` |
| `npm ci` fails | the lockfile is out of sync | change `package.json` and the lockfile together |

## Proof

`ci.yml` — levels A–B, `portability.yml` — levels C–E. The matrix is in
[docs/verification/matrix.md](../verification/matrix.md).
