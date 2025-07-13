<script setup lang="ts">
import { ref } from "vue";
import Icon from "../Icon.vue";
import BaseButton from "../BaseButton.vue";
import UserAvatar from "../UserAvatar.vue";
import { useTheme } from "../../composables/useTheme";

interface Props {
  user?: {
    name: string;
    email: string;
    avatar?: string;
  };
}

const props = withDefaults(defineProps<Props>(), {
  user: () => ({
    name: "Étudiant Demo",
    email: "demo@studyapp.com",
    avatar: undefined
  })
});

const { isDarkMode, toggleTheme } = useTheme();

const openSettings = () => {
  console.log("Ouverture des paramètres");
  // Logique pour ouvrir le panneau de paramètres
};

const openUserMenu = () => {
  console.log("Ouverture du menu utilisateur");
  // Logique pour ouvrir le menu utilisateur
};
</script>

<template>
  <div class="flex items-center justify-end space-x-4 p-6">
    <!-- Bouton Get Pro -->
    <button class="bg-gradient-to-r from-red-400 to-red-500 hover:from-red-500 hover:to-red-600 dark:from-red-500 dark:to-red-600 dark:hover:from-red-600 dark:hover:to-red-700 text-white px-4 py-2 rounded-full text-sm font-medium shadow-lg dark:shadow-xl transition-all duration-300 hover:shadow-xl dark:hover:shadow-red-500/25 hover:scale-105">
      Get Pro
    </button>

    <!-- Toggle Dark Mode -->
    <button
      @click="toggleTheme"
      class="p-3 rounded-full bg-white/50 dark:bg-slate-800/50 hover:bg-white/70 dark:hover:bg-slate-700/70 backdrop-blur-sm border border-white/20 dark:border-slate-600/50 transition-all duration-300 group hover:scale-105 shadow-lg dark:shadow-xl"
    >
      <Icon 
        :name="isDarkMode ? 'sun' : 'moon'" 
        :class="[
          'w-5 h-5 transition-all duration-300',
          isDarkMode 
            ? 'text-yellow-500 group-hover:text-yellow-400 group-hover:rotate-12' 
            : 'text-indigo-600 dark:text-indigo-400 group-hover:text-indigo-500 group-hover:-rotate-12'
        ]"
      />
    </button>

    <!-- Bouton Paramètres -->
    <button
      @click="openSettings"
      class="p-3 rounded-full bg-white/50 dark:bg-slate-800/50 hover:bg-white/70 dark:hover:bg-slate-700/70 backdrop-blur-sm border border-white/20 dark:border-slate-600/50 transition-all duration-300 group hover:scale-105 shadow-lg dark:shadow-xl"
    >
      <Icon 
        name="settings" 
        class="w-5 h-5 text-gray-600 dark:text-gray-300 group-hover:text-gray-800 dark:group-hover:text-gray-100 transition-all duration-300 group-hover:rotate-90"
      />
    </button>

    <!-- Avatar Utilisateur -->
    <div @click="openUserMenu" class="cursor-pointer transform hover:scale-105 transition-all duration-300">
      <div class="relative">
        <UserAvatar
          :name="props.user.name"
          :src="props.user.avatar"
          status="online"
          class="w-10 h-10 hover:ring-4 hover:ring-violet-200 dark:hover:ring-violet-500/30 transition-all duration-300 shadow-lg dark:shadow-xl border-2 border-white/50 dark:border-slate-600/50"
        />
        <!-- Indicateur de statut -->
        <div class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-400 dark:bg-green-500 border-2 border-white dark:border-slate-800 rounded-full animate-pulse"></div>
      </div>
    </div>
  </div>
</template> 