<script setup lang="ts">
import { ref, onMounted } from "vue";
import Icon from "../Icon.vue";

const navigationItems = ref([
  { id: "home", label: "Home", iconName: "home", href: "/" },
  { id: "workspaces", label: "Workspaces", iconName: "grid", href: "/workspaces" },
  { id: "blog", label: "Blog", iconName: "document", href: "/blog" },
  { id: "courses", label: "Courses", iconName: "book", href: "/courses" },
  { id: "calendar", label: "Calendar", iconName: "calendar", href: "/calendar" },
]);

const activeItem = ref<string>("");

// Détecter la page active basée sur l'URL actuelle
onMounted(() => {
  const currentPath = window.location.pathname;
  const activeNav = navigationItems.value.find(item => 
    currentPath === item.href || 
    (item.href !== "/" && currentPath.startsWith(item.href))
  );
  if (activeNav) {
    activeItem.value = activeNav.id;
  } else if (currentPath === "/" || currentPath === "/dashboard") {
    activeItem.value = "home";
  }
});

const getItemClasses = (itemId: string) => {
  const baseClasses = "w-full flex items-center px-6 py-4 rounded-2xl text-sm font-medium transition-all duration-300 text-left hover:shadow-lg group";
  
  if (activeItem.value === itemId) {
    return `${baseClasses} bg-gradient-to-r from-violet-500 to-purple-600 dark:from-violet-600 dark:to-purple-700 text-white shadow-xl transform hover:scale-[1.02]`;
  }
  
  return `${baseClasses} text-gray-600 dark:text-gray-300 hover:bg-violet-50 dark:hover:bg-violet-900/30 hover:text-violet-600 dark:hover:text-violet-400`;
};

const getIconClasses = (itemId: string) => {
  const baseClasses = "w-5 h-5 mr-4 transition-all duration-300";
  
  if (activeItem.value === itemId) {
    return `${baseClasses} text-white`;
  }
  
  return `${baseClasses} text-gray-500 dark:text-gray-400 group-hover:text-violet-600 dark:group-hover:text-violet-400`;
};
</script>

<template>
  <div class="w-60 h-full bg-white/80 dark:bg-slate-800/90 backdrop-blur-xl rounded-2xl shadow-xl dark:shadow-2xl border border-white/20 dark:border-slate-700/50 flex flex-col transition-all duration-300">
    <!-- Logo -->
    <div class="p-6 border-b border-gray-100 dark:border-slate-700/50">
      <h1 class="text-xl font-bold text-black dark:text-white transition-colors duration-300">StudyApp</h1>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 px-4 space-y-2 py-4">
      <a
        v-for="item in navigationItems"
        :key="item.id"
        :href="item.href"
        :class="getItemClasses(item.id)"
      >
        <Icon 
          :name="item.iconName" 
          :class="getIconClasses(item.id)"
        />
        {{ item.label }}
      </a>
    </nav>

    <!-- Section du bas -->
    <div class="p-4 border-t border-gray-100 dark:border-slate-700/50">
      <div class="flex items-center space-x-3 p-3 rounded-xl hover:bg-gray-50 dark:hover:bg-slate-700/50 transition-all duration-300 cursor-pointer group">
        <div class="w-8 h-8 bg-gradient-to-r from-violet-400 to-purple-500 dark:from-violet-500 dark:to-purple-600 rounded-full flex items-center justify-center shadow-lg">
          <Icon name="users" class="w-4 h-4 text-white" />
        </div>
        <div class="flex-1">
          <p class="text-sm font-medium text-gray-700 dark:text-gray-200 group-hover:text-gray-900 dark:group-hover:text-white transition-colors duration-300">Profil</p>
        </div>
      </div>
    </div>
  </div>
</template> 