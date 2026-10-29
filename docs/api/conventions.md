# Соглашения API

Живая спецификация — Swagger UI на `/docs` и `/openapi.json` запущенного backend.
Коды ошибок — [ERROR_CODES.md](../ERROR_CODES.md).

## Правила

| Правило | Деталь |
| --- | --- |
| Формат | JSON, FastAPI + Pydantic 2 |
| Аутентификация | JWT (локально) или Keycloak Authorization Code Flow + PKCE; роли `admin` / `manager` |
| Проверка живости | `/healthz` (процесс), `/readyz` (готовность, включая БД) |
| Идемпотентность | импорт из LMS/CMS — по `contract_number`; повторный импорт не создаёт дубль |
| Бизнес-ограничение | у вуза не более 2 активных взаимодействий — проверяется на backend, не в UI |
| Ошибки | единая схема из `ERROR_CODES.md`, машиночитаемый код + человеческое сообщение |

## Границы доверия

- Роль проверяется на backend; UI скрывает элементы, но не является защитой.
- Секреты (GigaChat, Keycloak, MinIO) не попадают в ответы API; `test_security_headers.py`
  и `test_cors.py` фиксируют заголовки и CORS-политику.

## Как менять API

1. Изменить роутер и схему. 2. Обновить `frontend/src/api/*`. 3. Прогнать
`make test lint typecheck`. 4. Добавить строку в
[verification/matrix.md](../verification/matrix.md), если появилось новое утверждение.
