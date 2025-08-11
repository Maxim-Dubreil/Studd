<script setup lang="ts">
  import AppLayout from '@/components/layout/AppLayout.vue';
  import NavbarLanding from './NavbarLanding.vue';

  interface Props {
    left: Array<{ label: string; url: string }>;
    center: Array<{ label: string; url: string }>;
    right: Array<{
      label: string;
      url: string;
      variant?: 'default' | 'gradient' | 'outline' | 'link';
      data?: Record<string, any>;
    }>;
  }
  const props = defineProps<Props>();
</script>

<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="false" :hideGradient="false">
    <div class="flex justify-center px-4">
      <NavbarLanding :left="props.left" :center="props.center" :right="props.right">
        <template #logo>
          <slot name="logo" />
        </template>
      </NavbarLanding>
    </div>
  </AppLayout>
</template>
