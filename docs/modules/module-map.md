# Карта модулей: что заимствовать в другой проект

Таблица отвечает на вопрос «что взять, если нужно X»: минимальный набор файлов,
зависимости и что придётся заменить. Спецификации отдельных модулей — в
[interactions.md](interactions.md), [reports.md](reports.md),
[integrations.md](integrations.md).

| Нужно | Взять файлы | Внешние зависимости | Заменить |
| --- | --- | --- | --- |
| Kanban-воркфлоу с этапами и переносом задач при удалении этапа | `backend/api/stages.py`, `backend/api/interactions.py`, `frontend/src/components/kanban/`, `frontend/src/hooks/useStages.ts` | dnd-kit | набор этапов и правило `scope` |
| Аудит изменяющих операций (152-ФЗ, ФСТЭК № 117) | `backend/middleware/audit.py`, `backend/api/audit.py` | SQLAlchemy | список редактируемых полей |
| RBAC и единая проверка доступа к объекту по id | `backend/auth/security.py`, `backend/api/access.py` | python-jose, passlib | роли и правило видимости |
| Вход через Keycloak (OIDC + PKCE, RS256/JWKS) | `backend/auth/keycloak.py`, `keycloak/realm-export.json` | Keycloak | realm, клиент, маппинг ролей |
| Заголовки безопасности и CORS без wildcard | `backend/middleware/security_headers.py`, `backend/main.py` (CORS) | FastAPI | список origin |
| Ограничение попыток входа | `backend/middleware/rate_limit.py` | Redis (опционально) | лимит и окно |
| Импорт XLS/XLSX/JSON с диалоговым маппингом колонок | `backend/services/excel_import.py`, `backend/services/import_report.py`, `frontend/src/pages/DirectoryPage.tsx` | openpyxl, xlrd, jsonschema | схема справочника |
| Экспорт отчётов в XLSX/XLS/PDF/JSON из одного конфига колонок | `backend/services/excel_export.py`, `backend/services/report_columns.py`, `config/report_columns.json` | openpyxl, xlwt, reportlab | набор колонок |
| Кэш агрегатов отчётов | `backend/services/report_cache.py` | Redis/KeyDB | TTL и ключи |
| Файлы в S3/MinIO с локальным fallback | `backend/services/file_storage.py`, `backend/api/files.py` | minio | бакет и лимиты |
| Необязательная AI-функция с деградацией без ключа | `backend/services/gigachat.py` | httpx | провайдер и промпт |
| Health-пробы и метрики | `backend/main.py` (`/healthz`, `/readyz`), `/metrics` | prometheus-fastapi-instrumentator | состав проверок |
| Воспроизводимая документация с паритетом языков | `tools/docs_pdf.py`, `scripts/docs-check.sh`, `Makefile` | markdown, weasyprint | набор документов |

## Правила переноса

1. Роутер не содержит бизнес-правил: лимиты и инварианты живут в `api/*` рядом с
   проверкой доступа, а сервисы (`services/`) не знают про HTTP.
2. Внешняя система всегда за адаптером: `gigachat.py`, `integration.py`,
   `file_storage.py` заменяются реализацией того же интерфейса.
3. Каждая необязательная функция деградирует, а не ломает старт: без GigaChat,
   Keycloak, Redis и MinIO продукт работает.
4. Тесты — часть модуля и не требуют сети и внешней СУБД: SQLite и подмена
   транспорта httpx.
5. Конфигурация — только через `backend/core/config.py` (`Settings`),
   обязательные секреты объявлены с `:?` в compose.
