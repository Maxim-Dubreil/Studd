<template>
  <div class="absolute top-8 left-8 z-10 flex items-center gap-4">
    <a
      :href="`/workspaces/${props.workspace_id}`"
      class="rounded-full bg-gray-800/50 p-2 text-white transition-colors hover:bg-gray-800/80"
    >
      <ArrowLeft class="h-6 w-6" />
    </a>
  </div>
  <!-- Section stretches to the full viewport width and inherits the page gradient -->
  <section
    class="<!-- ⬅️ plus large que 7xl --> mx-auto w-full max-w-screen-xl px-4 py-10 font-sans sm:px-8 sm:py-20 lg:py-5"
  >
    <div class="mb-12 text-center sm:mb-16">
      <h2
        class="mb-3 text-4xl font-extrabold tracking-tight text-gray-900 sm:mb-4 sm:text-5xl lg:text-6xl dark:text-white"
      >
        Vos collections
      </h2>
      <p class="text-lg font-light text-gray-500 sm:text-xl dark:text-gray-400">
        Choissisez une collection de flashcards ou générer en une nouvelle.
      </p>
    </div>

    <!-- SCROLLER -------------------------------------------------------- -->
    <div
      class="<!-- espaces entre cartes --> <!-- espace pour la barre --> scrollbar-thin scrollbar-track-transparent scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600 flex w-full snap-x snap-mandatory gap-10 overflow-x-auto scroll-smooth pb-2 lg:gap-12"
    >
      <!-- Message quand aucun set n'est disponible -->
      <div v-if="props.flashCardSets.length === 0" class="w-full py-8 text-center">
        <p class="text-lg font-medium text-gray-500 dark:text-gray-400">
          Aucune collection à afficher, créez en une nouvelle
        </p>
      </div>

      <!-- CARTE D'UN SET ------------------------------------------------- -->
      <div
        v-else
        v-for="set in props.flashCardSets"
        :key="set.id"
        @click="handleRedirect(set.id)"
        class="<!-- NE PAS se rétrécir --> <!-- carte + large / + haute --> group <!-- ancrage au scroll --> flex h-[380px] w-[17rem] flex-none snap-start flex-col rounded-3xl bg-gray-50 p-6 transition-all duration-300 hover:bg-gray-100 dark:bg-gray-800/50 dark:hover:bg-gray-800"
      >
        <!-- Mini‑cartes empilées ------------------------------------------>
        <div class="relative mb-4 flex flex-grow items-center justify-center">
          <!-- Carte arrière -->
          <div
            v-if="set.content?.[1]"
            class="absolute h-36 w-56 -rotate-6 transform rounded-lg shadow-md transition-all duration-400 ease-in-out group-hover:scale-105 group-hover:-rotate-12"
            :style="{ backgroundColor: set.content?.[1]?.color || '#a5b4fc' }"
          ></div>

          <!-- Carte avant -->
          <div
            class="absolute flex h-36 w-56 rotate-3 transform items-center justify-center rounded-lg shadow-lg transition-all duration-400 ease-in-out group-hover:scale-105 group-hover:rotate-6"
            :style="{ backgroundColor: set.content?.[0]?.color || '#818cf8' }"
          >
            <span class="truncate px-4 text-center font-medium text-gray-900">
              {{ set.content?.[0]?.term || 'Nouveau set' }}
            </span>
          </div>
        </div>

        <!-- Titre + compteur --------------------------------------------->
        <div class="mt-auto">
          <h3 class="text-left text-lg font-medium text-gray-800 dark:text-gray-100">
            {{ set.name }}
          </h3>
          <p class="text-sm text-gray-500 dark:text-gray-400">
            {{ set.content?.length || 0 }}
            {{ (set.content?.length || 0) > 1 ? 'cartes' : 'carte' }}
          </p>
        </div>
      </div>
    </div>

    <div class="mt-8 flex justify-center">
      <!-- Bouton pour ouvrir le modal -->
      <AlertDialog>
        <AlertDialogTrigger as-child>
          <button
            class="rounded-xl bg-red-500 px-4 py-2 text-white hover:bg-red-600"
          >
            Créer une nouvelle collection
          </button>
        </AlertDialogTrigger>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Créer une nouvelle collection</AlertDialogTitle>
          </AlertDialogHeader>

          <div class="space-y-4 py-4">
            <div>
              <label for="set-name" class="mb-1 block text-sm font-medium text-gray-700">
                Nom du set de flashcards
              </label>
              <input
                id="set-name"
                v-model="setName"
                type="text"
                class="w-full rounded-md border px-3 py-2 shadow-sm focus:border-red-500 focus:ring-red-500 focus:outline-none"
                placeholder="Ex: Vocabulaire français"
              />
            </div>
          </div>

          <AlertDialogFooter>
            <AlertDialogCancel>Annuler</AlertDialogCancel>
            <AlertDialogAction
              @click="generate"
              :disabled="isLoading || !setName.trim()"
              :class="
                isLoading || !setName.trim()
                  ? 'cursor-not-allowed bg-gray-400'
                  : ''
              "
            >
              <span v-if="!isLoading">Générer les flashcards</span>
              <span v-else class="flex items-center gap-2">
                <svg class="h-4 w-4 animate-spin" viewBox="0 0 24 24" fill="none">
                  <circle
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    stroke-width="4"
                    stroke-linecap="round"
                    stroke-dasharray="60"
                    stroke-dashoffset="20"
                  />
                </svg>
                Chargement…
              </span>
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  </section>
</template>

<script setup lang="ts">
  import { ArrowLeft } from 'lucide-vue-next';
  import { ref } from 'vue';
  import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogTrigger,
  } from '@/components/ui/alert-dialog';

  interface props {
    workspace_id: number;
    flashCardSets: FlashCardSet[];
  }

  const props = defineProps<props>();

  interface FlashCardSet {
    id: number;
    workspace_id: number;
    name: string;
    content: Flashcard[];
  }

  interface Flashcard {
    id: number;
    term: string;
    definition: string;
    color: string;
  }

  interface FlashcardsResponse {
    flashcards: Flashcard[];
  }

  /* ---------- State ---------- */
  const flashcards = ref<Flashcard[]>([]);
  const error = ref<string | null>(null);
  const isLoading = ref(false);
  const setName = ref(''); // Nouvel état pour le nom du set

  /* ---------- Helpers ---------- */
  function getCsrfToken(): string {
    const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]');
    if (!meta) throw new Error('Balise <meta name="csrf-token"> introuvable');
    return meta.content;
  }

  /* ---------- Actions ---------- */
  const generate = async (): Promise<void> => {
    if (!setName.value.trim()) return;

    error.value = null;
    isLoading.value = true;

    try {
      const res = await fetch(`/workspaces/${props.workspace_id}/flashcards`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'X-CSRF-Token': getCsrfToken(),
        },
        body: JSON.stringify({
          name: setName.value.trim(),
          workspace_id: props.workspace_id,
        }),
      });

      if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`);

      const data = (await res.json()) as FlashcardsResponse;
      flashcards.value = data.flashcards;
    } catch (err: unknown) {
      error.value = err instanceof Error ? err.message : 'Erreur inconnue';
    } finally {
      isLoading.value = false;
    }
  };

  function handleRedirect(id: number) {
    window.location.href = `/workspaces/${props.workspace_id}/flashcards/${id}`;
  }
</script>
