# API conventions

English version of [../../api/conventions.md](../../api/conventions.md).
The live specification is the Swagger UI at `/docs` and `/openapi.json` of a running
backend. Error codes are in [ERROR_CODES.md](../ERROR_CODES.md).

## Rules

| Rule | Detail |
| --- | --- |
| Format | JSON, FastAPI + Pydantic 2 |
| Authentication | JWT (local) or Keycloak Authorization Code Flow + PKCE; roles `admin` / `manager` |
| Liveness | `/healthz` (process), `/readyz` (readiness, including the database) |
| Idempotency | import from LMS/CMS — by `contract_number`; a repeated import creates no duplicate |
| Business constraint | a university has at most 2 active interactions — enforced on the backend, not in the UI |
| Errors | one schema from `ERROR_CODES.md`, a machine-readable code plus a human message |

## Trust boundaries

- The role is checked on the backend; the UI hides elements but is not a protection.
- Secrets (GigaChat, Keycloak, MinIO) never appear in API responses; `test_security_headers.py`
  and `test_cors.py` pin the headers and the CORS policy.

## How to change the API

1. Change the router and the schema. 2. Update `frontend/src/api/*`. 3. Run
`make test lint typecheck`. 4. Add a row to
[verification/matrix.md](../verification/matrix.md) if a new claim appeared.
