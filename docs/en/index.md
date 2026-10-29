# Documentation index

English version of [../index.md](../index.md). Entry point. The existing documents are kept;
this page holds the map and the rules.

| Question | Document |
| --- | --- |
| Run from scratch | [../../BUILD.md](../../BUILD.md), [DEPLOYMENT.md](DEPLOYMENT.md) |
| Understand the architecture | [architecture/ARCHITECTURE.md](architecture/ARCHITECTURE.md), [architecture/c4-context.md](architecture/c4-context.md), [architecture/c4-components.md](architecture/c4-components.md) |
| Data model | [architecture/er-model.md](architecture/er-model.md), [database/migrations.md](database/migrations.md) |
| Roles and sign-in | [ADMIN_GUIDE.md](ADMIN_GUIDE.md), [KEYCLOAK.md](KEYCLOAK.md) |
| What a feature does | [modules/](modules/) |
| What to borrow for another project | [modules/module-map.md](modules/module-map.md) |
| API errors | [ERROR_CODES.md](ERROR_CODES.md), [api/conventions.md](api/conventions.md) |
| Operations and production | [operations/deployment.md](operations/deployment.md), [operations/monitoring.md](operations/monitoring.md) |
| Security | [SECURITY.md](SECURITY.md), [security/SAST-SCA.md](security/SAST-SCA.md) |
| AI summary | [AI.md](AI.md) |
| For the user | [USER_GUIDE.md](USER_GUIDE.md) |
| Pitch and defence | [pitch.md](pitch.md), [qa-jury.md](qa-jury.md) |
| What proves it works | [verification/matrix.md](verification/matrix.md), CI |
| What the audit fixed | [audit/portability-audit-2026-10-29.md](audit/portability-audit-2026-10-29.md) |

## Rules

1. A claim without a check is a promise. See [verification/matrix.md](verification/matrix.md).
2. A new module without a specification following
   [modules/module-template.md](modules/module-template.md) is not considered done (verified
   by `make docs-check`).
3. The two CI descriptions (`.github/workflows/ci.yml` and `.sourcecraft/ci.yaml`) must match
   in the set of checks; a divergence is a defect, not a convenience.

## Project management

- `forge.sh` / `forge.bat` — start, stop, logs, tests, database and containers with one
  command; see the section in the README.
