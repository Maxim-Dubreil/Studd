<template>
  <div class="space-y-6 font-['Inter',sans-serif]">
    <!-- Carte horizontale large en haut avec dégradé violet-bleu -->
    <div
      class="bg-gradient-to-br from-violet-400 via-purple-500 to-blue-500 dark:from-violet-600 dark:via-purple-700 dark:to-blue-700 rounded-[24px] p-8 text-white shadow-xl backdrop-blur-lg border border-white/20 dark:border-gray-700/30 transition-colors duration-300"
    >
      <div class="max-w-2xl">
        <h2 class="text-3xl font-light mb-4">Bienvenue dans votre espace</h2>
        <p
          class="text-violet-100 dark:text-violet-200 text-lg font-light opacity-90"
        >
          Suivez vos progrès, gérez vos projets et accédez à tous vos outils
          d'apprentissage en un seul endroit.
        </p>
        <div class="mt-6">
          <button
            class="bg-white/20 dark:bg-white/10 backdrop-blur-sm hover:bg-white/30 dark:hover:bg-white/20 text-white px-6 py-3 rounded-[16px] text-sm font-medium transition-all duration-300 border border-white/30"
          >
            Commencer maintenant
          </button>
        </div>
      </div>
    </div>

    <!-- Grille de 3 petites cartes rectangulaires -->
    <div class="grid grid-cols-3 gap-6">
      <!-- Carte 1 -->
      <div
        class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-lg rounded-[20px] p-6 shadow-lg border border-white/20 dark:border-gray-700/30 hover:shadow-xl transition-all duration-300"
      >
        <div class="flex items-center justify-between mb-4">
          <div
            class="w-12 h-12 bg-gradient-to-br from-violet-400 to-purple-500 rounded-[16px] flex items-center justify-center"
          >
            <Icon name="briefcase" size="lg" color="text-white" />
          </div>
        </div>
        <h3 class="text-lg font-medium text-gray-700 dark:text-gray-200 mb-2">
          Projets
        </h3>
        <div class="text-3xl font-light text-gray-800 dark:text-gray-100 mb-1">
          12
        </div>
        <p class="text-gray-500 dark:text-gray-400 text-sm font-light">
          En cours
        </p>
      </div>

      <!-- Carte 2 -->
      <div
        class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-lg rounded-[20px] p-6 shadow-lg border border-white/20 dark:border-gray-700/30 hover:shadow-xl transition-all duration-300"
      >
        <div class="flex items-center justify-between mb-4">
          <div
            class="w-12 h-12 bg-gradient-to-br from-blue-400 to-cyan-500 rounded-[16px] flex items-center justify-center"
          >
            <Icon name="check" size="lg" color="text-white" />
          </div>
        </div>
        <h3 class="text-lg font-medium text-gray-700 dark:text-gray-200 mb-2">
          Tâches
        </h3>
        <div class="text-3xl font-light text-gray-800 dark:text-gray-100 mb-1">
          87
        </div>
        <p class="text-gray-500 dark:text-gray-400 text-sm font-light">
          Complétées
        </p>
      </div>

      <!-- Carte 3 -->
      <div
        class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-lg rounded-[20px] p-6 shadow-lg border border-white/20 dark:border-gray-700/30 hover:shadow-xl transition-all duration-300"
      >
        <div class="flex items-center justify-between mb-4">
          <div
            class="w-12 h-12 bg-gradient-to-br from-emerald-400 to-teal-500 rounded-[16px] flex items-center justify-center"
          >
            <Icon name="clock" size="lg" color="text-white" />
          </div>
        </div>
        <h3 class="text-lg font-medium text-gray-700 dark:text-gray-200 mb-2">
          Temps
        </h3>
        <div class="text-3xl font-light text-gray-800 dark:text-gray-100 mb-1">
          42h
        </div>
        <p class="text-gray-500 dark:text-gray-400 text-sm font-light">
          Cette semaine
        </p>
      </div>
    </div>

    <!-- Carte large horizontale en bas -->
    <div
      class="bg-white/70 dark:bg-gray-800/70 backdrop-blur-lg rounded-[24px] p-8 shadow-lg border border-white/20 dark:border-gray-700/30 transition-colors duration-300"
    >
      <h3 class="text-xl font-medium text-gray-700 dark:text-gray-200 mb-6">
        Aperçu des performances
      </h3>
      <div class="grid grid-cols-2 gap-8">
        <!-- Colonne gauche : Graphique ou stats -->
        <div>
          <h4 class="text-md font-medium text-gray-600 dark:text-gray-300 mb-4">
            Progression mensuelle
          </h4>
          <div class="space-y-4">
            <div>
              <div class="flex justify-between text-sm mb-2">
                <span class="text-gray-600 dark:text-gray-300 font-light"
                  >Objectifs atteints</span
                >
                <span class="font-medium text-violet-600 dark:text-violet-400"
                  >85%</span
                >
              </div>
              <div
                class="w-full bg-gray-200/50 dark:bg-gray-700/50 rounded-full h-3"
              >
                <div
                  class="bg-gradient-to-r from-violet-400 to-purple-500 h-3 rounded-full transition-all duration-500"
                  style="width: 85%"
                ></div>
              </div>
            </div>

            <div>
              <div class="flex justify-between text-sm mb-2">
                <span class="text-gray-600 dark:text-gray-300 font-light"
                  >Projets avancés</span
                >
                <span class="font-medium text-blue-600 dark:text-blue-400"
                  >72%</span
                >
              </div>
              <div
                class="w-full bg-gray-200/50 dark:bg-gray-700/50 rounded-full h-3"
              >
                <div
                  class="bg-gradient-to-r from-blue-400 to-cyan-500 h-3 rounded-full transition-all duration-500"
                  style="width: 72%"
                ></div>
              </div>
            </div>

            <div>
              <div class="flex justify-between text-sm mb-2">
                <span class="text-gray-600 dark:text-gray-300 font-light"
                  >Apprentissage</span
                >
                <span class="font-medium text-emerald-600 dark:text-emerald-400"
                  >94%</span
                >
              </div>
              <div
                class="w-full bg-gray-200/50 dark:bg-gray-700/50 rounded-full h-3"
              >
                <div
                  class="bg-gradient-to-r from-emerald-400 to-teal-500 h-3 rounded-full transition-all duration-500"
                  style="width: 94%"
                ></div>
              </div>
            </div>
          </div>
        </div>

        <!-- Colonne droite : Activités récentes -->
        <div>
          <h4 class="text-md font-medium text-gray-600 dark:text-gray-300 mb-4">
            Dernières activités
          </h4>
          <div class="space-y-3">
            <div
              class="flex items-center space-x-3 p-3 rounded-[12px] bg-violet-50/50 dark:bg-violet-900/20 backdrop-blur-sm"
            >
              <div
                class="w-8 h-8 bg-gradient-to-r from-violet-400 to-purple-500 rounded-full flex items-center justify-center"
              >
                <Icon name="plus" size="sm" color="text-white" />
              </div>
              <div class="flex-1">
                <p class="text-sm font-medium text-gray-700 dark:text-gray-200">
                  Nouveau projet créé
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400 font-light">
                  Il y a 2 heures
                </p>
              </div>
            </div>

            <div
              class="flex items-center space-x-3 p-3 rounded-[12px] bg-blue-50/50 dark:bg-blue-900/20 backdrop-blur-sm"
            >
              <div
                class="w-8 h-8 bg-gradient-to-r from-blue-400 to-cyan-500 rounded-full flex items-center justify-center"
              >
                <Icon name="graduation" size="sm" color="text-white" />
              </div>
              <div class="flex-1">
                <p class="text-sm font-medium text-gray-700 dark:text-gray-200">
                  Formation complétée
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400 font-light">
                  Il y a 4 heures
                </p>
              </div>
            </div>

            <div
              class="flex items-center space-x-3 p-3 rounded-[12px] bg-emerald-50/50 dark:bg-emerald-900/20 backdrop-blur-sm"
            >
              <div
                class="w-8 h-8 bg-gradient-to-r from-emerald-400 to-teal-500 rounded-full flex items-center justify-center"
              >
                <Icon name="users" size="sm" color="text-white" />
              </div>
              <div class="flex-1">
                <p class="text-sm font-medium text-gray-700 dark:text-gray-200">
                  Équipe mise à jour
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400 font-light">
                  Il y a 6 heures
                </p>
              </div>
            </div>

            <div
              class="flex items-center space-x-3 p-3 rounded-[12px] bg-orange-50/50 dark:bg-orange-900/20 backdrop-blur-sm"
            >
              <div
                class="w-8 h-8 bg-gradient-to-r from-orange-400 to-red-500 rounded-full flex items-center justify-center"
              >
                <Icon name="bell" size="sm" color="text-white" />
              </div>
              <div class="flex-1">
                <p class="text-sm font-medium text-gray-700 dark:text-gray-200">
                  Nouvelle notification
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400 font-light">
                  Il y a 8 heures
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import Icon from "../ui/Icon.vue";
</script>
