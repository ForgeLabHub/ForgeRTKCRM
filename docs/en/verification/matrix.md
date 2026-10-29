# Verification matrix

English version of [../../verification/matrix.md](../../verification/matrix.md).

| Check | What it proves | Command | CI |
| --- | --- | --- | --- |
| Backend tests on SQLite | the logic needs no external database | `make test` | `ci.yml` → `backend` |
| ruff + mypy | static rules are respected | `make lint typecheck` | `ci.yml` → `backend` |
| Models ↔ migrations match | the schema does not drift from the code | `make alembic-check` | `ci.yml` → `backend` |
| Frontend build | the UI builds reproducibly | `make build-frontend` | `ci.yml` → `frontend` |
| Migrations on an empty database | installation from scratch is possible | `make alembic-upgrade` | `portability.yml` → `alembic-fresh` |
| Repeated `upgrade head` | the upgrade is idempotent | `make alembic-upgrade` twice | `portability.yml` → `alembic-upgrade-path` |
| Backup → restore → smoke | data is restored | `pg_dump` → `pg_restore` → `make smoke-test` | `portability.yml` → `backup-restore` |
| The full stack comes up | the services talk to each other | `make compose-up` + `make smoke-test` | `portability.yml` → `compose-smoke` |
| Start without integrations | GigaChat/Keycloak/S3 are optional | `make compose-up SERVICES="backend frontend"` | `portability.yml` → `config-without-secrets` |
| Documentation is consistent | links are alive, module specs are complete | `make docs-check` | `portability.yml` → `docs` |
| Host check | the environment is suitable before start-up | `make doctor` | locally |
| Checks run on every branch | branch work does not reach merge unverified | `push` to any branch + PR | `ci.yml`, `portability.yml` (`branches: ["**"]`) |
| The CI mirror has not drifted from GitHub | the result does not depend on the platform | comparing the steps of `.sourcecraft/ci.yaml` with `ci.yml` | manually on CI changes |

## What is not checked automatically

- Real LMS/CMS exchange: the adapter is a mock, the contract is covered by dry-run tests.
- Performance and load.
- The Yandex Cloud production contour: verified by hand following
  [operations/deployment.md](../operations/deployment.md).
- Parity of the two CI descriptions (`.github/workflows/ci.yml` and `.sourcecraft/ci.yaml`)
  by step set — a divergence is possible, see the audit.
