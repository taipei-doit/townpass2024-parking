/// <reference types="vite/client" />
interface ImportMetaEnv {
    readonly VITE_MAPBOX_API_KEY: string
    readonly VITE_BACKEND_URL: string
}

interface ImportMeta {
    readonly env: ImportMetaEnv
}