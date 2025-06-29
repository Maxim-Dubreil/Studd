import path from 'node:path'
import { fileURLToPath } from 'node:url'

import { defineConfig } from 'vite'
import RubyPlugin   from 'vite-plugin-ruby'
import vue          from '@vitejs/plugin-vue'
import tailwindcss  from '@tailwindcss/vite'

// __dirname n’existe pas en ESM → on le reconstitue :
const __dirname = path.dirname(fileURLToPath(import.meta.url))

export default defineConfig({
  plugins: [RubyPlugin(), vue(), tailwindcss()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'app/frontend'),
    },
  },
})
