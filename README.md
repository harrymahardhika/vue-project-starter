# Vue Project Starter Installer

This repository provides a bash script to scaffold a Vite + Vue + TypeScript app
and pull shared ESLint/Prettier/TypeScript/Vite config from GitHub.

## Quick Install
Run the installer directly with `curl | bash`:

```bash
curl -fsSL https://raw.githubusercontent.com/harrymahardhika/vue-project-starter/main/create-vue-starter.sh | bash -s -- my-app
```

Script source (GitHub UI):
`https://github.com/harrymahardhika/vue-project-starter/blob/main/create-vue-starter.sh`

## Options
- `--repo <url>`: change the config source repo.
- `--branch <name>`: change the branch or tag.

Example:

```bash
curl -fsSL https://raw.githubusercontent.com/harrymahardhika/vue-project-starter/main/create-vue-starter.sh | bash -s -- my-app --repo https://github.com/your-org/your-repo --branch main
```

## Requirements
- `bash`
- `pnpm`
- `curl`
