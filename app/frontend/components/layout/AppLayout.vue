<script setup lang="ts">
import { ref } from 'vue';
import GradientBackground from '@/components/shared/GradientBackground.vue';
import ThemeToggle from '@/components/shared/ThemeToggle.vue';
import TopNav from '@/components/shared/TopNav.vue';
import SidebarMenu from '@/components/shared/SidebarMenu.vue';

interface Props {
  hideSidebar?: boolean;
  hideTopNav?: boolean;
  hideToggle?: boolean;
  hideGradient?: boolean;
  user?: {
    name: string;
    email: string;
    avatar?: string;
  };
}

const props = withDefaults(defineProps<Props>(), {
  hideSidebar: false,
  hideTopNav: false,
  hideToggle: false,
  hideGradient: false,
  user: () => ({
    name: 'Utilisateur',
    email: 'email@example.com',
    avatar: undefined,
  }),
});
</script>

<template>
  <div class="min-h-screen flex flex-col overflow-hidden relative">
    <!-- Gradient + Theme toggle -->
    <GradientBackground v-if="!hideGradient" />
    <ThemeToggle v-if="!hideToggle" class="fixed top-8 right-8 z-10" />
    <!-- Overlay en dark mode -->

    <!-- Layout principal -->
    <div class="flex flex-1 overflow-hidden relative z-10">
      <!-- Sidebar gauche -->
      <div v-if="!hideSidebar" class="flex-shrink-0 p-4">
        <SidebarMenu />
      </div>

      <!-- Zone centrale -->
      <div class="flex-1 flex flex-col">
        <!-- Top Navigation -->
        <div v-if="!hideTopNav" class="flex-shrink-0">
          <TopNav :user="props.user" />
        </div>

        <!-- Slot (contenu des pages) -->
        <main class="flex-1 overflow-auto p-8">
          <slot />
        </main>
      </div>
    </div>
  </div>
</template>
