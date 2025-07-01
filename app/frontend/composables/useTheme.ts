import { ref, computed, watch } from "vue";

export type Theme = "light" | "dark";

export const useTheme = () => {
  const currentTheme = ref<Theme>("light");

  const initTheme = () => {
    const stored = localStorage.getItem("theme") as Theme;
    const prefersDark = window.matchMedia(
      "(prefers-color-scheme: dark)"
    ).matches;

    currentTheme.value = stored || (prefersDark ? "dark" : "light");
    applyTheme();
  };

  const applyTheme = () => {
    if (currentTheme.value === "dark") {
      document.documentElement.classList.add("dark");
    } else {
      document.documentElement.classList.remove("dark");
    }
  };

  const toggleTheme = () => {
    currentTheme.value = currentTheme.value === "light" ? "dark" : "light";
  };

  const setTheme = (theme: Theme) => {
    currentTheme.value = theme;
  };

  const isDark = computed(() => currentTheme.value === "dark");

  watch(currentTheme, (newTheme) => {
    localStorage.setItem("theme", newTheme);
    applyTheme();
  });

  return {
    currentTheme,
    isDark,
    toggleTheme,
    setTheme,
    initTheme,
  };
};
