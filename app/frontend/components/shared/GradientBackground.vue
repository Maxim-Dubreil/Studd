<!-- app/frontend/components/GradientBackground.vue -->
<script setup lang="ts"></script>

<template>
  <!-- Calque plein-écran, immobile et derrière tout -->
  <div
    class="fixed inset-0 -z-10 overflow-hidden bg-gradient-to-br from-violet-100 via-blue-50 to-purple-100 transition-colors duration-500 dark:from-slate-900 dark:via-violet-900 dark:to-blue-900"
  >
    <!-- Voile flou pour le mode clair -->
    <div
      class="absolute inset-0 bg-gradient-to-br from-violet-200/30 via-blue-100/20 to-purple-200/30 backdrop-blur-3xl transition-all duration-500 dark:from-violet-900/40 dark:via-blue-900/30 dark:to-purple-900/40"
    />

    <!-- Ronds décoratifs animés -->
    <div
      class="absolute top-0 left-1/4 h-96 w-96 animate-pulse rounded-full bg-gradient-to-r from-violet-300/20 to-blue-300/20 blur-3xl transition-all duration-500 dark:from-violet-600/30 dark:to-blue-500/25"
    />
    <div
      class="absolute right-1/4 bottom-0 h-96 w-96 animate-pulse rounded-full bg-gradient-to-r from-purple-300/20 to-pink-300/20 blur-3xl transition-all duration-500 dark:from-purple-700/25 dark:to-indigo-600/30"
      style="animation-delay: 1s"
    />

    <!-- Orbe central pour le dark mode -->
    <div
      class="bg-gradient-radial absolute top-1/2 left-1/2 h-[600px] w-[600px] -translate-x-1/2 -translate-y-1/2 transform rounded-full from-transparent via-violet-800/5 to-transparent opacity-50 blur-3xl transition-all duration-500 dark:from-transparent dark:via-violet-400/10 dark:to-transparent"
    />
  </div>
</template>

<style scoped>
  @keyframes pulse {
    0%,
    100% {
      opacity: 0.3;
      transform: scale(1);
    }
    50% {
      opacity: 0.6;
      transform: scale(1.05);
    }
  }

  .animate-pulse {
    animation: pulse 4s ease-in-out infinite;
  }

  .bg-gradient-radial {
    background: radial-gradient(circle, var(--tw-gradient-stops));
  }
</style>
