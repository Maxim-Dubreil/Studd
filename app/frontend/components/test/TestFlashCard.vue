<template>
  <div class="space-y-4">
    <button @click="generate" class="bg-red-300 rounded-xl px-4 py-2">
      Générer les flashcards
    </button>

    <ul v-if="flashcards.length">
      <li v-for="(card, index) in flashcards" :key="index" class="border p-4 rounded-xl">
        <p class="font-bold">Q : {{ card.question }}</p>
        <p>A : {{ card.answer }}</p>
      </li>
    </ul>

    <div v-if="error" class="text-red-500">{{ error }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface Flashcard {
  question: string
  answer: string
}

const flashcards = ref<Flashcard[]>([])
const error = ref<string | null>(null)

const generate = async () => {

    const csrfToken = document.querySelector("[name='csrf-token']").content;
  try {
    const res = await fetch('/tools/flashcards', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ workspace_id: 123 })  // Si nécessaire

    });

    if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`);
    const data = await res.json();
    flashcards.value = data.flashcards;
  } catch (err) {
    error.value = err.message || 'Erreur inconnue';
  }
};
</script>
