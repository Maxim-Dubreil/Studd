<script setup lang="ts">
import { ref, computed } from 'vue';
import TopNav from '../../dashboard/TopNav.vue';
import SidebarMenu from '../../dashboard/SidebarMenu.vue';
import WorkspaceTabCard from './WorkspaceTabCard.vue';
import GradientBackground from '../../GradientBackground.vue';
import { Button } from "@/components/ui/button";
import Icon from '../../Icon.vue';

interface Workspace {
  id: number;
  name: string;
  icon?: string;
  created_at: string;
  updated_at: string;
}

interface Props {
  workspaces?: Workspace[];
  user?: {
    name: string;
    email: string;
    avatar?: string;
  };
}

const props = withDefaults(defineProps<Props>(), {
  workspaces: () => [],
  user: () => ({
    name: 'Utilisateur',
    email: 'user@example.com',
    avatar: undefined,
  }),
});

const createNewWorkspace = () => {
  // Rediriger vers la page de création
  window.location.href = '/workspaces/new';
};

// Calculer le nombre de workspaces à afficher (max 6 avant scroll)
const displayedWorkspaces = computed(() => props.workspaces);
</script>

<template>
  <!-- Background avec dégradé -->
  <GradientBackground />

  <!-- Layout principal -->
  <div class="min-h-screen relative">
    <!-- Overlay pour améliorer le contraste -->
    <div
      class="absolute inset-0 bg-white/5 dark:bg-black/20 backdrop-blur-[1px] transition-all duration-500"
    ></div>

    <!-- Structure en 3 parties -->
    <div class="flex h-screen relative z-10">
      <!-- Sidebar gauche -->
      <div class="flex-shrink-0 p-4">
        <SidebarMenu />
      </div>

      <!-- Zone centrale -->
      <div class="flex-1 flex flex-col">
        <!-- TopNav -->
        <div class="flex-shrink-0">
          <TopNav :user="props.user" />
        </div>

        <!-- Contenu principal -->
        <div class="flex-1 flex overflow-hidden p-6 gap-6">
          <!-- Carte centrale avec les workspaces -->
          <div
            class="flex-1 bg-white/80 dark:bg-slate-800/90 backdrop-blur-xl rounded-2xl shadow-xl dark:shadow-2xl border border-white/20 dark:border-slate-700/50 flex flex-col"
          >
            <!-- Header de la carte centrale -->
            <div class="p-6 border-b border-gray-100 dark:border-slate-700/50">
              <h1 class="text-2xl font-bold text-gray-800 dark:text-white">
                Mes Workspaces
              </h1>
              <p class="text-gray-600 dark:text-gray-300 mt-1">
                Gérez vos espaces de travail
              </p>
            </div>

            <!-- Grille des workspaces - scrollable sans scrollbar visible -->
            <div class="flex-1 overflow-y-auto scrollbar-hide p-6">
              <div
                class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8"
              >
                <WorkspaceTabCard
                  v-for="workspace in displayedWorkspaces"
                  :key="workspace.id"
                  :workspace="workspace"
                />

                <!-- Message si aucun workspace -->
                <div
                  v-if="displayedWorkspaces.length === 0"
                  class="col-span-full text-center py-12"
                >
                  <Icon
                    name="grid"
                    class="w-16 h-16 text-gray-300 dark:text-gray-600 mx-auto mb-4"
                  />
                  <h3
                    class="text-lg font-medium text-gray-500 dark:text-gray-400 mb-2"
                  >
                    Aucun workspace
                  </h3>
                  <p class="text-gray-400 dark:text-gray-500">
                    Créez votre premier espace de travail pour commencer
                  </p>
                </div>
              </div>
            </div>

            <!-- Bouton Create New Workspace en bas -->
            <div class="p-6 border-t border-gray-100 dark:border-slate-700/50">
              <Button
                @click="createNewWorkspace"
                variant="default"
                size="lg"
                radius="xl"
              >
                <Icon name="plus" class="w-5 h-5 mr-2" />
                Créer un nouveau workspace
              </Button>
            </div>
          </div>

          <!-- Carte latérale droite -->
          <div
            class="w-80 bg-white/80 dark:bg-slate-800/90 backdrop-blur-xl rounded-2xl shadow-xl dark:shadow-2xl border border-white/20 dark:border-slate-700/50 flex flex-col"
          >
            <!-- Header de la carte latérale -->
            <div class="p-6 border-b border-gray-100 dark:border-slate-700/50">
              <h2 class="text-xl font-semibold text-gray-800 dark:text-white">
                Informations
              </h2>
            </div>

            <!-- Contenu de la carte latérale -->
            <div class="flex-1 p-6 space-y-6">
              <!-- Statistiques -->
              <div
                class="bg-gradient-to-r from-violet-500/10 to-purple-500/10 dark:from-violet-500/20 dark:to-purple-500/20 rounded-xl p-4"
              >
                <h3
                  class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2"
                >
                  Statistiques
                </h3>
                <div class="space-y-2">
                  <div class="flex justify-between text-sm">
                    <span class="text-gray-600 dark:text-gray-400"
                      >Total des workspaces:</span
                    >
                    <span class="font-medium text-gray-800 dark:text-white">{{
                      displayedWorkspaces.length
                    }}</span>
                  </div>
                  <div class="flex justify-between text-sm">
                    <span class="text-gray-600 dark:text-gray-400"
                      >Créés ce mois:</span
                    >
                    <span class="font-medium text-gray-800 dark:text-white">{{
                      displayedWorkspaces.length
                    }}</span>
                  </div>
                </div>
              </div>

              <!-- Actions rapides -->
              <div>
                <h3
                  class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-3"
                >
                  Actions rapides
                </h3>
                <div class="space-y-2">
                  <Button
                    variant = "outline"
                    class="w-full"
                  >
                    <div class="flex items-center">
                      <Icon
                        name="settings"
                        class="w-4 h-4 text-gray-500 dark:text-gray-400 group-hover:text-violet-500 transition-colors"
                      />
                      <span
                        class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-white"
                        >Paramètres</span
                      >
                    </div>
                  </Button>
                  <Button
                    variant = "outline"
                    class="w-full"
                  >
                    <div class="flex items-center">
                      <Icon
                        name="users"
                        class="w-4 h-4 text-gray-500 dark:text-gray-400 group-hover:text-violet-500 transition-colors"
                      />
                      <span
                        class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-white"
                        >Inviter des membres</span
                      >
                    </div>
                  </Button>
                  <Button
                    variant = "outline"
                    class="w-full"
                  >
                    <div class="flex items-center">
                      <Icon
                        name="document"
                        class="w-4 h-4 text-gray-500 dark:text-gray-400 group-hover:text-violet-500 transition-colors"
                      />
                      <span
                        class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-white"
                        >Documentation</span
                      >
                    </div>
                  </Button>
                </div>
              </div>

              <!-- Aide -->
              <div class="bg-blue-50/50 dark:bg-blue-900/20 rounded-xl p-4">
                <div class="flex items-start">
                  <Icon
                    name="info"
                    class="w-5 h-5 text-blue-500 dark:text-blue-400 mt-0.5"
                  />
                  <div class="ml-3">
                    <h4
                      class="text-sm font-medium text-blue-900 dark:text-blue-100"
                    >
                      Besoin d'aide ?
                    </h4>
                    <p class="text-xs text-blue-700 dark:text-blue-200 mt-1">
                      Consultez notre guide pour créer votre premier workspace.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Cache la scrollbar mais garde la fonctionnalité de scroll */
.scrollbar-hide {
  -ms-overflow-style: none; /* Internet Explorer 10+ */
  scrollbar-width: none; /* Firefox */
}

.scrollbar-hide::-webkit-scrollbar {
  display: none; /* Safari and Chrome */
}

@media (max-width: 768px) {
  .flex {
    flex-direction: column;
  }

  .w-80 {
    width: 100%;
  }
}
</style>
