<template>
  <div class="rounded-lg border bg-white p-6 shadow-sm transition-all duration-300 hover:scale-105 hover:shadow-lg dark:bg-slate-800">
    <div class="mb-4 flex items-center">
      <Icon :name="icon" class="mr-3 h-6 w-6 text-violet-500 dark:text-violet-400" />
      <span class="text-sm font-medium text-gray-700 dark:text-gray-300">{{ label }}</span>
    </div>
    <div class="text-3xl font-bold text-gray-800 dark:text-gray-100">
      {{ value }}
    </div>
    <div v-if="subtitle" class="text-sm text-gray-500 dark:text-gray-400">
      {{ subtitle }}
    </div>
  </div>
</template>

<script setup lang="ts">
import Icon from '@/components/ui/icon/Icon.vue';

interface Props {
  icon: string;
  label: string;
  value: string | number;
  subtitle?: string;
}

defineProps<Props>();
</script>
