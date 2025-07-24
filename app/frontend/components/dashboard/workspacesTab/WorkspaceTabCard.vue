<script setup lang="ts">
import { computed } from 'vue';
import { Icon } from '@/components/ui/icon'

interface Workspace {
  id: number;
  name: string;
  icon?: string;
  created_at: string;
  updated_at: string;
}

interface Props {
  workspace: Workspace;
}

const props = defineProps<Props>();

// Déterminer l'icône à afficher
const workspaceIcon = computed(() => {
  return props.workspace.icon || 'grid';
});

// Formater la date de création
const createdDate = computed(() => {
  const date = new Date(props.workspace.created_at);
  return date.toLocaleDateString('fr-FR');
});

// Naviguer vers le workspace
const openWorkspace = () => {
  window.location.href = `/workspaces/${props.workspace.id}`;
};

// Éditer le workspace
const editWorkspace = (event: Event) => {
  event.stopPropagation();
  window.location.href = `/workspaces/${props.workspace.id}/edit`;
};
</script>

<template>
  <div @click="openWorkspace"
    class="group bg-white/70 dark:bg-slate-700/70 backdrop-blur-sm rounded-xl p-6 border border-gray-200/50 dark:border-slate-600/50 hover:border-violet-300 dark:hover:border-violet-500/50 transition-all duration-300 cursor-pointer hover:shadow-lg dark:hover:shadow-xl hover:scale-[1.02] hover:bg-white/90 dark:hover:bg-slate-700/90">
    <!-- Header avec icône et menu -->
    <div class="flex items-start justify-between mb-4">
      <div class="flex items-center">
        <div
          class="w-12 h-12 bg-gradient-to-r from-violet-500 to-purple-600 dark:from-violet-600 dark:to-purple-700 rounded-xl flex items-center justify-center shadow-lg group-hover:shadow-xl transition-all duration-300">
          <Icon :name="workspaceIcon" class="w-6 h-6 text-white" />
        </div>
      </div>

      <!-- Menu d'actions -->
      <button @click="editWorkspace"
        class="opacity-0 group-hover:opacity-100 p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-slate-600 transition-all duration-200">
        <Icon name="settings"
          class="w-4 h-4 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-200" />
      </button>
    </div>

    <!-- Contenu principal -->
    <div class="space-y-3">
      <!-- Nom du workspace -->
      <h3
        class="text-lg font-semibold text-gray-800 dark:text-white group-hover:text-violet-600 dark:group-hover:text-violet-400 transition-colors duration-300 line-clamp-2">
        {{ props.workspace.name }}
      </h3>

      <!-- Métadonnées -->
      <div class="space-y-2">
        <div class="flex items-center text-sm text-gray-500 dark:text-gray-400">
          <Icon name="calendar" class="w-4 h-4 mr-2" />
          <span>Créé le {{ createdDate }}</span>
        </div>

        <!-- Indicateur d'activité -->
        <div class="flex items-center justify-between">
          <div class="flex items-center text-sm text-gray-500 dark:text-gray-400">
            <div class="w-2 h-2 bg-green-400 rounded-full mr-2 animate-pulse"></div>
            <span>Actif</span>
          </div>

          <!-- Badge -->
          <span
            class="px-2 py-1 text-xs font-medium bg-violet-100 dark:bg-violet-900/30 text-violet-700 dark:text-violet-300 rounded-full">
            Workspace
          </span>
        </div>
      </div>
    </div>

    <!-- Actions au hover -->
    <div
      class="mt-4 pt-4 border-t border-gray-100 dark:border-slate-600/50 opacity-0 group-hover:opacity-100 transition-all duration-300">
      <div class="flex items-center justify-between">
        <span class="text-sm text-gray-500 dark:text-gray-400">Cliquez pour ouvrir</span>
        <Icon name="arrow"
          class="w-4 h-4 text-violet-500 dark:text-violet-400 transform group-hover:translate-x-1 transition-transform duration-300" />
      </div>
    </div>
  </div>
</template>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
