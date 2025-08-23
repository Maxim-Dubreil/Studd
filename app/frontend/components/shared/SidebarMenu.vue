<script setup lang="ts">
import { Icon } from '@/components/ui/icon';
import { onMounted, ref } from 'vue';

const navigationItems = ref([
  { id: 'home', label: 'Home', iconName: 'home', href: '/' },
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
      currentPath === item.href || (item.href !== '/' && currentPath.startsWith(item.href))
  );
  if (activeNav) {
    activeItem.value = activeNav.id;
  } else if (currentPath === '/' || currentPath === '/dashboard') {
    activeItem.value = 'home';
  }
});

const getItemClasses = (itemId: string) => {
  const baseClasses =
    'w-full flex items-center px-6 py-4 rounded-2xl text-sm font-medium transition-all duration-300 text-left hover:shadow-lg group';

  if (activeItem.value === itemId) {
    return `${baseClasses} bg-gradient-to-r from-violet-500 to-purple-600 dark:from-violet-600 dark:to-purple-700 text-white shadow-xl transform hover:scale-[1.02]`;
  }

  return `${baseClasses} text-gray-600 dark:text-gray-300 hover:bg-violet-50 dark:hover:bg-violet-900/30 hover:text-violet-600 dark:hover:text-violet-400`;
};

const getIconClasses = (itemId: string) => {
  const baseClasses = 'w-5 h-5 mr-4 transition-all duration-300';

  if (activeItem.value === itemId) {
    return `${baseClasses} text-white`;
  }

  return `${baseClasses} text-gray-500 dark:text-gray-400 group-hover:text-violet-600 dark:group-hover:text-violet-400`;
};
</script>

<template>
  <div
    class="flex h-full w-60 flex-col rounded-2xl border border-white/20 bg-white/80 shadow-xl backdrop-blur-xl transition-all duration-300 dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-2xl">
    <!-- Logo -->
    <div class="border-b border-gray-100 p-6 dark:border-slate-700/50">
      <h1 class="text-xl font-bold text-black transition-colors duration-300 dark:text-white">
        StudyApp
      </h1>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 space-y-2 px-4 py-4">
      <a v-for="item in navigationItems" :key="item.id" :href="item.href" :class="getItemClasses(item.id)">
        <Icon :name="item.iconName" :class="getIconClasses(item.id)" />
        {{ item.label }}
      </a>
    </nav>

    <!-- Section du bas -->
    <div class="p-4"></div>
  </div>
</template>
