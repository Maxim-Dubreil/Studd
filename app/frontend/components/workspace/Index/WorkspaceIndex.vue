<script setup lang="ts">
  import { Button } from '@/components/ui/button';
  import { Icon } from '@/components/ui/icon';
  import { computed } from 'vue';
  import AppLayout from '../../layout/AppLayout.vue';
  import WorkspaceTabCard from './WorkspaceIndexCard.vue';

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
  <AppLayout :hide-sidebar="false" :hide-top-nav="false" :hide-gradient="false" :hide-toggle="true">
    <div class="relative min-h-screen">
      <!-- Overlay pour améliorer le contraste -->
      <div
        class="absolute inset-0 bg-white/5 backdrop-blur-[1px] transition-all duration-500 dark:bg-black/20"
      ></div>

      <!-- Structure en 3 parties -->
      <div class="relative flex h-screen">
        <!-- Zone centrale -->
        <div class="flex flex-1 flex-col">
          <!-- Contenu principal -->
          <div class="flex flex-1 gap-6 overflow-hidden p-2">
            <!-- Carte centrale avec les workspaces -->
            <div
              class="flex flex-1 flex-col rounded-2xl border border-white/20 bg-white/80 shadow-xl backdrop-blur-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-2xl"
            >
              <!-- Header de la carte centrale -->
              <div class="border-b border-gray-100 p-6 dark:border-slate-700/50">
                <h1 class="text-2xl font-bold text-gray-800 dark:text-white">Mes Workspaces</h1>
                <p class="mt-1 text-gray-600 dark:text-gray-300">Gérez vos espaces de travail</p>
              </div>

              <!-- Grille des workspaces - scrollable sans scrollbar visible -->
              <div class="scrollbar-hide flex-1 overflow-y-auto p-6">
                <div class="mb-8 grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
                  <WorkspaceTabCard
                    v-for="workspace in displayedWorkspaces"
                    :key="workspace.id"
                    :workspace="workspace"
                  />

                  <!-- Message si aucun workspace -->
                  <div
                    v-if="displayedWorkspaces.length === 0"
                    class="col-span-full py-12 text-center"
                  >
                    <Icon
                      name="grid"
                      class="mx-auto mb-4 h-16 w-16 text-gray-300 dark:text-gray-600"
                    />
                    <h3 class="mb-2 text-lg font-medium text-gray-500 dark:text-gray-400">
                      Aucun workspace
                    </h3>
                    <p class="text-gray-400 dark:text-gray-500">
                      Créez votre premier espace de travail pour commencer
                    </p>
                  </div>
                </div>
              </div>

              <!-- Bouton Create New Workspace en bas -->
              <div class="border-t border-gray-100 p-6 dark:border-slate-700/50">
                <Button @click="createNewWorkspace" variant="default" size="lg" radius="xl">
                  <Icon name="plus" class="mr-2 h-5 w-5" />
                  Créer un nouveau workspace
                </Button>
              </div>
            </div>

            <!-- Carte latérale droite -->
            <div
              class="flex w-80 flex-col rounded-2xl border border-white/20 bg-white/80 shadow-xl backdrop-blur-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-2xl"
            >
              <!-- Header de la carte latérale -->
              <div class="border-b border-gray-100 p-6 dark:border-slate-700/50">
                <h2 class="text-xl font-semibold text-gray-800 dark:text-white">Informations</h2>
              </div>

              <!-- Contenu de la carte latérale -->
              <div class="flex-1 space-y-6 p-6">
                <!-- Statistiques -->
                <div
                  class="rounded-xl bg-gradient-to-r from-violet-500/10 to-purple-500/10 p-4 dark:from-violet-500/20 dark:to-purple-500/20"
                >
                  <h3 class="mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Statistiques
                  </h3>
                  <div class="space-y-2">
                    <div class="flex justify-between text-sm">
                      <span class="text-gray-600 dark:text-gray-400">Total des workspaces:</span>
                      <span class="font-medium text-gray-800 dark:text-white">
                        {{ displayedWorkspaces.length }}
                      </span>
                    </div>
                    <div class="flex justify-between text-sm">
                      <span class="text-gray-600 dark:text-gray-400">Créés ce mois:</span>
                      <span class="font-medium text-gray-800 dark:text-white">
                        {{ displayedWorkspaces.length }}
                      </span>
                    </div>
                  </div>
                </div>

                <!-- Actions rapides -->
                <div>
                  <h3 class="mb-3 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Actions rapides
                  </h3>
                  <div class="space-y-2">
                    <Button variant="outline" class="w-full">
                      <div class="flex items-center">
                        <Icon
                          name="settings"
                          class="h-4 w-4 text-gray-500 transition-colors group-hover:text-violet-500 dark:text-gray-400"
                        />
                        <span
                          class="ml-3 text-sm text-gray-700 group-hover:text-gray-900 dark:text-gray-300 dark:group-hover:text-white"
                        >
                          Paramètres
                        </span>
                      </div>
                    </Button>
                    <Button variant="outline" class="w-full">
                      <div class="flex items-center">
                        <Icon
                          name="users"
                          class="h-4 w-4 text-gray-500 transition-colors group-hover:text-violet-500 dark:text-gray-400"
                        />
                        <span
                          class="ml-3 text-sm text-gray-700 group-hover:text-gray-900 dark:text-gray-300 dark:group-hover:text-white"
                        >
                          Inviter des membres
                        </span>
                      </div>
                    </Button>
                    <Button variant="outline" class="w-full">
                      <div class="flex items-center">
                        <Icon
                          name="document"
                          class="h-4 w-4 text-gray-500 transition-colors group-hover:text-violet-500 dark:text-gray-400"
                        />
                        <span
                          class="ml-3 text-sm text-gray-700 group-hover:text-gray-900 dark:text-gray-300 dark:group-hover:text-white"
                        >
                          Documentation
                        </span>
                      </div>
                    </Button>
                  </div>
                </div>

                <!-- Aide -->
                <div class="rounded-xl bg-blue-50/50 p-4 dark:bg-blue-900/20">
                  <div class="flex items-start">
                    <Icon name="info" class="mt-0.5 h-5 w-5 text-blue-500 dark:text-blue-400" />
                    <div class="ml-3">
                      <h4 class="text-sm font-medium text-blue-900 dark:text-blue-100">
                        Besoin d'aide ?
                      </h4>
                      <p class="mt-1 text-xs text-blue-700 dark:text-blue-200">
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
  </AppLayout>
</template>
