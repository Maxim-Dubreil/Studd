<template>
  <div
    class="h-screen w-64 bg-white dark:bg-gray-800 rounded-r-[20px] shadow-lg flex flex-col font-['Inter',sans-serif] m-4 ml-0 transition-colors duration-300"
  >
    <!-- Header avec logo -->
    <div class="p-6 border-b border-gray-100 dark:border-gray-700">
      <h1 class="text-2xl font-bold text-black dark:text-white">StudyApp</h1>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 px-6 py-8 space-y-3">
      <NavItem
        v-for="item in navigationItems"
        :key="item.id"
        :id="item.id"
        :label="item.label"
        :icon-name="item.iconName"
        @click="handleNavClick"
      />
    </nav>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import {
  useNavigation,
  type NavigationItem,
} from "../../composables/useNavigation";
import NavItem from "../ui/NavItem.vue";

const { setActiveItem } = useNavigation();

const navigationItems = ref<(NavigationItem & { iconName: string })[]>([
  {
    id: "home",
    label: "Home",
    icon: "home",
    iconName: "home",
  },
  {
    id: "workspaces",
    label: "Workspaces",
    icon: "grid",
    iconName: "grid",
  },
  {
    id: "blog",
    label: "Blog",
    icon: "document",
    iconName: "document",
  },
  {
    id: "courses",
    label: "Courses",
    icon: "book",
    iconName: "book",
  },
  {
    id: "calendar",
    label: "Calendar",
    icon: "calendar",
    iconName: "calendar",
  },
]);

const handleNavClick = (itemId: string) => {
  setActiveItem(itemId);
};
</script>
