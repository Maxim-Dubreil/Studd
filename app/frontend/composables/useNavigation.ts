import { ref, computed } from "vue";

export interface NavigationItem {
  id: string;
  label: string;
  icon: string;
  href?: string;
  children?: NavigationItem[];
}

// État global partagé
const globalActiveItem = ref<string>("home");

export const useNavigation = () => {
  const setActiveItem = (itemId: string) => {
    globalActiveItem.value = itemId;
  };

  const isActive = computed(() => (itemId: string) => {
    return globalActiveItem.value === itemId;
  });

  const getActiveItemClass = computed(() => (itemId: string) => {
    return isActive.value(itemId)
      ? "bg-violet-50 dark:bg-violet-900/30 text-violet-500 dark:text-violet-400 font-medium"
      : "text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 hover:text-gray-900 dark:hover:text-white";
  });

  const getIconClass = computed(() => (itemId: string) => {
    return isActive.value(itemId)
      ? "text-violet-500 dark:text-violet-400"
      : "text-gray-500 dark:text-gray-400";
  });

  return {
    activeItem: globalActiveItem,
    setActiveItem,
    isActive,
    getActiveItemClass,
    getIconClass,
  };
};
