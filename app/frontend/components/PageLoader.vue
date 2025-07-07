<!-- app/frontend/components/PageLoader.vue -->
<script setup lang="ts">
interface Props {
  message?: string;
  showLogo?: boolean;
}

withDefaults(defineProps<Props>(), {
  message: 'Chargement...',
  showLogo: true,
});
</script>

<template>
  <div class="flex flex-col items-center space-y-6">
    <!-- Logo avec animation -->
    <div v-if="showLogo" class="flex justify-center">
      <div
        class="w-16 h-16 bg-gradient-to-r from-violet-500 to-purple-500 rounded-2xl flex items-center justify-center"
      >
        <span class="text-white font-bold text-2xl animate-pulse">S</span>
      </div>
    </div>

    <!-- Spinner élégant -->
    <div class="relative">
      <div
        class="w-12 h-12 rounded-full border-4 border-gray-200 dark:border-gray-700"
      ></div>
      <div
        class="w-12 h-12 rounded-full border-4 border-violet-500 border-t-transparent animate-spin absolute top-0 left-0"
      ></div>
    </div>

    <!-- Message -->
    <p class="text-gray-600 dark:text-gray-300 font-medium text-center">
      {{ message }}
    </p>

    <!-- Points animés -->
    <div class="flex space-x-1">
      <div
        v-for="i in 3"
        :key="i"
        class="w-2 h-2 bg-violet-500 rounded-full animate-bounce"
        :style="{ animationDelay: `${i * 0.15}s` }"
      />
    </div>
  </div>
</template>
