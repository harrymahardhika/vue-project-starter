#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./create-vue-starter.sh <target-dir> [--repo <url>] [--branch <name>]

Scaffolds a Vite + Vue + TS app, then pulls ESLint/Prettier/TS/Vite configs
from a GitHub repo and installs dependencies.

Options:
  --repo <url>     GitHub repo URL (default: https://github.com/harrymahardhika/vue-project-starter)
  --branch <name>  Branch or tag to pull from (default: main)
  -h, --help       Show this help
USAGE
}

REPO_URL_DEFAULT="https://github.com/harrymahardhika/vue-project-starter"
REPO_URL="${REPO_URL_DEFAULT}"
BRANCH="main"
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO_URL="${2:-}"
      shift 2
      ;;
    --branch)
      BRANCH="${2:-}"
      shift 2
      ;;
    --install)
      echo "--install is no longer needed; pnpm install runs automatically." >&2
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -z "${TARGET}" ]]; then
        TARGET="$1"
        shift
      else
        echo "Unknown argument: $1" >&2
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ -z "${TARGET}" ]]; then
  usage
  exit 1
fi

if [[ -e "${TARGET}" ]] && [[ -n "$(ls -A "${TARGET}" 2>/dev/null)" ]]; then
  echo "Target directory exists and is not empty: ${TARGET}" >&2
  exit 1
fi

if ! command -v pnpm >/dev/null 2>&1; then
  echo "pnpm is required but not found in PATH." >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required but not found in PATH." >&2
  exit 1
fi

if [[ "${REPO_URL}" =~ ^git@github\.com:([^/]+)/([^/]+)\.git$ ]]; then
  REPO_PATH="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
elif [[ "${REPO_URL}" =~ ^https://github\.com/([^/]+)/([^/]+) ]]; then
  REPO_PATH="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
  REPO_PATH="${REPO_PATH%.git}"
else
  echo "Unsupported repo URL: ${REPO_URL}" >&2
  exit 1
fi

RAW_BASE="https://raw.githubusercontent.com/${REPO_PATH}/${BRANCH}"

mkdir -p "${TARGET}"

pnpm create vite@latest "${TARGET}" -- --template vue-ts

download_required() {
  local rel="$1"
  local dest="${TARGET}/${rel}"
  local code
  mkdir -p "$(dirname "${dest}")"
  echo "Fetching ${rel}..."
  code="$(curl -s -o "${dest}" -w "%{http_code}" "${RAW_BASE}/${rel}" 2>/dev/null || true)"
  if [[ "${code}" != "200" ]]; then
    echo "Required file missing from template: ${rel}" >&2
    echo "URL: ${RAW_BASE}/${rel}" >&2
    rm -f "${dest}"
    exit 1
  fi
}

download_optional() {
  local rel="$1"
  local dest="${TARGET}/${rel}"
  local code
  mkdir -p "$(dirname "${dest}")"
  echo "Fetching ${rel}..."
  code="$(curl -s -o "${dest}" -w "%{http_code}" "${RAW_BASE}/${rel}" 2>/dev/null || true)"
  if [[ "${code}" != "200" ]]; then
    echo "Optional file not found: ${rel}" >&2
    rm -f "${dest}"
  fi
}

download_required "eslint.config.ts"
download_required ".prettierrc.json"
download_required "vite.config.ts"
download_required "tsconfig.json"
download_required "tsconfig.app.json"
download_required "tsconfig.node.json"
download_required "tsconfig.vitest.json"
download_required "env.d.ts"
download_optional "src/type.d.ts"

echo "Installing dependencies..."
(cd "${TARGET}" && pnpm add vue@^3.5.13)

echo "Installing dev dependencies..."
(cd "${TARGET}" && pnpm add -D \
  @eslint/js@^9.17.0 \
  @tsconfig/node22@^22.0.0 \
  @types/node@^22.10.2 \
  @vitejs/plugin-vue@^5.2.1 \
  @vue/test-utils@^2.4.6 \
  @vue/tsconfig@^0.7.0 \
  eslint@^9.17.0 \
  eslint-plugin-vue@^9.31.0 \
  globals@^15.14.0 \
  jsdom@^25.0.1 \
  prettier@^3.4.2 \
  typescript@~5.6.3 \
  typescript-eslint@^8.18.1 \
  vite@^6.0.3 \
  vitest@^2.1.8 \
  vue-tsc@^2.1.10)

echo ""
echo "✓ Created Vue starter at: ${TARGET}"
echo ""
echo "Next steps:"
echo "  cd ${TARGET}"
echo "  pnpm dev"
