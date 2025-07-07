<!-- app/frontend/components/GradientBackground.vue -->
<script setup lang="ts"></script>

<template>
  <!-- Calque plein-écran, immobile et derrière tout -->
  <div
    class="fixed inset-0 -z-10 overflow-hidden
           bg-gradient-to-br from-violet-100 via-blue-50 to-purple-100
           dark:from-gray-900 dark:via-gray-800 dark:to-purple-900
           transition-colors duration-300"
  >
    <!-- Voile flou -->
    <div
      class="absolute inset-0 bg-gradient-to-br
             from-violet-200/30 via-blue-100/20 to-purple-200/30
             dark:from-violet-800/20 dark:via-blue-900/10 dark:to-purple-800/20
             backdrop-blur-3xl"
    />

    <!-- Ronds décoratifs -->
    <div
      class="absolute top-0 left-1/4 w-96 h-96
             bg-gradient-to-r from-violet-300/20 to-blue-300/20
             dark:from-violet-600/10 dark:to-blue-600/10
             rounded-full blur-3xl"
    />
    <div
      class="absolute bottom-0 right-1/4 w-96 h-96
             bg-gradient-to-r from-purple-300/20 to-pink-300/20
             dark:from-purple-600/10 dark:to-pink-600/10
             rounded-full blur-3xl"
    />
  </div>
</template>
