<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="true">
    <div class="absolute top-8 left-8 z-10 flex items-center gap-4">
      <a :href="`/workspaces/${props.workspace_id}`"
        class="rounded-full bg-gray-800/50 p-2 text-white transition-colors hover:bg-gray-800/80">
        <ArrowLeft class="h-6 w-6" />
      </a>
    </div>

    <section class="mx-auto w-full max-w-screen-xl px-4 py-8 font-sans sm:px-8 sm:py-16 lg:py-8">
      <div class="mb-16 text-center">
        <h2 class="mb-4 text-4xl font-extrabold tracking-tight text-gray-900 sm:text-5xl lg:text-6xl dark:text-white">
          Your collections
        </h2>
        <p class="text-lg font-light text-gray-500 sm:text-xl dark:text-gray-400">
          Choose a collection of flashcards or generate a new one.
        </p>
      </div>

      <!-- SCROLLER -------------------------------------------------------- -->
      <div
        class="scrollbar-thin scrollbar-track-transparent scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600 flex w-full snap-x snap-mandatory gap-8 overflow-x-auto scroll-smooth pb-4 lg:gap-16">
        <!-- Message quand aucun set n'est disponible -->
        <div v-if="props.flashCardSets.length === 0" class="w-full py-8 text-center">
          <p class="text-lg font-medium text-gray-500 dark:text-gray-400">
            No collection to display, create a new one
          </p>
        </div>

        <!-- CARTE D'UN SET ------------------------------------------------- -->
        <div v-else v-for="set in props.flashCardSets" :key="set.id"
          class="group relative flex h-[384px] w-[320px] flex-none snap-start flex-col rounded-3xl bg-gray-50 p-8 transition-all duration-300 hover:border-violet-300 hover:bg-gray-100 hover:shadow-lg dark:bg-gray-800/50 dark:hover:border-violet-500/50 dark:hover:bg-gray-800 border border-gray-200/50 dark:border-slate-600/50">
          <!-- Bouton de suppression -->
          <button @click.stop="confirmDelete(set.id)"
            class="absolute top-3 right-3 z-20 flex h-8 w-8 items-center justify-center rounded-full bg-gray-200/80 opacity-0 transition-opacity duration-200 hover:bg-red-100 group-hover:opacity-100 dark:bg-gray-700/80 dark:hover:bg-red-900/80"
            title="Supprimer cette collection">
            <Trash2 class="h-4 w-4 text-gray-600 dark:text-gray-300" />
          </button>

          <!-- Zone cliquable pour redirection -->
          <div @click="handleRedirect(set.id)" class="flex h-full w-full flex-col">
            <!-- Mini‑cartes empilées ------------------------------------------>
            <div class="relative mb-8 flex flex-grow items-center justify-center">
              <!-- Carte arrière -->
              <div v-if="set.content?.[1]"
                class="absolute h-40 w-64 -rotate-6 transform rounded-lg shadow-md transition-all duration-400 ease-in-out group-hover:scale-105 group-hover:-rotate-12"
                :style="{ backgroundColor: set.content?.[1]?.color || '#a5b4fc' }"></div>

              <!-- Carte avant -->
              <div
                class="absolute flex h-40 w-64 rotate-3 transform items-center justify-center rounded-lg shadow-lg transition-all duration-400 ease-in-out group-hover:scale-105 group-hover:rotate-6"
                :style="{ backgroundColor: set.content?.[0]?.color || '#818cf8' }">
                <span class="truncate px-4 text-center font-medium text-gray-900">
                  {{ set.content?.[0]?.term || 'Nouveau set' }}
                </span>
              </div>
            </div>

            <!-- Titre + compteur ------------------------------------------->
            <div class="mt-auto">
              <h3
                class="text-left text-xl font-medium text-gray-800 dark:text-gray-100 transition-colors duration-300 group-hover:text-violet-600 dark:group-hover:text-violet-400">
                {{ set.name }}
              </h3>
              <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">
                {{ set.content?.length || 0 }}
                {{ (set.content?.length || 0) > 1 ? 'cartes' : 'carte' }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <div class="mt-16 flex justify-center">
        <!-- Bouton pour ouvrir le modal -->
        <AlertDialog v-model:open="isDialogOpen">
          <AlertDialogTrigger as-child>
            <Button class="rounded-xl px-6 py-3 text-white text-lg font-medium">
              Create a new collection
            </Button>
          </AlertDialogTrigger>
          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>Create a new collection</AlertDialogTitle>
            </AlertDialogHeader>

            <div class="space-y-4 py-8">
              <div>
                <label for="set-name" class="mb-2 block text-sm font-medium text-gray-700">
                  Name of the flashcard set
                </label>
                <input id="set-name" v-model="setName" type="text"
                  class="w-full rounded-md border px-4 py-3 shadow-sm focus:border-violet-500 focus:ring-violet-500 focus:outline-none"
                  placeholder="Ex: French Vocabulary" />
              </div>
            </div>

            <AlertDialogFooter>
              <AlertDialogCancel>Cancel</AlertDialogCancel>
              <Button @click="generate" :disabled="isLoading || !setName.trim()" :class="isLoading || !setName.trim()
                ? 'cursor-not-allowed bg-gray-400'
                : ''
                ">
                <span v-if="!isLoading">Generate flashcards</span>
                <span v-else class="flex items-center gap-2">
                  <svg class="h-4 w-4 animate-spin" viewBox="0 0 24 24" fill="none">
                    <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" stroke-linecap="round"
                      stroke-dasharray="60" stroke-dashoffset="20" />
                  </svg>
                  Loading…
                </span>
              </Button>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialog>
      </div>
    </section>

    <!-- Modal de confirmation de suppression -->
    <AlertDialog v-model:open="isDeleteDialogOpen">
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>Confirm deletion</AlertDialogTitle>
          <AlertDialogDescription>
            Are you sure you want to delete this flashcard collection?
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel @click="isDeleteDialogOpen = false">Cancel</AlertDialogCancel>
          <Button variant="destructive" @click="deleteFlashCardSet" :disabled="isDeleteLoading">
            <span v-if="!isDeleteLoading">Delete</span>
            <span v-else class="flex items-center gap-2">
              <svg class="h-4 w-4 animate-spin" viewBox="0 0 24 24" fill="none">
                <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" stroke-linecap="round"
                  stroke-dasharray="60" stroke-dashoffset="20" />
              </svg>
              Deleting...
            </span>
          </Button>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  </AppLayout>
</template>

<script setup lang="ts">
import { ArrowLeft, Trash2 } from 'lucide-vue-next';
import { ref } from 'vue';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog';
import { Button } from '@/components/ui/button';
import AppLayout from '../../../components/layout/AppLayout.vue';

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
const setName = ref('');
const isDialogOpen = ref(false);
const isDeleteDialogOpen = ref(false);
const isDeleteLoading = ref(false);
const flashCardSetToDelete = ref<number | null>(null);

/* ---------- Helpers ---------- */
function getCsrfToken(): string {
  const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]');
  if (!meta) throw new Error('Balance <meta name="csrf-token"> not found');
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

    // Fermer le modal et rafraîchir la page pour afficher la nouvelle collection
    isDialogOpen.value = false;
    window.location.reload();
  } catch (err: unknown) {
    error.value = err instanceof Error ? err.message : 'Erreur inconnue';
  } finally {
    isLoading.value = false;
  }
};

function handleRedirect(id: number) {
  window.location.href = `/workspaces/${props.workspace_id}/flashcards/${id}`;
}

function confirmDelete(id: number) {
  flashCardSetToDelete.value = id;
  isDeleteDialogOpen.value = true;
}

async function deleteFlashCardSet() {
  if (!flashCardSetToDelete.value) return;

  isDeleteLoading.value = true;

  try {
    const res = await fetch(`/workspaces/${props.workspace_id}/flashcards/${flashCardSetToDelete.value}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      },
    });

    if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`);

    // Fermer le modal et rafraîchir la page
    isDeleteDialogOpen.value = false;
    window.location.reload();
  } catch (err: unknown) {
    error.value = err instanceof Error ? err.message : 'Erreur inconnue';
  } finally {
    isDeleteLoading.value = false;
  }
}
</script>
