# Repository Guidelines

## Project Structure & Module Organization
This repository is a lightweight installer for a Vue starter project.
- `create-vue-starter.sh` is the entry-point script that scaffolds a Vite + Vue + TS app and pulls shared configs from GitHub.
- `README.md` documents the curl-based install command and options.
There is no app source tree in this repo; generated projects contain their own `src/`, `public/`, and config files.

## Build, Test, and Development Commands
There is no build step in this repo. Use the script directly:
- `./create-vue-starter.sh my-app` scaffolds and configures a new project.
- `./create-vue-starter.sh my-app --repo https://github.com/org/repo --branch main` targets a different config source.
The script always runs `pnpm install` after scaffolding.

## Coding Style & Naming Conventions
- Shell scripts use 2-space indentation and `set -euo pipefail`.
- Prefer clear, small functions (e.g., `download_required`) and explicit error messages.
- Use `kebab-case` for script names and `UPPER_CASE` for constants.
- Keep output concise; add a `--verbose` flag only if needed.

## Testing Guidelines
No automated tests are defined. Validate changes manually:
- Run the script in a temp directory and confirm it creates the app.
- Verify config files are downloaded and `pnpm install` completes.
If tests are added later, document commands and naming (e.g., `tests/*.bats`) here.

## Commit & Pull Request Guidelines
- Use Conventional Commits (e.g., `feat: add --branch option`, `fix: handle missing curl`).
- PRs should include: summary, example command used, and any expected output changes.
- For behavior changes, include a short verification note (e.g., “ran installer, app boots”).

## Security & Configuration Tips
- Avoid downloading `.env` files or secrets from remote sources.
- Only pull config/tooling files, not application code, unless explicitly requested.
