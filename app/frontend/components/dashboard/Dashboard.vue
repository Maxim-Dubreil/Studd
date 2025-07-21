<script setup lang="ts">
import { ref, onMounted } from "vue";
import SidebarMenu from "./SidebarMenu.vue";
import DashboardContent from "./DashboardContent.vue";
import DashboardWidgets from "./DashboardWidgets.vue";
import TopNav from "./TopNav.vue";
import GradientBackground from "../GradientBackground.vue";
import { useTheme } from "../../composables/useTheme";

interface Props {
  user?: {
    name: string;
    email: string;
    avatar?: string;
  };
}

const props = withDefaults(defineProps<Props>(), {
  user: () => ({
    name: "Étudiant Demo",
    email: "demo@studyapp.com",
    avatar: undefined
  })
});

const { initializeTheme } = useTheme();

onMounted(() => {
  initializeTheme();
});
</script>

<template>
  <!-- Background avec dégradé -->
  <GradientBackground />
  
  <!-- Layout principal -->
  <div class="min-h-screen relative">
    <!-- Overlay pour améliorer le contraste en dark mode -->
    <div class="absolute inset-0 bg-white/5 dark:bg-black/20 backdrop-blur-[1px] transition-all duration-500"></div>
    
    <!-- Structure en 3 parties -->
    <div class="flex h-screen relative z-10">
      <!-- Sidebar gauche -->
      <div class="flex-shrink-0 p-4">
        <SidebarMenu />
      </div>

      <!-- Zone centrale -->
      <div class="flex-1 flex flex-col">
        <!-- TopNav -->
        <div class="flex-shrink-0">
          <TopNav :user="props.user" />
        </div>

        <!-- Contenu principal -->
        <div class="flex-1 flex overflow-hidden">
          <!-- Dashboard Content -->
          <DashboardContent />

          <!-- Sidebar droite -->
          <div class="flex-shrink-0">
            <DashboardWidgets />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@media (max-width: 768px) {
  .flex {
    flex-direction: column;
  }
  
  .sidebar {
    position: fixed;
    top: 0;
    left: -100%;
    transition: left 0.3s ease;
    z-index: 50;
  }
  
  .sidebar.open {
    left: 0;
  }
}
</style> 