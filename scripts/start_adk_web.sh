#!/usr/bin/env bash
# Khởi động ADK Web UI cho orchestrator
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# shellcheck source=_lab_env.sh
source "$ROOT/scripts/_lab_env.sh"
setup_lab_env "$ROOT"

AGENT_DIR="agents/orchestrator"
if [[ ! -f "$AGENT_DIR/agent.py" ]]; then
  echo "✗ Không tìm thấy $AGENT_DIR/agent.py"
  exit 1
fi

ADK_WEB_PORT="${ADK_WEB_PORT:-8000}"
echo "→ ADK Web UI: http://localhost:${ADK_WEB_PORT}"
echo "  Agent: $AGENT_DIR"
echo "  (Cần A2A servers :8001, :8002 và :8003 đang chạy)"

has_port_arg=0
for arg in "$@"; do
  if [[ "$arg" == "--port" || "$arg" == --port=* ]]; then
    has_port_arg=1
    break
  fi
done

if [[ "$has_port_arg" -eq 1 ]]; then
  exec "$LAB_ADK" web "$AGENT_DIR" "$@"
else
  exec "$LAB_ADK" web --port "$ADK_WEB_PORT" "$AGENT_DIR" "$@"
fi
