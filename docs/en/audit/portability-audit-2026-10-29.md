# Portability audit — 2026-10-29

English version of [../../audit/portability-audit-2026-10-29.md](../../audit/portability-audit-2026-10-29.md).

## What was already in good shape

| Area | Observation |
| --- | --- |
| Documentation | `docs/architecture/` with C4 diagrams, an ER model, Archimate; `ADMIN_GUIDE`, `USER_GUIDE`, `SECURITY`, `SAST-SCA` |
| Tests | 23 files, running on SQLite without an external database (`conftest.py`), including `test_schema_sync.py` |
| Migrations | Alembic, the revision in the repository, consistency checked against the models |
| CI | backend (tests, ruff, mypy), frontend, plus a duplicate description for SourceCraft |
| Readiness | `/healthz` and `/readyz` are separate — correct semantics |
| Compose | the whole contour (backend, frontend, nginx, keycloak, redis, minio) with one command |

## Gaps and what was done

| # | Gap | Impact | Closed by |
| --- | --- | --- | --- |
| 1 | No `Makefile` | commands scattered across README/DEPLOYMENT | a `Makefile` with 18 targets |
| 2 | No host check | configuration errors were caught after start-up | `scripts/doctor.sh` |
| 3 | No `smoke-test` | nothing to verify readiness with after a deployment | `scripts/smoke-test.sh` (`/healthz`, `/readyz`, `/docs`, `/openapi.json`, the frontend) |
| 4 | No documentation completeness check | documents rot silently | `scripts/docs-check.sh` |
| 5 | **The organisation README's clone instructions pointed at `Pavel1778/rtk-crm`** | the clone does not match the current home | the link was fixed to `ForgeLabHub` |
| 6 | `docs/README.md` claims that Keycloak/Redis/Nginx are "future options", while the base compose starts them | the document and reality diverge | an honest description in `docs/operations/deployment.md` + `make compose-up SERVICES="..."` for a minimal set |
| 7 | CI did not check migrations from scratch, a repeated `upgrade`, backup/restore or the full compose | portability was not proven | `portability.yml` |
| 8 | No module specifications | boundaries were not verifiable | `docs/modules/*` + a template + a CI check |
| 9 | No "claim → check" matrix | proven and promised could not be told apart | `docs/verification/matrix.md` |
| 10 | Two CI descriptions (GitHub and SourceCraft) | risk of the checks diverging | recorded in the matrix as not automatically verifiable |

## What remains open

- Demo passwords in the README (`admin123`, `manager123`) — acceptable for a case prototype,
  unacceptable in production: `scripts/anonymize_case_data.py` for anonymisation.
- No `/metrics`: observability rests on logs and health checks.
- No load tests (`tests/load` is a stub).
- The "2 active interactions" limit is not protected by a database schema constraint.
