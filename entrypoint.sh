#!/bin/bash

set -euo pipefail

if [ -f pyproject.toml ]; then
  uv sync
  source .venv/bin/activate
fi

exec "$@"
