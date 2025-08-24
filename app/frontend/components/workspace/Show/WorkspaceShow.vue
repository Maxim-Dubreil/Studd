<template>
  <AppLayout :hide-sidebar="true" :hide-top-nav="true" :hide-toggle="false" :hide-gradient="false">
    <!-- Ajout d'une classe pb-24 pour laisser de l'espace en bas pour la navbar -->
    <section class="px-10 pb-24">
      <div class="relative mb-8 text-center p-4">  <!-- Réduit la marge du bas de mb-10 à mb-8 -->
        <a
          href="/workspaces"
          class="bg-card/50 hover:bg-card/80 absolute top-1/2 left-0 -translate-y-1/2 rounded-lg border p-2 backdrop-blur-sm"
        >
          <Icon name="arrow-left" class="h-6 w-6" />
        </a>
        <div class="flex items-center justify-center">
          <img
            v-if="props.workspace.icon"
            :src="getIconUrl(props.workspace.icon.path)"
            :alt="props.workspace.icon.name"
            class="h-12 w-12 rounded-lg"
          />
          <h1 class="text-3xl font-semibold md:text-4xl">
            {{ props.workspace.name }}
          </h1>
        </div>
      </div>

      <!-- Contenu de l'onglet actif -->
      <component
        :is="activeTabComponent"
        :workspace="props.workspace"
        :workspace-id="props.workspace.id"
      />
    </section>

    <!-- NavBar en bas de l'écran -->
    <NavBar :items="navItems" class="sm:bottom-6 sm:top-auto" @tab-change="handleTabChange" />
  </AppLayout>
</template>

<script setup lang="ts">
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
      name: "Outils",
      url: `#tools`,
      icon: "tool",
      id: "tools"
    },
    {
      name: "Contenu",
      url: `#content`,
      icon: "file-text",
      id: "content"
    },
    {
      name: "Progression",
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
