<script setup lang="ts">
import { ref, onMounted } from "vue";
import DashboardLayout from "@/components/layout/DashboardLayout.vue";
import DashboardHeader from "@/components/layout/DashboardHeader.vue";
import DashboardPage from "@/components/pages/DashboardPage.vue";
import WorkspacePage from "@/components/pages/WorkspacePage.vue";
import { useNavigation } from "@/composables/useNavigation";
import { useTheme } from "@/composables/useTheme";

defineProps<{ msg?: string }>();

const { activeItem } = useNavigation();
const { initTheme } = useTheme();

// Initialiser le thème au montage du composant
onMounted(() => {
  initTheme();
});

// Liste des pages disponibles
const pages = {
  home: {
    component: DashboardPage,
    title: "Dashboard",
  },
  workspaces: {
    component: WorkspacePage,
    title: "Workspaces",
  },
  blog: {
    component: DashboardPage, // Temporairement le même composant
    title: "Blog",
  },
  courses: {
    component: DashboardPage, // Temporairement le même composant
    title: "Courses",
  },
  calendar: {
    component: DashboardPage, // Temporairement le même composant
    title: "Calendar",
  },
};

// Fonction pour obtenir le composant de la page active
const getCurrentPageComponent = () => {
  const component =
    pages[activeItem.value as keyof typeof pages]?.component || DashboardPage;
  return component;
};

// Fonction pour obtenir le titre de la page active
const getCurrentPageTitle = () => {
  const title =
    pages[activeItem.value as keyof typeof pages]?.title || "Dashboard";
  return title;
};
</script>

<template>
  <DashboardLayout>
    <template #header>
      <DashboardHeader :title="getCurrentPageTitle()" />
    </template>

    <template #default>
      <component :is="getCurrentPageComponent()" />
    </template>
  </DashboardLayout>

</template>
