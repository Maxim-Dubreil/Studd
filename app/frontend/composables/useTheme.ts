import { ref, onMounted, onBeforeUnmount } from 'vue';
import { getTheme, setTheme, toggleTheme as toggle, type Theme } from '@/lib/theme';

const themeRef = ref<Theme>(getTheme()); // 1 seule instance (module scope)

export function useTheme() {
  const handler = (e: Event) => {
    themeRef.value = (e as CustomEvent<Theme>).detail;
  };

  onMounted(() => {
    // maj initiale (au cas où)
    themeRef.value = getTheme();
    window.addEventListener('theme:change', handler);
  });

  onBeforeUnmount(() => {
    window.removeEventListener('theme:change', handler);
  });

  const setTheme = (t: Theme) => {
    // met à jour DOM + localStorage + event
    themeRef.value = t;
    setThemeDom(t);
  };

  const setThemeDom = (t: Theme) => {
    // réutilise ton util global
    setTheme(t);
  };

  const toggleTheme = () => {
    toggle();
    themeRef.value = getTheme();
  };

  return { theme: themeRef, setTheme, toggleTheme };
}