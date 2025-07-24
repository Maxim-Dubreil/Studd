<script setup lang="ts">
import { ref } from "vue";
import { useTheme } from "../../composables/useTheme";
import { Button } from "@/components/ui/button";
import UserAvatar from "../ui/avatar/UserAvatar.vue";
import { Icon } from '@/components/ui/icon'

interface Props {
  title?: string;
}

const props = withDefaults(defineProps<Props>(), {
  title: "",
});

const { toggleTheme, theme } = useTheme();

const user = ref({
  name: "Users",
  avatar: "",
  status: "online" as const,
});

const toggleDarkMode = () => {
  toggleTheme();
};

const openSettings = () => {
  // Logique pour ouvrir les paramètres
  console.log("Open settings");
};

const openUserMenu = () => {
  // Logique pour ouvrir le menu utilisateur
  console.log("Open user menu");
};
</script>

<template>
  <header class="bg-transparent px-8 py-6 font-['Inter',sans-serif]">
    <div class="flex items-center justify-between">
      <!-- Titre de la page -->
      <div>
        <h1 class="text-3xl font-light text-gray-700 dark:text-gray-200">
          {{ title }}
        </h1>
      </div>

      <!-- Actions utilisateur -->
      <div class="flex items-center space-x-4">
        <!-- Bouton Get pro -->
        <Button variant="destructive" size="sm" label="Get Pro" class="shadow-lg backdrop-blur-sm" />

        <!-- Toggle Dark/Light” -->
        <Button @click="toggleTheme" variant="outline" radius="xl" size="icon"
          class="group p-3 rounded-full bg-white/50 dark:bg-slate-800/50 hover:bg-white/70 dark:hover:bg-slate-700/70 backdrop-blur-sm border border-white/20 dark:border-slate-600/50 shadow-lg dark:shadow-xl hover:scale-105 transition-all">
          <Icon :name="theme === 'dark' ? 'sun' : 'moon'" :class="[
            'w-5 h-5 transition-all duration-300',
            theme === 'dark'
              ? 'text-yellow-500 group-hover:text-yellow-400 group-hover:rotate-12'
              : 'text-indigo-600 dark:text-indigo-400 group-hover:text-indigo-500 group-hover:-rotate-12'
          ]" />
        </Button>

        <!-- Settings -->
        <Button variant="secondary" size="sm" outlined @click="openSettings"
          class="p-3 rounded-[16px] hover:bg-white/50 dark:hover:bg-gray-800/50 backdrop-blur-sm transition-colors duration-300">
          <Icon name="settings" size="md" color="text-gray-600 dark:text-gray-300" />
        </Button>

        <!-- Avatar -->
        <UserAvatar :name="user.name" :src="user.avatar" :status="user.status" clickable @click="openUserMenu" />
      </div>
    </div>
  </header>
</template>