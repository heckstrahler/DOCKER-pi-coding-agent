#!/bin/bash

set -euo pipefail

# Inject ext provider credentials from environment variables into models.json
# (llama-cpp is left untouched).
# Usage: docker run -e EXT_BASE_URL=... -e EXT_API_KEY=... ...
MODELS_JSON="/home/piuser/.pi/agent/models.json"
if [ -f "$MODELS_JSON" ] && { [ -n "${EXT_BASE_URL:-}" ] || [ -n "${EXT_API_KEY:-}" ]; }; then
  node -e '
    const fs = require("fs");
    const p = process.argv[1];
    const m = JSON.parse(fs.readFileSync(p, "utf8"));
    const ext = m.providers && m.providers.ext;
    if (ext) {
      if (process.env.EXT_BASE_URL) ext.baseUrl = process.env.EXT_BASE_URL;
      if (process.env.EXT_API_KEY) ext.apiKey = process.env.EXT_API_KEY;
    }
    fs.writeFileSync(p, JSON.stringify(m, null, 2) + "\n");
  ' "$MODELS_JSON"
fi

if [ -f pyproject.toml ]; then
  uv sync
  source .venv/bin/activate
fi

exec "$@"
