# Модуль: интеграции (LMS/CMS, GigaChat, Keycloak, хранилище)

## 1. Назначение и границы
Внешние контуры: обмен с LMS и CMS, AI-сводка через GigaChat, вход через Keycloak,
файловое хранилище S3-совместимое, уведомления.
Не делает: ни одна интеграция не обязательна для запуска — без них продукт работает в
урезанном, но честном виде.

## 2. Сценарии использования
- Предпросмотр пакета из LMS/CMS (dry-run) до импорта.
- Идемпотентный импорт по `contract_number`.
- AI-сводка по карточке; при отсутствии ключа — сообщение «сервис не настроен».
- Вход через Keycloak (OIDC + PKCE); локальный JWT остаётся запасным.
- Отказ: внешний сервис недоступен → ошибка интеграции, ядро продолжает работать.

## 3. Контракт
`/api/integration/*` (предпросмотр, импорт), `/api/auth/*` (локальный и OIDC-вход).
Внутренние адаптеры: `services/integration.py`, `services/gigachat.py`,
`auth/keycloak.py`, `services/file_storage.py`.

## 4. Данные
Владеет результатами импорта (сущности создаются через модели ядра, а не прямыми
вставками). Файлы — в S3/MinIO; в БД хранятся только ссылки.

## 5. Права
Импорт и предпросмотр — только `admin`. Сводка — по роли, с ограничением набора
передаваемых данных. Секреты интеграций доступны только backend.

## 6. Зависимости
Исходящие: GigaChat API (TLS с сертификатом НУЦ Минцифры в `backend/certs`),
Keycloak, S3. Входящие: `api.*`.

## 7. Конфигурация
`GIGACHAT_CREDENTIALS`/`GIGACHAT_SCOPE`, `AUTH_MODE`, `KEYCLOAK_*`, `S3_*`,
`MINIO_ROOT_USER/PASSWORD`, `NOTIFICATIONS_ENABLED`. Пустые значения = интеграция
выключена, а не сломанный старт.

## 8. Сборка и отладка
```bash
python -m pytest tests/test_integration.py tests/test_keycloak_auth.py tests/test_gigachat_summary.py -q
```

## 9. Тесты
`test_integration.py` (dry-run и идемпотентность по `contract_number`),
`test_keycloak_auth.py` (PKCE-поток), `test_gigachat_summary.py` (сводка при
отсутствии ключа), `test_security_headers.py`, `test_cors.py`.

## 10. Наблюдаемость
Ошибки интеграций логируются без секретов; аудит фиксирует импорт. Ошибки:
`integration_unavailable`, `oidc_error`, `storage_error`.

## 11. Ограничения и готовность
- Обмен с LMS/CMS реализован mock-адаптером: контракт описан, реальная система не подключена.
- Keycloak в базовом compose поднимается, но для продукта опционален.
- Готовность: без GigaChat/Keycloak продукт запускается и проходит smoke test.
