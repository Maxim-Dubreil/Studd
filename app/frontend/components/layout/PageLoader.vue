<!-- app/frontend/components/PageLoader.vue -->
<script setup lang="ts">
  interface Props {
    message?: string;
    showLogo?: boolean;
  }

  withDefaults(defineProps<Props>(), {
    message: 'Loading...',
    showLogo: true,
  });
</script>

<template>
  <div class="flex flex-col items-center space-y-6">
    <!-- Logo avec animation -->
    <div v-if="showLogo" class="flex justify-center">
      <div
        class="flex h-16 w-16 items-center justify-center rounded-2xl bg-gradient-to-r from-violet-500 to-purple-500"
      >
        <span class="animate-pulse text-2xl font-bold text-white">S</span>
      </div>
    </div>

    <!-- Spinner élégant -->
    <div class="relative">
      <div class="h-12 w-12 rounded-full border-4 border-gray-200 dark:border-gray-700"></div>
      <div
        class="absolute top-0 left-0 h-12 w-12 animate-spin rounded-full border-4 border-violet-500 border-t-transparent"
      ></div>
    </div>

    <!-- Message -->
    <p class="text-center font-medium text-gray-600 dark:text-gray-300">
      {{ message }}
    </p>

    <!-- Points animés -->
    <div class="flex space-x-1">
      <div
        v-for="i in 3"
        :key="i"
        class="h-2 w-2 animate-bounce rounded-full bg-violet-500"
        :style="{ animationDelay: `${i * 0.15}s` }"
      />
    </div>
  </div>
</template>
