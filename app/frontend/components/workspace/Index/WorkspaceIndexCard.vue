<script setup lang="ts">
  import { Icon } from '@/components/ui/icon';
  import { computed } from 'vue';

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
  <div
    @click="openWorkspace"
    class="group cursor-pointer rounded-xl border border-gray-200/50 bg-white/70 p-6 backdrop-blur-sm transition-all duration-300 hover:scale-[1.02] hover:border-violet-300 hover:bg-white/90 hover:shadow-lg dark:border-slate-600/50 dark:bg-slate-700/70 dark:hover:border-violet-500/50 dark:hover:bg-slate-700/90 dark:hover:shadow-xl"
  >
    <!-- Header avec icône et menu -->
    <div class="mb-4 flex items-start justify-between">
      <div class="flex items-center">
        <div
          class="flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-r from-violet-500 to-purple-600 shadow-lg transition-all duration-300 group-hover:shadow-xl dark:from-violet-600 dark:to-purple-700"
        >
          <Icon :name="workspaceIcon" class="h-6 w-6 text-white" />
        </div>
      </div>

      <!-- Menu d'actions -->
      <button
        @click="editWorkspace"
        class="rounded-lg p-2 opacity-0 transition-all duration-200 group-hover:opacity-100 hover:bg-gray-100 dark:hover:bg-slate-600"
      >
        <Icon
          name="settings"
          class="h-4 w-4 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
        />
      </button>
    </div>

    <!-- Contenu principal -->
    <div class="space-y-3">
      <!-- Nom du workspace -->
      <h3
        class="line-clamp-2 text-lg font-semibold text-gray-800 transition-colors duration-300 group-hover:text-violet-600 dark:text-white dark:group-hover:text-violet-400"
      >
        {{ props.workspace.name }}
      </h3>

      <!-- Métadonnées -->
      <div class="space-y-2">
        <div class="flex items-center text-sm text-gray-500 dark:text-gray-400">
          <Icon name="calendar" class="mr-2 h-4 w-4" />
          <span>Créé le {{ createdDate }}</span>
        </div>

        <!-- Indicateur d'activité -->
        <div class="flex items-center justify-between">
          <div class="flex items-center text-sm text-gray-500 dark:text-gray-400">
            <div class="mr-2 h-2 w-2 animate-pulse rounded-full bg-green-400"></div>
            <span>Actif</span>
          </div>

          <!-- Badge -->
          <span
            class="rounded-full bg-violet-100 px-2 py-1 text-xs font-medium text-violet-700 dark:bg-violet-900/30 dark:text-violet-300"
          >
            Workspace
          </span>
        </div>
      </div>
    </div>

    <!-- Actions au hover -->
    <div
      class="mt-4 border-t border-gray-100 pt-4 opacity-0 transition-all duration-300 group-hover:opacity-100 dark:border-slate-600/50"
    >
      <div class="flex items-center justify-between">
        <span class="text-sm text-gray-500 dark:text-gray-400">Cliquez pour ouvrir</span>
        <Icon
          name="arrow"
          class="h-4 w-4 transform text-violet-500 transition-transform duration-300 group-hover:translate-x-1 dark:text-violet-400"
        />
      </div>
    </div>
  </div>
</template>
