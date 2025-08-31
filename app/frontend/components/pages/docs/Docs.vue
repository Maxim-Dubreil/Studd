<script setup lang="ts">
  import AppLayout from '@/components/layout/AppLayout.vue';
  import NavbarLanding from '../landingPage/NavbarLanding.vue';

  interface NavItem {
    label: string;
    url: string;
    variant?: 'default' | 'gradient' | 'outline' | 'link';
    data?: Record<string, any>;
  }
  const props = defineProps<{ left: NavItem[]; center: NavItem[]; right: NavItem[] }>();
</script>

<template>
  <AppLayout :hideSidebar="true" :hideToggle="false" :hideGradient="false">
    <div class="flex justify-center px-4">
      <NavbarLanding :left="props.left" :center="props.center" :right="props.right" />
    </div>

    <section class="mx-auto max-w-screen-xl px-4 py-14">
      <h1 class="text-3xl font-bold md:text-5xl">Documentation</h1>
      <p class="text-muted-foreground mt-3 md:text-lg">Guides d’utilisation, FAQ, et exemples.</p>
      <!-- Ton contenu docs ici -->
    </section>
  </AppLayout>
</template>
