<script setup lang="ts">
import { ref, onMounted } from 'vue';
import AppLayout from '@/components/layout/AppLayout.vue';
import DashboardContent from './DashboardContent.vue';
import DashboardWidgets from './DashboardWidgets.vue';

interface Props {
  user?: {
    name: string;
    email: string;
    avatar?: string;
  };
}

const props = withDefaults(defineProps<Props>(), {
  user: () => ({
    name: 'Étudiant Demo',
    email: 'demo@studyapp.com',
    avatar: undefined,
  }),
});
</script>

<template>
  <AppLayout
    :hideSidebar="false"
    :hideTopNav="false"
    :hideToggle="true"
    :user="props.user"
  >
    <div class="flex flex-1 overflow-hidden">
      <!-- Dashboard Content -->
      <DashboardContent />

      <!-- Sidebar droite -->
      <div class="flex-shrink-0">
        <DashboardWidgets />
      </div>
    </div>
  </AppLayout>
</template>
