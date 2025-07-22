<script setup lang="ts">
import { useTheme } from '@/composables/useTheme';
import { Button } from '@/components/ui/button';
const { theme, toggleTheme } = useTheme();
</script>

<template>
  <Button
    class="inline-flex items-center gap-2 px-3 py-1.5"
    @click="toggleTheme"
  >
    <span v-if="theme === 'dark'">☀︎ Light</span>
    <span v-else>🌙 Dark</span>
  </Button>
</template>
