<script setup lang="ts">
  import AppLayout from '@/components/layout/AppLayout.vue';
  import Card from '@/components/ui/card/Card.vue';
</script>

<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="false" :hideGradient="false">
    <div class="flex justify-center px-4">
      <Card class="mt-6 w-full max-w-2xl p-6">
        <h1 class="mb-4 text-2xl font-bold">Profil</h1>
        <p class="text-gray-700 dark:text-gray-300">Bienvenue sur votre page de profil.</p>
        <!-- Add more profile related content here -->
      </Card>
    </div>
  </AppLayout>
</template>
