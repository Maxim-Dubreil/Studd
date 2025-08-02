<script setup lang="ts">
  import GradientBackground from '@/components/shared/GradientBackground.vue';
  import SidebarMenu from '@/components/shared/SidebarMenu.vue';
  import ThemeToggle from '@/components/shared/ThemeToggle.vue';
  import TopNav from '@/components/shared/TopNav.vue';

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
  <div class="relative z-20 flex min-h-screen flex-col overflow-hidden">
    <!-- Gradient + Theme toggle -->
    <GradientBackground v-if="!hideGradient" />
    <ThemeToggle v-if="!hideToggle" class="fixed top-8 right-8 z-30" />
    <!-- Overlay en dark mode -->

    <!-- Layout principal -->
    <div class="relative z-10 flex flex-1 overflow-hidden">
      <!-- Sidebar gauche -->
      <div v-if="!hideSidebar" class="flex-shrink-0 p-4">
        <SidebarMenu />
      </div>

      <!-- Zone centrale -->
      <div class="flex flex-1 flex-col">
        <!-- Top Navigation -->
        <div v-if="!hideTopNav" class="flex-shrink-0">
          <TopNav :user="props.user" />
        </div>

        <!-- Slot (contenu des pages) -->
        <main class="min-h-screen flex-1 overflow-auto p-2">
          <slot />
        </main>
      </div>
    </div>
  </div>
</template>
