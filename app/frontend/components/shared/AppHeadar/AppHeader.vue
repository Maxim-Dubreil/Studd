<script setup lang="ts">
  import { Button } from '@/components/ui/button';
  import { Icon } from '@/components/ui/icon';
  import { SidebarTrigger } from '@/components/ui/sidebar';
  import { useTheme } from '@/composables/useTheme';
  import AppBreadcrumb from './AppBreadcrumb.vue';

  const props = withDefaults(defineProps<{ hideCollapse?: boolean; hideHelper?: boolean }>(), {
    hideCollapse: false,
    hideHelper: false,
  });
  const { theme, toggleTheme } = useTheme();

  const breadcrumbLabels = {
    workspaces: 'Workspaces',
    settings: 'Settings',
    dashboard: 'Dashboard',
  };
</script>

<template>
  <!-- Header avec sidebar (style complet) -->
  <header
    v-if="!props.hideCollapse"
    class="bg-background/75 border-border/40 dark:bg-background/40 sticky top-3 z-50 mx-2 flex h-14 items-center justify-between rounded-2xl border-b px-4 shadow-sm backdrop-blur-lg dark:border-zinc-800"
  >
    <!-- Gauche : bouton collapse + breadcrumbs -->
    <div class="flex h-full min-w-0 items-center gap-3">
      <SidebarTrigger
        class="ring-offset-background focus-visible:ring-ring hover:bg-ring hover:text-background inline-flex h-9 w-9 items-center justify-center rounded-2xl text-sm font-medium transition-colors focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:outline-none disabled:pointer-events-none disabled:opacity-50"
        aria-label="Toggle sidebar"
      />

      <!-- Separator -->
      <div class="mr-2 h-6 w-px bg-gray-300 dark:bg-gray-600"></div>

      <!-- Breadcrumbs -->
      <div class="flex items-center">
        <AppBreadcrumb :labels="breadcrumbLabels" />
      </div>
    </div>

    <!-- Droite : Dark mode -->
    <div class="flex items-center gap-3">
      <Button
        @click="toggleTheme"
        variant="ghost"
        size="sm"
        class="group border-border/50 bg-background/50 hover:border-border relative overflow-hidden rounded-lg border shadow-sm backdrop-blur-sm transition-all duration-200 hover:scale-105 hover:shadow-md"
      >
        <div
          class="absolute inset-0 bg-gradient-to-r from-violet-500/10 to-purple-500/10 opacity-0 transition-opacity duration-300 group-hover:opacity-100"
        ></div>
        <Icon
          :name="theme === 'dark' ? 'sun' : 'moon'"
          size="sm"
          :class="[
            'relative z-10 transition-all duration-500',
            theme === 'dark'
              ? 'text-amber-500 drop-shadow-[0_0_8px_rgba(245,158,11,0.5)] group-hover:rotate-180 group-hover:text-amber-400'
              : 'text-slate-600 group-hover:rotate-180 group-hover:text-indigo-500 dark:text-slate-400',
          ]"
        />
      </Button>
    </div>
  </header>

  <!-- Header sans sidebar (style minimal/transparent) -->
  <header v-else class="fixed top-8 right-8 z-50">
    <div class="flex items-center gap-3">
      <Button
        v-if="!props.hideHelper"
        as="a"
        href="/docs"
        variant="ghost"
        size="sm"
        class="group border-border/50 bg-background/50 hover:border-border relative overflow-hidden rounded-lg border shadow-sm backdrop-blur-sm transition-all duration-200 hover:scale-105 hover:shadow-md"
        aria-label="Open documentation"
      >
        <div
          class="absolute inset-0 bg-gradient-to-r from-violet-500/10 to-purple-500/10 opacity-0 transition-opacity duration-300 group-hover:opacity-100"
        ></div>
        <Icon
          name="help-circle"
          size="sm"
          class="relative z-10 text-indigo-500 transition-all duration-500 group-hover:rotate-12 group-hover:text-violet-600"
        />
      </Button>
      <Button
        @click="toggleTheme"
        variant="ghost"
        size="sm"
        class="group border-border/50 bg-background/50 hover:border-border relative overflow-hidden rounded-lg border shadow-sm backdrop-blur-sm transition-all duration-200 hover:scale-105 hover:shadow-md"
      >
        <div
          class="absolute inset-0 bg-gradient-to-r from-violet-500/10 to-purple-500/10 opacity-0 transition-opacity duration-300 group-hover:opacity-100"
        ></div>
        <Icon
          :name="theme === 'dark' ? 'sun' : 'moon'"
          size="sm"
          :class="[
            'relative z-10 transition-all duration-500',
            theme === 'dark'
              ? 'text-amber-500 drop-shadow-[0_0_8px_rgba(245,158,11,0.5)] group-hover:rotate-180 group-hover:text-amber-400'
              : 'text-slate-600 group-hover:rotate-180 group-hover:text-indigo-500 dark:text-slate-400',
          ]"
        />
      </Button>
    </div>
  </header>
</template>
