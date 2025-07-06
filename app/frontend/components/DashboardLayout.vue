<template>
  <div
    class="flex h-screen bg-gradient-to-br from-violet-100 via-blue-50 to-purple-100 dark:from-gray-900 dark:via-gray-800 dark:to-purple-900 backdrop-blur-3xl relative overflow-hidden transition-colors duration-300"
  >
    <!-- Effet de fond doux -->
    <div
      class="absolute inset-0 bg-gradient-to-br from-violet-200/30 via-blue-100/20 to-purple-200/30 dark:from-violet-800/20 dark:via-blue-900/10 dark:to-purple-800/20 backdrop-blur-3xl"
    ></div>
    <div
      class="absolute top-0 left-1/4 w-96 h-96 bg-gradient-to-r from-violet-300/20 to-blue-300/20 dark:from-violet-600/10 dark:to-blue-600/10 rounded-full blur-3xl"
    ></div>
    <div
      class="absolute bottom-0 right-1/4 w-96 h-96 bg-gradient-to-r from-purple-300/20 to-pink-300/20 dark:from-purple-600/10 dark:to-pink-600/10 rounded-full blur-3xl"
    ></div>

    <!-- Sidebar -->
    <div class="relative z-10">
      <Sidebar />
    </div>

    <!-- Zone principale avec sections centrale et droite -->
    <div class="flex-1 flex relative z-10">
      <!-- Section centrale (dashboard) -->
      <div class="flex-1 flex flex-col overflow-hidden mr-6">
        <!-- Header -->
        <slot name="header">
          <DashboardHeader />
        </slot>

        <!-- Contenu principal -->
        <main class="flex-1 overflow-auto px-8 pb-8">
          <slot />
        </main>
      </div>

      <!-- Section droite (widgets) -->
      <div class="w-80 p-4 pr-8">
        <slot name="rightWidgets">
          <!-- Widget par défaut -->
          <div class="space-y-6">
            <!-- Widget 1 -->
            <div
              class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-lg rounded-[24px] p-6 shadow-lg border border-white/20 dark:border-gray-700/30 transition-colors duration-300"
            >
              <h3
                class="text-lg font-medium text-gray-700 dark:text-gray-200 mb-4"
              >
                Activité récente
              </h3>
              <div class="space-y-3">
                <div class="flex items-center space-x-3">
                  <div class="w-2 h-2 bg-violet-400 rounded-full"></div>
                  <span class="text-sm text-gray-600 dark:text-gray-300"
                    >Nouveau cours ajouté</span
                  >
                </div>
                <div class="flex items-center space-x-3">
                  <div class="w-2 h-2 bg-blue-400 rounded-full"></div>
                  <span class="text-sm text-gray-600 dark:text-gray-300"
                    >3 tâches complétées</span
                  >
                </div>
                <div class="flex items-center space-x-3">
                  <div class="w-2 h-2 bg-purple-400 rounded-full"></div>
                  <span class="text-sm text-gray-600 dark:text-gray-300"
                    >Workspace mis à jour</span
                  >
                </div>
              </div>
            </div>

            <!-- Widget 2 -->
            <div
              class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-lg rounded-[24px] p-6 shadow-lg border border-white/20 dark:border-gray-700/30 transition-colors duration-300"
            >
              <h3
                class="text-lg font-medium text-gray-700 dark:text-gray-200 mb-4"
              >
                Statistiques
              </h3>
              <div class="space-y-4">
                <div>
                  <div class="flex justify-between text-sm mb-2">
                    <span class="text-gray-600 dark:text-gray-300"
                      >Progression</span
                    >
                    <span
                      class="font-medium text-violet-600 dark:text-violet-400"
                      >75%</span
                    >
                  </div>
                  <div
                    class="w-full bg-gray-200/50 dark:bg-gray-700/50 rounded-full h-2"
                  >
                    <div
                      class="bg-gradient-to-r from-violet-400 to-purple-500 h-2 rounded-full"
                      style="width: 75%"
                    ></div>
                  </div>
                </div>
                <div>
                  <div class="flex justify-between text-sm mb-2">
                    <span class="text-gray-600 dark:text-gray-300"
                      >Objectifs</span
                    >
                    <span class="font-medium text-blue-600 dark:text-blue-400"
                      >60%</span
                    >
                  </div>
                  <div
                    class="w-full bg-gray-200/50 dark:bg-gray-700/50 rounded-full h-2"
                  >
                    <div
                      class="bg-gradient-to-r from-blue-400 to-cyan-500 h-2 rounded-full"
                      style="width: 60%"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </slot>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import Sidebar from "./Navbar.vue";
import DashboardHeader from "./DashboardHeader.vue";
</script>
