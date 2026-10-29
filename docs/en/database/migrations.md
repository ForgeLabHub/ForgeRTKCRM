# Migrations and schema

English version of [../../database/migrations.md](../../database/migrations.md).

## Tool

Alembic, with a single initial revision `backend/alembic/versions/e2df629b67e6_initial_schema.py`.
Configuration — `alembic.ini`, environment — `backend/alembic/env.py`.

## Commands

```bash
make alembic-upgrade DATABASE_URL='postgresql+asyncpg://user:pass@host:5432/db'
make alembic-current DATABASE_URL='...'
make alembic-check        # model/migration consistency (tests/test_schema_sync.py)
```

Locally SQLite (`aiosqlite`) is used by default, so tests and development need no external
database. Production is PostgreSQL 16.

## Rules

1. **One revision = one intention.** The message reflects the schema change, not a ticket
   number.
2. **Never edit an applied revision.** If a fix is needed, add a new revision.
3. **Models and migrations must match.** `tests/test_schema_sync.py` compares SQLAlchemy
   metadata with the history; a mismatch fails CI.
4. **Data is separate from schema.** Demo content is `scripts/seed.py`, not a migration.
5. **SQLite-only changes are not acceptable** as the only option: production is PostgreSQL.

## Upgrading an installed instance

1. Backup (`pg_dump`; for files — the S3/MinIO bucket).
2. `make alembic-upgrade` on the new image version.
3. `make alembic-current` — the version must match head.
4. `make smoke-test` — `/healthz`, `/readyz`, the frontend.
5. Check one flow by hand: board, card, report.

This is verified automatically in `.github/workflows/portability.yml`: installation from
scratch, a repeated `upgrade head`, the backup → restore → smoke cycle.
