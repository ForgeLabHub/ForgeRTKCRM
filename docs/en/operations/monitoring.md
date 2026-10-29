# Observability

English version of [../../operations/monitoring.md](../../operations/monitoring.md).

| Signal | Where | Purpose |
| --- | --- | --- |
| `/healthz` | backend | the process is alive |
| `/readyz` | backend | readiness, including database availability |
| Security headers | `backend/middleware/security_headers.py` | checked by `tests/test_security_headers.py` |
| Action audit | `backend/middleware/audit.py`, `backend/api/audit.py` | who changed what |
| Rate limit | `backend/middleware/rate_limit.py` | brute-force protection |
| Report cache | Redis/KeyDB (`services/report_cache.py`) | speeds up aggregates; when unavailable, computed directly |
| Notifications | `services/scheduler.py` | deadline reminders |

## Minimal alerts

1. `/readyz` does not answer for 2 minutes (unlike `/healthz`, this means a dependency
   failure).
2. The 5xx share is above 1% over 5 minutes.
3. Redis is unavailable — reports slow down; this is degradation, not an outage.
4. GigaChat errors while summarisation is enabled.
5. A growing number of 429s (rate limit) — possible brute force or a load spike.

## What is missing

- No `/metrics` and no ready-made dashboards: observability rests on logs, health checks and
  audit.
- No distributed tracing.
- No SLOs expressed as numbers.
