<!-- filepath: app/frontend/components/layout/Navbar.vue -->
<script setup lang="ts">
import { ref, onMounted } from 'vue';
import Icon from '../icon/Icon.vue';

const navigationItems = ref([
  { id: 'home', label: 'Home', iconName: 'home', href: '/dashboard' }, // ← Changé vers /dashboard
  {
    id: 'workspaces',
    label: 'Workspaces',
    iconName: 'grid',
    href: '/workspaces',
  },
  { id: 'blog', label: 'Blog', iconName: 'document', href: '/blog' },
  { id: 'courses', label: 'Courses', iconName: 'book', href: '/courses' },
  {
    id: 'calendar',
    label: 'Calendar',
    iconName: 'calendar',
    href: '/calendar',
  },
]);

const activeItem = ref<string>('');

// Détecter la page active basée sur l'URL actuelle
onMounted(() => {
  const currentPath = window.location.pathname;
  const activeNav = navigationItems.value.find(
    (item) =>
      currentPath === item.href ||
      (item.href !== '/' && currentPath.startsWith(item.href))
  );
  if (activeNav) {
    activeItem.value = activeNav.id;
  } else if (currentPath === '/dashboard') {
    activeItem.value = 'home'; // ← Dashboard = Home
  }
});

const getItemClasses = (itemId: string) => {
  const baseClasses =
    'w-full flex items-center px-4 py-3 rounded-[16px] text-sm font-light transition-all duration-300 text-left hover:shadow-md';

  if (activeItem.value === itemId) {
    return `${baseClasses} bg-gradient-to-r from-violet-400 to-purple-500 text-white shadow-lg`;
  }

  return `${baseClasses} text-gray-600 dark:text-gray-300 hover:bg-white/50 dark:hover:bg-gray-700/50`;
};

const getIconClasses = (itemId: string) => {
  const baseClasses = 'w-5 h-5 mr-4';

  if (activeItem.value === itemId) {
    return `${baseClasses} text-white`;
  }

  return `${baseClasses} text-gray-500 dark:text-gray-400`;
};
</script>

<template>
  <div
    class="h-full flex flex-col bg-white/70 dark:bg-gray-800/70 backdrop-blur-lg border-r border-white/20 dark:border-gray-700/30">
    <!-- Logo -->
    <div class="p-6 border-b border-white/20 dark:border-gray-700/30">
      <h1 class="text-2xl font-bold text-gray-700 dark:text-gray-200">
        StudyApp
      </h1>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 px-4 py-6 space-y-2">
      <a v-for="item in navigationItems" :key="item.id" :href="item.href" :class="getItemClasses(item.id)">
        <Icon :name="item.iconName" :class="getIconClasses(item.id)" />
        {{ item.label }}
      </a>
    </nav>

    <!-- Section du bas (profil utilisateur, paramètres, etc.) -->
    <div class="p-4 border-t border-white/20 dark:border-gray-700/30">
      <div
        class="flex items-center space-x-3 p-3 rounded-[12px] hover:bg-white/50 dark:hover:bg-gray-700/50 transition-all duration-300 cursor-pointer">
        <div
          class="w-8 h-8 bg-gradient-to-r from-violet-400 to-purple-500 rounded-full flex items-center justify-center">
          <Icon name="users" class="w-4 h-4 text-white" />
        </div>
        <div class="flex-1">
          <p class="text-sm font-medium text-gray-700 dark:text-gray-200">
            Profile
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
