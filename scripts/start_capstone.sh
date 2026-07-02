#!/usr/bin/env bash
# Khởi động toàn bộ capstone: 3 A2A specialists + ADK Web UI
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# shellcheck source=_lab_env.sh
source "$ROOT/scripts/_lab_env.sh"
setup_lab_env "$ROOT"

echo "══════════════════════════════════════════════════════════"
echo "  Day 26 Capstone — MCP + A2A Multi-Agent"
echo "══════════════════════════════════════════════════════════"
echo ""

bash "$ROOT/scripts/stop_a2a_servers.sh" 2>/dev/null || true
bash "$ROOT/scripts/start_a2a_servers.sh"

echo ""
echo "→ Khởi động ADK Web UI (orchestrator)..."
ADK_WEB_PORT="${ADK_WEB_PORT:-8000}"
echo "  URL: http://localhost:${ADK_WEB_PORT}"
echo "  A2A: :8001 search | :8002 database | :8003 synthesis"
echo ""
echo "  Dừng A2A: bash scripts/stop_a2a_servers.sh"
echo "══════════════════════════════════════════════════════════"
echo ""

has_port_arg=0
for arg in "$@"; do
  if [[ "$arg" == "--port" || "$arg" == --port=* ]]; then
    has_port_arg=1
    break
  fi
done

if [[ "$has_port_arg" -eq 1 ]]; then
  exec "$LAB_ADK" web agents/orchestrator "$@"
else
  exec "$LAB_ADK" web --port "$ADK_WEB_PORT" agents/orchestrator "$@"
fi
