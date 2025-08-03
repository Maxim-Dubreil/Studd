<script setup lang="ts">
  import { Button } from '@/components/ui/button';
  import { Icon } from '@/components/ui/icon';
  import { useTheme } from '@/composables/useTheme';
  import { computed } from 'vue';

  const { theme, toggleTheme } = useTheme();
  const isDark = computed(() => theme.value === 'dark');
</script>

<template>
  <Button
    @click="toggleTheme"
    variant="outline"
    size="icon"
    class="group rounded-full border border-white/20 bg-white/50 p-3 shadow-lg backdrop-blur-sm transition-all hover:scale-105 hover:bg-white/70 dark:border-slate-600/50 dark:bg-slate-800/50 dark:shadow-xl dark:hover:bg-slate-700/70"
  >
    <Icon
      :name="isDark ? 'sun' : 'moon'"
      class="h-5 w-5 transition-all duration-300"
      :class="
        isDark
          ? 'text-yellow-500 group-hover:rotate-12 group-hover:text-yellow-400'
          : 'text-indigo-600 group-hover:-rotate-12 group-hover:text-indigo-500 dark:text-indigo-400'
      "
    />
  </Button>
</template>
