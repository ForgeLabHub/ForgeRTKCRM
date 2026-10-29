#!/usr/bin/env bash
# Проверка живого инстанса: backend, готовность БД, фронтенд, Swagger.
#   ./scripts/smoke-test.sh [backend-url] [frontend-url]
set -uo pipefail
backend="${1:-http://localhost:8000}"
frontend="${2:-http://localhost:3000}"
failures=0
ok()  { printf '  \033[32mok\033[0m    %s\n' "$1"; }
bad() { printf '  \033[31mfail\033[0m  %s\n' "$1"; failures=$((failures+1)); }
code() { curl -s -o /dev/null -w '%{http_code}' -m 10 "$@"; }

printf '\nBackend: %s\n' "$backend"
c="$(code "$backend/healthz")"; [ "$c" = "200" ] && ok "GET /healthz -> 200" || bad "GET /healthz -> $c"
c="$(code "$backend/readyz")";  [ "$c" = "200" ] && ok "GET /readyz -> 200 (база доступна)" || bad "GET /readyz -> $c"
c="$(code "$backend/docs")";    [ "$c" = "200" ] && ok "GET /docs -> 200" || bad "GET /docs -> $c"
c="$(code "$backend/openapi.json")"
case "$c" in 200) ok "GET /openapi.json -> 200";; *) bad "GET /openapi.json -> $c";; esac
c="$(code "$backend/api/interactions")"
case "$c" in 200|401|403) ok "GET /api/interactions -> $c (доступ контролируется)";; *) bad "GET /api/interactions -> $c";; esac

printf '\nFrontend: %s\n' "$frontend"
c="$(code "$frontend/")"; [ "$c" = "200" ] && ok "GET / -> 200" || bad "GET / -> $c"

printf '\n'
[ "$failures" -gt 0 ] && { printf '\033[31mпровалено: %d\033[0m\n' "$failures"; exit 1; }
printf '\033[32mSmoke test пройден\033[0m\n'
