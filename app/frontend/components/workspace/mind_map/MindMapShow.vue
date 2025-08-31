<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="false">
    <BackButton :href="`/workspaces/${props.workspace_id}`" />
    <HomeButton :href="`/dashboard`" />
    <!-- Affichage de la mindmap si elle existe -->
    <div
      v-if="!isLoading && content"
      class="relative flex min-h-screen items-center justify-center"
    >
      <div id="map" class="h-[600px] w-300 rounded-xl"></div>
      <div class="absolute top-25 right-90 flex gap-2">
        <Button @click="saveMindmap" variant="default" :disabled="isSaving">
          <Icon name="save" class="h-4 w-4" />
          <span v-if="!isSaving">Save</span>
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
            Saving...
          </span>
        </Button>
        <Button @click="deleteMindmap" variant="destructive">
          <Icon name="trash" class="h-4 w-4" />
          Delete
        </Button>
      </div>
    </div>

    <!-- Affichage du loader pendant la génération -->
    <div v-else class="flex h-[600px] flex-col items-center justify-center">
      <p class="mb-4 text-lg">
        {{ isLoading ? 'Generating mindmap...' : 'No mindmap available' }}
      </p>
      <Button
        @click="generate"
        :disabled="isLoading"
        class="rounded-xl px-4 py-2 text-white"
        :class="isLoading ? 'cursor-not-allowed bg-gray-400' : 'bg-red-500 hover:bg-red-600'"
      >
        <span v-if="!isLoading">Generate mindmap</span>
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
          Loading...
        </span>
      </Button>
    </div>
    <Sonner
      class="toaster group"
      :duration="5000"
      :style="{
        '--normal-bg': 'var(--popover)',
        '--normal-text': 'var(--popover-foreground)',
        '--normal-border': 'var(--border)',
      }"
    />
  </AppLayout>
</template>

<script setup lang="ts">
  import { Button } from '@/components/ui/button';
  import BackButton from '@/components/ui/button/BackButton.vue';
  import HomeButton from '@/components/ui/button/HomeButton.vue';
  import Icon from '@/components/ui/icon/Icon.vue';
  import type { MindElixirData } from 'mind-elixir';
  import MindElixir from 'mind-elixir';
  import 'mind-elixir/style.css';
  import { onMounted, ref } from 'vue';
  import AppLayout from '../../../components/layout/AppLayout.vue';

  interface props {
    workspace_id: number;
    content?: MindElixirData;
  }
  const props = defineProps<props>();

  /* ---------- State ---------- */
  const isLoading = ref(false);
  const isSaving = ref(false);
  const mindInstance = ref<any>(null);

  /* ---------- Helpers ---------- */
  function getCsrfToken(): string {
    const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]');
    if (!meta) throw new Error('Balise <meta name="csrf-token"> introuvable');
    return meta.content;
  }

  /* ---------- Actions ---------- */
  const generate = async (): Promise<void> => {
    isLoading.value = true;
    try {
      const res = await fetch(`/workspaces/${props.workspace_id}/mindmaps`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'X-CSRF-Token': getCsrfToken(),
        },
      });
      if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`);
      window.location.href = `/workspaces/${props.workspace_id}/mindmaps`;
    } catch (err: unknown) {
      console.error(err instanceof Error ? err.message : 'Erreur inconnue');
    } finally {
      isLoading.value = false;
    }
  };

  const saveMindmap = async (): Promise<void> => {
    if (!mindInstance.value) return;

    isSaving.value = true;
    try {
      const updatedData = mindInstance.value.getData();

      const res = await fetch(`/workspaces/${props.workspace_id}/mindmaps`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'X-CSRF-Token': getCsrfToken(),
        },
        body: JSON.stringify({ content: updatedData }),
      });

      if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`);

      // Afficher une notification de succès (optionnel)
      // TO DO : afficher un pop up
    } catch (err: unknown) {
      console.error(err instanceof Error ? err.message : 'Erreur inconnue');

      // TO DO : afficher un pop up
    } finally {
      isSaving.value = false;
    }
  };

  const deleteMindmap = async (): Promise<void> => {
    if (!confirm('Are you sure you want to delete this mindmap?')) return;
    isLoading.value = true;
    try {
      const res = await fetch(`/workspaces/${props.workspace_id}/mindmaps`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'X-CSRF-Token': getCsrfToken(),
        },
      });
      if (!res.ok) throw new Error(`Error HTTP ${res.status}`);
      // Redirection vers la page du workspace après suppression
      window.location.href = `/workspaces/${props.workspace_id}/mindmaps`;
    } catch (err: unknown) {
      console.error(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      isLoading.value = false;
    }
  };

  onMounted(() => {
    if (props.content) {
      // 1) Options : ici on cible l'élément via son sélecteur CSS
      const options = { el: '#map' };
      // 2) Création de l'instance
      const mind = new MindElixir(options);
      // 3) Données par défaut (un seul nœud "new topic")
      const data: MindElixirData = props.content;
      // 4) Initialisation du mindmap
      mind.init(data);
      // 5) Stocker l'instance pour pouvoir y accéder plus tard
      mindInstance.value = mind;
    }
  });
</script>
