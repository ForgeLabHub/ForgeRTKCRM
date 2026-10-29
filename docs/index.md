# Индекс документации

Точка входа. Существующие документы сохранены; здесь — карта и правила.

| Вопрос | Документ |
| --- | --- |
| Запустить с нуля | [../BUILD.md](../BUILD.md), [DEPLOYMENT.md](DEPLOYMENT.md) |
| Понять архитектуру | [architecture/ARCHITECTURE.md](architecture/ARCHITECTURE.md), [architecture/c4-context.md](architecture/c4-context.md), [architecture/c4-components.md](architecture/c4-components.md) |
| Модель данных | [architecture/er-model.md](architecture/er-model.md), [database/migrations.md](database/migrations.md) |
| Роли и вход | [ADMIN_GUIDE.md](ADMIN_GUIDE.md), [KEYCLOAK.md](KEYCLOAK.md) |
| Что делает функция | [modules/](modules/) |
| Ошибки API | [ERROR_CODES.md](ERROR_CODES.md), [api/conventions.md](api/conventions.md) |
| Эксплуатация и прод | [operations/deployment.md](operations/deployment.md), [operations/monitoring.md](operations/monitoring.md) |
| Безопасность | [SECURITY.md](SECURITY.md), [security/SAST-SCA.md](security/SAST-SCA.md) |
| AI-сводка | [AI.md](AI.md) |
| Для пользователя | [USER_GUIDE.md](USER_GUIDE.md) |
| Питч и защита | [pitch.md](pitch.md), [qa-jury.md](qa-jury.md) |
| Чем доказано, что работает | [verification/matrix.md](verification/matrix.md), CI |
| Что было исправлено при аудите | [audit/portability-audit-2026-10-29.md](audit/portability-audit-2026-10-29.md) |

## Правила

1. Утверждение без проверки — обещание. См. [verification/matrix.md](verification/matrix.md).
2. Новый модуль без спецификации по [modules/module-template.md](modules/module-template.md)
   не считается готовым (проверяется `make docs-check`).
3. Два CI-описания (`.github/workflows/ci.yml` и `.sourcecraft/ci.yaml`) должны
   совпадать по набору проверок; расхождение — дефект, а не удобство.
