# Module map: what to borrow for another project

English version of [../../modules/module-map.md](../../modules/module-map.md).

The table answers "what to take if I need X": the minimal set of files, the dependencies, and
what has to be replaced. The specifications of the individual modules are in
[interactions.md](interactions.md), [reports.md](reports.md), [integrations.md](integrations.md).

| Need | Files to take | External dependencies | Replace |
| --- | --- | --- | --- |
| A Kanban workflow with stages and task transfer on stage deletion | `backend/api/stages.py`, `backend/api/interactions.py`, `frontend/src/components/kanban/`, `frontend/src/hooks/useStages.ts` | dnd-kit | the stage set and the `scope` rule |
| An audit of modifying operations (152-FZ, FSTEC No. 117) | `backend/middleware/audit.py`, `backend/api/audit.py` | SQLAlchemy | the list of redacted fields |
| RBAC and a single object-level access check by id | `backend/auth/security.py`, `backend/api/access.py` | python-jose, passlib | the roles and the visibility rule |
| Keycloak sign-in (OIDC + PKCE, RS256/JWKS) | `backend/auth/keycloak.py`, `keycloak/realm-export.json` | Keycloak | the realm, the client, the role mapping |
| Security headers and CORS without a wildcard | `backend/middleware/security_headers.py`, `backend/main.py` (CORS) | FastAPI | the origin list |
| Sign-in attempt limiting | `backend/middleware/rate_limit.py` | Redis (optional) | the limit and the window |
| XLS/XLSX/JSON import with dialogue-based column mapping | `backend/services/excel_import.py`, `backend/services/import_report.py`, `frontend/src/pages/DirectoryPage.tsx` | openpyxl, xlrd, jsonschema | the reference-data schema |
| Report export to XLSX/XLS/PDF/JSON from one column config | `backend/services/excel_export.py`, `backend/services/report_columns.py`, `config/report_columns.json` | openpyxl, xlwt, reportlab | the column set |
| A report aggregate cache | `backend/services/report_cache.py` | Redis/KeyDB | the TTL and the keys |
| Files in S3/MinIO with a local fallback | `backend/services/file_storage.py`, `backend/api/files.py` | minio | the bucket and the limits |
| An optional AI feature that degrades without a key | `backend/services/gigachat.py` | httpx | the provider and the prompt |
| Health probes and metrics | `backend/main.py` (`/healthz`, `/readyz`), `/metrics` | prometheus-fastapi-instrumentator | the set of checks |
| Reproducible documentation with language parity | `tools/docs_pdf.py`, `scripts/docs-check.sh`, `Makefile` | markdown, weasyprint | the document set |

## Transfer rules

1. A router holds no business rules: limits and invariants live in `api/*` next to the access
   check, and the services (`services/`) know nothing about HTTP.
2. An external system always sits behind an adapter: `gigachat.py`, `integration.py`,
   `file_storage.py` are replaced by an implementation of the same interface.
3. Every optional feature degrades instead of breaking start-up: without GigaChat, Keycloak,
   Redis and MinIO the product works.
4. Tests are part of the module and need no network or external database: SQLite and an httpx
   transport substitution.
5. Configuration goes through `backend/core/config.py` (`Settings`) only, and mandatory secrets
   are declared with `:?` in compose.
