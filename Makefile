# RTK CRM — единая точка входа для сборки и проверок.
#
# Все цели работают из чистого клона. Секреты не нужны ни одной цели уровня A,
# кроме переменных, которые compose требует для запуска (см. BUILD.md).

SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

PYTHON        ?= python3
PYTHON_VERSION:= 3.11
COMPOSE       ?= docker compose
BACKEND_URL   ?= http://localhost:8000
SERVICES      ?=
FRONTEND_URL  ?= http://localhost:3000

.PHONY: help doctor install build build-frontend test lint typecheck alembic-upgrade \
        alembic-current alembic-check compose-up compose-down compose-logs smoke-test \
        seed docs-check verify clean

help: ## Список целей
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

doctor: ## Проверить инструменты, версии и сервисы (ничего не меняет)
	@./scripts/doctor.sh

install: ## Зависимости backend и frontend
	$(PYTHON) -m pip install -r backend/requirements.txt
	cd frontend && npm ci

## --- Проверки -------------------------------------------------------------

test: ## Тесты backend (SQLite, без внешней СУБД)
	$(PYTHON) -m pytest -q

lint: ## ruff
	$(PYTHON) -m ruff check backend tests scripts

typecheck: ## mypy
	$(PYTHON) -m mypy backend

lint-frontend: ## Сборка фронтенда (tsc + vite)
	cd frontend && npm ci && npm run build

build: build-frontend ## Артефакты: статика фронтенда
	@echo "backend собирается образом backend/Dockerfile"

build-frontend: ## Production-сборка React
	cd frontend && npm ci && npm run build

## --- База данных ----------------------------------------------------------

alembic-upgrade: ## Применить миграции: make alembic-upgrade DATABASE_URL=...
	cd backend && DATABASE_URL="$(DATABASE_URL)" $(PYTHON) -m alembic upgrade head

alembic-current: ## Текущая ревизия
	cd backend && DATABASE_URL="$(DATABASE_URL)" $(PYTHON) -m alembic current

alembic-check: ## Проверить, что модели и миграции согласованы
	$(PYTHON) -m pytest tests/test_schema_sync.py -q

seed: ## Демо-данные
	$(PYTHON) scripts/seed.py

## --- Интеграционная среда -------------------------------------------------

compose-up: ## Поднять стек (можно SERVICES="backend frontend")
	$(COMPOSE) up -d --build $(SERVICES)

compose-down: ## Остановить (данные сохраняются)
	$(COMPOSE) down

compose-logs: ## Логи
	$(COMPOSE) logs -f --tail=200

smoke-test: ## Проверить живой инстанс
	@./scripts/smoke-test.sh $(BACKEND_URL) $(FRONTEND_URL)

docs-check: ## Проверить документацию и спецификации модулей
	@./scripts/docs-check.sh

verify: lint typecheck test docs-check ## Локальная матрица
	@echo "verify: ok (compose- и БД-уровни проверяются в CI)"

clean: ## Удалить артефакты
	rm -rf frontend/dist test.db
	find . -name __pycache__ -type d -prune -exec rm -rf {} +
