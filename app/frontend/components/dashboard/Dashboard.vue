<script setup lang="ts">
  import AppLayout from '@/components/layout/AppLayout.vue';
  import DashboardContent from './DashboardContent.vue';
  import DashboardWidgets from './DashboardWidgets.vue';
  import { withDefaults } from 'vue';

  interface Props {
    user?: {
      name: string;
      email: string;
      avatar?: string;
    };
    dashboard_stats?: any;
  }

  const props = withDefaults(defineProps<Props>(), {
    user: () => ({
      name: 'Student Demo',
      email: 'demo@studd.com',
      avatar: undefined,
    }),
    dashboard_stats: () => null,
  });
  
  console.log('Dashboard props received:', {
    user: props.user,
    dashboard_stats: props.dashboard_stats
  });
</script>

<template>
  <AppLayout :hideSidebar="false" :hideTopNav="false" :hideToggle="true" :user="props.user">
    <div class="flex flex-1 overflow-hidden">
      <!-- Dashboard Content -->
      <DashboardContent :dashboard-stats="props.dashboard_stats" />

      <!-- Sidebar droite -->
      <div class="flex-shrink-0">
        <DashboardWidgets />
      </div>
    </div>
  </AppLayout>
</template>
