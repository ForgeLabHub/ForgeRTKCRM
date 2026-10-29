# Deployment

English version of [../../operations/deployment.md](../../operations/deployment.md).
Existing detail: [DEPLOYMENT.md](../DEPLOYMENT.md),
[architecture/deployment-yandex-cloud.md](../architecture/deployment-yandex-cloud.md),
[architecture/deployment-current.md](../architecture/deployment-current.md).
This page is the checklist and an honest description of the contours.

## Contours

| Contour | What is used | Where it is described |
| --- | --- | --- |
| Local | `docker compose up` (backend, frontend, nginx, keycloak, redis, minio) | this file, `docker-compose.yml` |
| Main production | Yandex Cloud: VM + nginx + Managed PostgreSQL + Object Storage | `infra/yandex-cloud/` |
| Alternative | Render + Vercel + Supabase | `render.yaml`, `frontend/vercel.json` |

**Important:** the base `docker-compose.yml` brings up Keycloak, Redis and MinIO as well. If
you need a minimal set, start a subset:

```bash
make compose-up SERVICES="backend frontend nginx"
```

Keycloak is not mandatory for sign-in: local JWT sign-in remains the fallback (see
[KEYCLOAK.md](../KEYCLOAK.md)).

## Mandatory `.env` values

| Variable | Without it |
| --- | --- |
| `SECRET_KEY` | compose does not start (fail closed) |
| `MINIO_ROOT_PASSWORD` | compose does not start |
| `KEYCLOAK_ADMIN_PASSWORD` | compose does not start |
| `DATABASE_URL` | compose does not start |

Optional: `GIGACHAT_*` (without them the "Summary" tab reports that the service is not
configured), `NOTIFICATIONS_*`, `CORS_ORIGINS`.

## First deployment

```bash
cp .env.example .env      # fill in the mandatory values
make doctor               # check the host
make compose-up
make alembic-upgrade DATABASE_URL='...'    # if the database is empty and migrations were not applied automatically
make seed                 # optional: demo data
make smoke-test
```

## Before production

1. TLS on nginx, `CORS_ORIGINS` — an exact list of domains, not `*`.
2. `SECRET_KEY` — outside the repository and outside configuration copies.
3. Backups of PostgreSQL and the bucket; a restore that has been tested.
4. Keycloak: a dedicated realm and client, the public URL matching `KEYCLOAK_PUBLIC_URL`.
5. The demo passwords from the README (`admin123` and others) must not exist in production —
   `scripts/anonymize_case_data.py` for anonymising case data.
