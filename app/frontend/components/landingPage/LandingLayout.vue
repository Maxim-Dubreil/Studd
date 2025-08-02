<script setup lang="ts">
import { ref, onMounted } from 'vue';
import NavbarLanding from './NavbarLanding.vue';
import AppLayout from '@/components/layout/AppLayout.vue';

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
    <NavbarLanding :left="props.left" :center="props.center" :right="props.right">
      <template #logo>
        <slot name="logo" />
      </template>
    </NavbarLanding>
  </AppLayout>
</template>
