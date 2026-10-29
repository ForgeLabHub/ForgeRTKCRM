# Module: integrations (LMS/CMS, GigaChat, Keycloak, storage)

English version of [../../modules/integrations.md](../../modules/integrations.md).

## 1. Purpose and boundaries
External contours: exchange with LMS and CMS, an AI summary through GigaChat, sign-in through
Keycloak, S3-compatible file storage, notifications.
It does not: no integration is mandatory for start-up — without them the product works in a
reduced but honest form.

## 2. Use cases
- Previewing a batch from LMS/CMS (dry run) before importing.
- Idempotent import by `contract_number`.
- An AI summary for a card; without a key a "service not configured" message is shown.
- Sign-in through Keycloak (OIDC + PKCE); local JWT remains the fallback.
- Failure: an external service is unavailable → an integration error, the core keeps working.

## 3. Contract
`/api/integration/*` (preview, import), `/api/auth/*` (local and OIDC sign-in).
Internal adapters: `services/integration.py`, `services/gigachat.py`, `auth/keycloak.py`,
`services/file_storage.py`.

## 4. Data
Owns the results of an import (entities are created through core models, not by direct
inserts). Files live in S3/MinIO; only references are stored in the database.

## 5. Permissions
Import and preview — `admin` only. The summary — by role, with a restriction on the data
passed along. Integration secrets are available to the backend only.

## 6. Dependencies
Outbound: the GigaChat API (TLS with the Ministry of Digital Development CA certificate in
`backend/certs`), Keycloak, S3. Inbound: `api.*`.

## 7. Configuration
`GIGACHAT_CREDENTIALS`/`GIGACHAT_SCOPE`, `AUTH_MODE`, `KEYCLOAK_*`, `S3_*`,
`MINIO_ROOT_USER/PASSWORD`, `NOTIFICATIONS_ENABLED`. Empty values mean the integration is off,
not a broken start.

## 8. Build and debugging
```bash
python -m pytest tests/test_integration.py tests/test_keycloak_auth.py tests/test_gigachat_summary.py -q
```

## 9. Tests
`test_integration.py` (dry run and idempotency by `contract_number`), `test_keycloak_auth.py`
(the PKCE flow), `test_gigachat_summary.py` (the summary without a key),
`test_security_headers.py`, `test_cors.py`.

## 10. Observability
Integration errors are logged without secrets; the audit records an import. Errors:
`integration_unavailable`, `oidc_error`, `storage_error`.

## 11. Limitations and readiness
- The LMS/CMS exchange is implemented by a mock adapter: the contract is described, the real
  system is not connected.
- Keycloak is started by the base compose but optional for the product.
- Readiness: without GigaChat/Keycloak the product starts and passes the smoke test.
