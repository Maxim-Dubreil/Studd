<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="true">
    <BackButton :href="`/workspaces/${props.workspace_id}`" />
    <HomeButton :href="`/dashboard`" />
    <section class="mx-auto w-full max-w-screen-xl px-4 py-8 font-sans sm:px-8 sm:py-16 lg:py-8">
      <div class="mb-16 text-center">
        <h2
          class="mb-4 text-4xl font-extrabold tracking-tight text-gray-900 sm:text-5xl lg:text-6xl dark:text-white"
        >
          Your Study Sheets
        </h2>
        <p class="text-lg font-light text-gray-500 sm:text-xl dark:text-gray-400">
          Choose a study sheet or generate a new one.
        </p>
      </div>

      <!-- SCROLLER -------------------------------------------------------- -->
      <div
        class="scrollbar-thin scrollbar-track-transparent scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600 flex w-full snap-x snap-mandatory gap-8 overflow-x-auto scroll-smooth pb-4 lg:gap-16"
      >
        <!-- Message quand aucune fiche n'est disponible -->
        <div v-if="props.studySheetsSets.length === 0" class="w-full py-8 text-center">
          <p class="text-lg font-medium text-gray-500 dark:text-gray-400">
            No study sheets available, create a new one
          </p>
        </div>

        <!-- CARTE D'UNE FICHE ------------------------------------------------- -->
        <div
          v-else
          v-for="set in props.studySheetsSets"
          :key="set.id"
          style="cursor: pointer"
          class="group relative flex h-[384px] w-[320px] flex-none snap-start flex-col rounded-3xl border border-gray-200/50 bg-gray-50 p-8 transition-all duration-300 hover:border-violet-300 hover:bg-gray-100 hover:shadow-lg dark:border-slate-600/50 dark:bg-gray-800/50 dark:hover:border-violet-500/50 dark:hover:bg-gray-800"
        >
          <!-- Bouton de suppression -->
          <button
            @click.stop="confirmDelete(set.id)"
            class="absolute top-3 right-3 z-20 flex h-8 w-8 cursor-pointer items-center justify-center rounded-full bg-gray-200/80 opacity-0 transition-opacity duration-200 group-hover:opacity-100 hover:bg-red-100 dark:bg-gray-700/80 dark:hover:bg-red-900/80"
            title="Delete this study sheet"
          >
            <Trash2 class="h-4 w-4 text-gray-600 dark:text-gray-300" />
          </button>

          <!-- Zone cliquable pour redirection -->
          <div @click="handleRedirect(set.id, set.name)" class="flex h-full w-full flex-col">
            <!-- Icône de fiche ------------------------------------------>
            <div class="relative mb-8 flex flex-grow items-center justify-center">
              <div
                class="absolute h-48 w-56 -rotate-3 transform rounded-lg bg-gradient-to-br from-violet-200 to-indigo-200 shadow-md transition-all duration-400 ease-in-out group-hover:scale-105 group-hover:-rotate-6 dark:from-violet-700 dark:to-indigo-700"
              >
                <div class="p-4">
                  <div class="mb-2 h-2 w-3/4 rounded bg-violet-300/50"></div>
                  <div class="mb-2 h-2 w-full rounded bg-violet-300/30"></div>
                  <div class="mb-2 h-2 w-5/6 rounded bg-violet-300/30"></div>
                  <div class="mb-4 h-2 w-2/3 rounded bg-violet-300/30"></div>
                  
                  <div class="mb-1 h-2 w-1/2 rounded bg-indigo-300/50"></div>
                  <div class="mb-1 h-2 w-full rounded bg-indigo-300/30"></div>
                  <div class="mb-1 h-2 w-4/5 rounded bg-indigo-300/30"></div>
                </div>
              </div>
              <div
                class="absolute flex h-48 w-56 rotate-3 transform items-center justify-center rounded-lg bg-gradient-to-br from-indigo-300 to-purple-300 shadow-lg transition-all duration-400 ease-in-out group-hover:scale-105 group-hover:rotate-6 dark:from-indigo-600 dark:to-purple-600"
              >
                <Icon name="file-text" class="h-16 w-16 text-white/80" />
              </div>
            </div>

            <!-- Titre + résumé ------------------------------------------->
            <div class="mt-auto">
              <h3
                class="text-left text-xl font-medium text-gray-800 transition-colors duration-300 group-hover:text-violet-600 dark:text-gray-100 dark:group-hover:text-violet-400"
              >
                {{ set.name }}
              </h3>
              <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">
                {{ formatDate(set.created_at) }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <div class="mt-16 flex justify-center">
        <!-- Bouton pour ouvrir le modal -->
        <AlertDialog v-model:open="isDialogOpen">
          <AlertDialogTrigger as-child>
            <Button class="rounded-xl px-6 py-3 text-lg font-medium text-white">
              Create a new study sheet
            </Button>
          </AlertDialogTrigger>
          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>Create a new study sheet</AlertDialogTitle>
            </AlertDialogHeader>

            <div class="space-y-4 py-8">
              <div>
                <label for="set-name" class="mb-2 block text-sm font-medium text-gray-700">
                  Study sheet name
                </label>
                <input
                  id="set-name"
                  v-model="setName"
                  type="text"
                  class="w-full rounded-md border px-4 py-3 shadow-sm focus:border-violet-500 focus:ring-violet-500 focus:outline-none"
                  placeholder="Ex: French Revolution"
                />
              </div>
              <div v-if="error" class="rounded-md bg-red-50 p-3">
                <p class="text-sm text-red-800">{{ error }}</p>
              </div>
            </div>

            <AlertDialogFooter>
              <AlertDialogCancel class="cursor-pointer">Cancel</AlertDialogCancel>
              <Button
                @click="generate"
                :disabled="isLoading || !setName.trim()"
                :class="isLoading || !setName.trim() ? 'cursor-not-allowed bg-gray-400' : ''"
              >
                <span v-if="!isLoading">Generate study sheet</span>
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
                  Generating...
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
            Are you sure you want to delete this study sheet?
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel @click="isDeleteDialogOpen = false">Cancel</AlertDialogCancel>
          <Button variant="destructive" @click="deleteStudySheet" :disabled="isDeleteLoading">
            <span v-if="!isDeleteLoading">Delete</span>
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
              Deleting...
            </span>
          </Button>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  </AppLayout>
</template>

<script setup lang="ts">
  import {
    AlertDialog,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogTrigger,
  } from '@/components/ui/alert-dialog';
  import { Button } from '@/components/ui/button';
  import BackButton from '@/components/ui/button/BackButton.vue';
  import HomeButton from '@/components/ui/button/HomeButton.vue';
  import Icon from '@/components/ui/icon/Icon.vue';
  import { Trash2 } from 'lucide-vue-next';
  import { ref } from 'vue';
  import AppLayout from '../../../components/layout/AppLayout.vue';

  interface props {
    workspace_id: number;
    studySheetsSets: StudySheetsSet[];
  }

  const props = defineProps<props>();

  interface StudySheetsSet {
    id: number;
    workspace_id: number;
    name: string;
    content: any;
    created_at: string;
    updated_at: string;
  }

  /* ---------- State ---------- */
  const error = ref<string | null>(null);
  const isLoading = ref(false);
  const setName = ref('');
  const isDialogOpen = ref(false);
  const isDeleteDialogOpen = ref(false);
  const isDeleteLoading = ref(false);
  const studySheetToDelete = ref<number | null>(null);

  /* ---------- Helpers ---------- */
  function getCsrfToken(): string {
    const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]');
    if (!meta) throw new Error('Balise <meta name="csrf-token"> non trouvée');
    return meta.content;
  }

  function formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', {
      day: 'numeric',
      month: 'long',
      year: 'numeric'
    });
  }

  /* ---------- Actions ---------- */
  const generate = async (): Promise<void> => {
    if (!setName.value.trim()) return;

    error.value = null;
    isLoading.value = true;

    try {
      const res = await fetch(`/workspaces/${props.workspace_id}/study_sheets`, {
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

      isDialogOpen.value = false;
      window.location.reload();
    } catch (err: unknown) {
      error.value = err instanceof Error ? err.message : 'Erreur inconnue';
    } finally {
      isLoading.value = false;
    }
  };

  function handleRedirect(id: number, name: string) {
    window.location.href = `/workspaces/${props.workspace_id}/study_sheets/${id}`;
  }

  function confirmDelete(id: number) {
    studySheetToDelete.value = id;
    isDeleteDialogOpen.value = true;
  }

  async function deleteStudySheet() {
    if (!studySheetToDelete.value) return;

    isDeleteLoading.value = true;

    try {
      const res = await fetch(
        `/workspaces/${props.workspace_id}/study_sheets/${studySheetToDelete.value}`,
        {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-CSRF-Token': getCsrfToken(),
          },
        }
      );

      if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`);

      isDeleteDialogOpen.value = false;
      window.location.reload();
    } catch (err: unknown) {
      error.value = err instanceof Error ? err.message : 'Erreur inconnue';
    } finally {
      isDeleteLoading.value = false;
    }
  }
</script>
