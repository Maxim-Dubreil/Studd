<script setup lang="ts">
import { ref } from 'vue'

/* ---------- Types ---------- */
interface Flashcard {
  question: string
  answer: string
}

interface FlashcardsResponse {
  flashcards: Flashcard[]
}

/* ---------- State ---------- */
const flashcards = ref<Flashcard[]>([])
const error      = ref<string | null>(null)

/* ---------- Helpers ---------- */
/** Récupère le CSRF token (ou lève une erreur explicite). */
function getCsrfToken (): string {
  const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]')
  if (!meta) throw new Error('Balise <meta name="csrf-token"> introuvable')
  return meta.content
}

/* ---------- Actions ---------- */
const generate = async (): Promise<void> => {
  error.value = null

  try {
    const res = await fetch('/tools/flashcards', {
      method: 'POST',
      headers: {
        'Content-Type' : 'application/json',
        'Accept'       : 'application/json',
        'X-CSRF-Token' : getCsrfToken(),
      },
      body: JSON.stringify({ workspace_id: 123 }), // => adapte si nécessaire
    })

    if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`)

    // Cast typé : TS sait que data.flashcards est bien Flashcard[]
    const data = (await res.json()) as FlashcardsResponse
    flashcards.value = data.flashcards
  } catch (err: unknown) {
    error.value = err instanceof Error ? err.message : 'Erreur inconnue'
  }
}
</script>
