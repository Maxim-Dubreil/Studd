import { ref, watch, onMounted } from 'vue';

const isDarkMode = ref(false);

export const useTheme = () => {
  const initializeTheme = () => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
      isDarkMode.value = savedTheme === 'dark';
    } else {
      isDarkMode.value = window.matchMedia('(prefers-color-scheme: dark)').matches;
    }
    
    applyTheme();
  };

  const applyTheme = () => {
    const html = document.documentElement;
    if (isDarkMode.value) {
      html.classList.add('dark');
      html.setAttribute('data-theme', 'dark');
    } else {
      html.classList.remove('dark');
      html.setAttribute('data-theme', 'light');
    }
  };

  const toggleTheme = () => {
    isDarkMode.value = !isDarkMode.value;
    localStorage.setItem('theme', isDarkMode.value ? 'dark' : 'light');
    applyTheme();
  };

  const setTheme = (theme: 'light' | 'dark') => {
    isDarkMode.value = theme === 'dark';
    localStorage.setItem('theme', theme);
    applyTheme();
  };

  // Watcher pour les changements de thème
  watch(isDarkMode, () => {
    applyTheme();
  });

  return {
    isDarkMode,
    toggleTheme,
    setTheme,
    initializeTheme
  };
};
