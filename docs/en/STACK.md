# Technology stack

English version of [../STACK.md](../STACK.md).
The document pins the versions and the purpose of the RTK CRM components (case 6, LCT 2026).

## Backend

| Component | Version | Purpose |
|---|---|---|
| Python | 3.11 | Language and runtime (`python:3.11-slim` image) |
| FastAPI | 0.141.1 | HTTP API, validation, OpenAPI |
| Uvicorn | 0.34.0 | ASGI server |
| Pydantic / pydantic-settings | 2.10.4 / 2.7.1 | Schemas and configuration from the environment |
| SQLAlchemy (async) | 2.0.36 | ORM, async engine |
| asyncpg | 0.30.0 | PostgreSQL driver |
| aiosqlite | 0.20.0 | SQLite driver for dev and tests |
| Alembic | 1.14.0 | Schema migrations |
| python-jose, passlib[bcrypt] | 3.5.0 / 1.7.4 | JWT and password hashing |
| Redis client | 5.2.1 | Report cache, potentially rate-limit counters |
| minio | 7.2.10 | S3-compatible file storage |
| APScheduler | 3.11.0 | Background checks for "stalled" requests |
| prometheus-fastapi-instrumentator | 8.1.0 | Metrics on `/metrics` |
| openpyxl, xlwt, xlrd, reportlab | — | Report export XLSX/XLS/PDF |
| loguru | 0.7.3 | Logging |
| pytest, pytest-asyncio | 9.1.1 / 1.4.0 | Tests |

## Frontend

| Component | Version | Purpose |
|---|---|---|
| React | 18.2 | UI |
| TypeScript | 5.2 | Typing |
| Vite | 5.0 | Build and dev server |
| Ant Design | 5.12 | Component library |
| React Router | 6.20 | Routing |
| TanStack Query | 5.x | Server state and cache |
| Zustand | 4.4 | Client state |
| Axios | 1.6 | HTTP client |
| Recharts | 3.x | Report charts |
| dnd-kit | 6.x / 8.x | Drag-and-drop of funnel stages |

## Infrastructure

| Component | Purpose |
|---|---|
| PostgreSQL | Main database (Yandex Managed PostgreSQL, a container on the VM, or Supabase) |
| Redis / KeyDB | Report aggregate cache; KeyDB is recommended by the customer as lighter |
| S3 storage | Request files: Yandex Object Storage or MinIO (S3-compatible API) |
| Keycloak | Groundwork for corporate authentication (a closed contour) |
| Nginx | Reverse proxy, TLS, static file serving |
| Docker Compose | Starting the whole contour with one command |

## External services and integrations

- **Yandex Cloud** — the main contour: Compute (VM), Managed PostgreSQL, Object Storage,
  Container Registry, Cloud DNS.
- **Render + Vercel + Supabase** — an alternative contour without infrastructure of its own
  (API hosting, frontend static files, PostgreSQL).
- **GigaChat** — a summary for an interaction card (FT-6). Connected with an authorization
  key; without it the feature is off and the application works as usual.
- **LMS/Laravel** — integration groundwork (httpx), not in the MVP.

## Environment requirements

- Python 3.11+, Node.js 20+.
- For the full contour: Docker and Docker Compose.
- The minimum for running the API without infrastructure: SQLite + a local `uploads/`.
