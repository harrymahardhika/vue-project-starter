/// <reference types="vite/client" />
interface ImportMetaEnv {
  readonly VITE_APP_NAME: string
  readonly VITE_APP_ENV: string
  readonly VITE_APP_URL: string
  readonly VITE_API_BASE_URL: string
  readonly VITE_REVERB_APP_KEY: string
  readonly VITE_REVERB_HOST: string
  readonly VITE_REVERB_PORT: number
  readonly VITE_REVERB_SCHEME: string
  readonly VITE_SENTRY_DSN_PUBLIC: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
