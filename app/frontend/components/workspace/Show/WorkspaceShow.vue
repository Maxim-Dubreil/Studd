<template>
  <AppLayout :hide-sidebar="true" :hide-top-nav="true" :hide-toggle="false" :hide-gradient="false">
    <div class="fixed inset-0 overflow-hidden pointer-events-none">
      <div class="absolute inset-0 bg-gradient-to-br from-violet-50/30 via-indigo-50/20 to-purple-50/30"></div>
      <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-violet-200/20 rounded-full blur-3xl transform -translate-x-1/2 -translate-y-1/2"></div>
      <div class="absolute bottom-1/4 right-1/4 w-80 h-80 bg-indigo-200/20 rounded-full blur-3xl transform translate-x-1/2 translate-y-1/2"></div>
      <div class="absolute top-3/4 left-3/4 w-64 h-64 bg-purple-200/15 rounded-full blur-2xl transform -translate-x-1/2 -translate-y-1/2"></div>
    </div>
    
    <section class="relative z-10 px-10 pb-24">
      <div class="relative mb-8 text-center p-4">
        <a href="/workspaces"
          class="bg-white/80 hover:bg-white/90 absolute top-1/2 left-0 -translate-y-1/2 rounded-xl border border-violet-200/50 p-3 backdrop-blur-sm shadow-lg transition-all hover:shadow-xl hover:scale-105">
          <Icon name="arrow-left" class="h-5 w-5 text-violet-600" />
        </a>
        <div class="flex items-center justify-center">
          <div class="relative">
            <div class="absolute inset-0 bg-gradient-to-r from-violet-400 to-indigo-400 rounded-xl blur opacity-75"></div>
            <img v-if="props.workspace.icon" :src="getIconUrl(props.workspace.icon.path)" :alt="props.workspace.icon.name"
              class="relative h-14 w-14 rounded-xl border-2 border-white shadow-lg" />
            <div v-else class="relative h-14 w-14 rounded-xl bg-gradient-to-r from-violet-500 to-indigo-500 flex items-center justify-center border-2 border-white shadow-lg">
              <Icon name="folder" class="h-7 w-7 text-white" />
            </div>
          </div>
          <h1 class="text-3xl font-bold md:text-4xl px-6 bg-gradient-to-r from-violet-700 via-indigo-700 to-purple-700 bg-clip-text text-transparent">
            {{ props.workspace.name }}
          </h1>
        </div>
      </div>
      <component :is="activeTabComponent" :workspace="props.workspace" :workspace-id="props.workspace.id" />
    </section>
    <NavBar :items="navItems" class="sm:bottom-6 sm:top-auto" @tab-change="handleTabChange" />
  </AppLayout>
</template>

<script lang="ts" setup>

import { ref, computed } from 'vue';
import Icon from '@/components/ui/icon/Icon.vue';
import NavBar from '@/components/shared/NavBar.vue';
import { useIconResolver } from '@/composables/useIconResolver';
import AppLayout from '../../layout/AppLayout.vue';

// Import des composants d'onglets
import WorkspaceToolsTab from './tabs/WorkspaceToolsTab.vue';
import WorkspaceContentTab from './tabs/WorkspaceContentTab.vue';
import WorkspaceProgressionTab from './tabs/WorkspaceProgressionTab.vue';

interface IconInfo {
  id: number;
  name: string;
  path: string;
}

interface RawContent {
  id: number;
  content?: string | null;
  content_type?: string | null;
  file_name?: string | null;
}

interface Workspace {
  id: number;
  name: string;
  icon?: IconInfo;
  raw_content?: RawContent | null;
}

const props = defineProps<{
  workspace: Workspace;
}>();


const { getIconUrl } = useIconResolver();

// Gestion des onglets
const activeTab = ref('tools'); // Onglet par défaut

// Définition des éléments de navigation pour la NavBar
const navItems = [
  {
    name: "Tools",
    url: `#tools`,
    icon: "tool",
    id: "tools"
  },
  {
    name: "Content",
    url: `#content`,
    icon: "file-text",
    id: "content"
  },
  {
    name: "Progress",
    url: `#progression`,
    icon: "bar-chart",
    id: "progression"
  }
];

// Fonction pour changer d'onglet
const handleTabChange = (tabId: string) => {
  activeTab.value = tabId;
};

// Composant à afficher en fonction de l'onglet actif
const activeTabComponent = computed(() => {
  switch (activeTab.value) {
    case 'content':
      return WorkspaceContentTab;
    case 'progression':
      return WorkspaceProgressionTab;
    case 'tools':
    default:
      return WorkspaceToolsTab;
  }
});
</script>
