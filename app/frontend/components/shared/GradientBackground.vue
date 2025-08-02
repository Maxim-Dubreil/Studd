<!-- app/frontend/components/GradientBackground.vue -->
<script setup lang="ts"></script>

<template>
  <!-- Calque plein-écran, immobile et derrière tout -->
  <div
    class="fixed inset-0 -z-10 overflow-hidden bg-gradient-to-br from-violet-100 via-blue-50 to-purple-100 dark:from-slate-900 dark:via-violet-900 dark:to-blue-900 transition-colors duration-500"
  >
    <!-- Voile flou pour le mode clair -->
    <div
      class="absolute inset-0 bg-gradient-to-br from-violet-200/30 via-blue-100/20 to-purple-200/30 dark:from-violet-900/40 dark:via-blue-900/30 dark:to-purple-900/40 backdrop-blur-3xl transition-all duration-500"
    />

    <!-- Ronds décoratifs animés -->
    <div
      class="absolute top-0 left-1/4 w-96 h-96 bg-gradient-to-r from-violet-300/20 to-blue-300/20 dark:from-violet-600/30 dark:to-blue-500/25 rounded-full blur-3xl animate-pulse transition-all duration-500"
    />
    <div
      class="absolute bottom-0 right-1/4 w-96 h-96 bg-gradient-to-r from-purple-300/20 to-pink-300/20 dark:from-purple-700/25 dark:to-indigo-600/30 rounded-full blur-3xl animate-pulse transition-all duration-500"
      style="animation-delay: 1s"
    />

    <!-- Orbe central pour le dark mode -->
    <div
      class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-gradient-radial from-transparent via-violet-800/5 to-transparent dark:from-transparent dark:via-violet-400/10 dark:to-transparent rounded-full blur-3xl opacity-50 transition-all duration-500"
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
