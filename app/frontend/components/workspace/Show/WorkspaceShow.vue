<template>
  <AppLayout :hide-sidebar="true" :hide-top-nav="true" :hide-toggle="false" :hide-gradient="false">
    <div class="pointer-events-none fixed inset-0 overflow-hidden">
      <div
        class="absolute inset-0 bg-gradient-to-br from-violet-50/30 via-indigo-50/20 to-purple-50/30"
      ></div>
      <div
        class="absolute top-1/4 left-1/4 h-96 w-96 -translate-x-1/2 -translate-y-1/2 transform rounded-full bg-violet-200/20 blur-3xl"
      ></div>
      <div
        class="absolute right-1/4 bottom-1/4 h-80 w-80 translate-x-1/2 translate-y-1/2 transform rounded-full bg-indigo-200/20 blur-3xl"
      ></div>
      <div
        class="absolute top-3/4 left-3/4 h-64 w-64 -translate-x-1/2 -translate-y-1/2 transform rounded-full bg-purple-200/15 blur-2xl"
      ></div>
    </div>

    <section class="relative z-10 px-10 pb-24">
      <BackButton href="/workspaces" />
      <HomeButton :href="`/dashboard`" />

      <div class="relative mb-8 p-4 text-center">
        <div class="flex items-center justify-center">
          <div class="relative">
            <div
              class="absolute inset-0 rounded-xl bg-gradient-to-r from-violet-400 to-indigo-400 opacity-75 blur"
            ></div>
            <img
              v-if="props.workspace.icon"
              :src="getIconUrl(props.workspace.icon.path)"
              :alt="props.workspace.icon.name"
              class="relative h-14 w-14 rounded-xl border-2 border-white shadow-lg"
            />
            <div
              v-else
              class="relative flex h-14 w-14 items-center justify-center rounded-xl border-2 border-white bg-gradient-to-r from-violet-500 to-indigo-500 shadow-lg"
            >
              <Icon name="folder" class="h-7 w-7 text-white" />
            </div>
          </div>
          <h1
            class="bg-gradient-to-r from-violet-700 via-indigo-700 to-purple-700 bg-clip-text px-6 text-3xl font-bold text-transparent md:text-4xl"
          >
            {{ props.workspace.name }}
          </h1>
        </div>
      </div>
      <component
        :is="activeTabComponent"
        :workspace="props.workspace"
        :workspace-id="props.workspace.id"
      />
    </section>
    <NavBar :items="navItems" class="sm:top-auto sm:bottom-6" @tab-change="handleTabChange" />
  </AppLayout>
</template>

<script lang="ts" setup>
  import NavBar from '@/components/shared/NavBar.vue';
  import Icon from '@/components/ui/icon/Icon.vue';
  import { useIconResolver } from '@/composables/useIconResolver';
  import { computed, ref } from 'vue';
  import AppLayout from '../../layout/AppLayout.vue';
  // Import des composants d'onglets
  import BackButton from '@/components/ui/button/BackButton.vue';
  import HomeButton from '@/components/ui/button/HomeButton.vue';
  import WorkspaceContentTab from './tabs/WorkspaceContentTab.vue';
  import WorkspaceProgressionTab from './tabs/WorkspaceProgressionTab.vue';
  import WorkspaceToolsTab from './tabs/WorkspaceToolsTab.vue';

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
      name: 'Tools',
      url: `#tools`,
      icon: 'tool',
      id: 'tools',
    },
    {
      name: 'Content',
      url: `#content`,
      icon: 'file-text',
      id: 'content',
    },
    {
      name: 'Progress',
      url: `#progression`,
      icon: 'bar-chart',
      id: 'progression',
    },
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
