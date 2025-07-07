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
        <BaseButton
          variant="danger"
          size="md"
          label="Get Pro"
          class="shadow-lg backdrop-blur-sm"
        />

        <!-- Toggle dark mode -->
        <BaseButton
          variant="secondary"
          size="md"
          outlined
          @click="toggleDarkMode"
          class="p-3 rounded-[16px] hover:bg-white/50 dark:hover:bg-gray-800/50 backdrop-blur-sm transition-colors duration-300"
        >
          <Icon
            :name="isDark ? 'sun' : 'moon'"
            size="md"
            :color="isDark ? 'text-yellow-500' : 'text-gray-600'"
          />
        </BaseButton>

        <!-- Settings -->
        <BaseButton
          variant="secondary"
          size="md"
          outlined
          @click="openSettings"
          class="p-3 rounded-[16px] hover:bg-white/50 dark:hover:bg-gray-800/50 backdrop-blur-sm transition-colors duration-300"
        >
          <Icon
            name="settings"
            size="md"
            color="text-gray-600 dark:text-gray-300"
          />
        </BaseButton>

        <!-- Avatar -->
        <UserAvatar
          :name="user.name"
          :src="user.avatar"
          :status="user.status"
          clickable
          @click="openUserMenu"
        />
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { useTheme } from "../../composables/useTheme";
import BaseButton from "../BaseButton.vue";
import UserAvatar from "../UserAvatar.vue";
import Icon from "../Icon.vue";

interface Props {
  title?: string;
}

const props = withDefaults(defineProps<Props>(), {
  title: "",
});

const { toggleTheme, isDark } = useTheme();

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
