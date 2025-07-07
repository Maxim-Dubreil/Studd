import TestFlashCard from '@/components/test/TestFlashCard.vue';
import { createApp, defineAsyncComponent } from 'vue';

// En prod on charge les composants à la volée.
const registry: Record<string, any> = {
  UserAvatar: defineAsyncComponent(() => import('@/components/UserAvatar.vue')),
  BaseButton: defineAsyncComponent(() => import('@/components/BaseButton.vue')),

  Icon: defineAsyncComponent(() => import('@/components/Icon.vue')),

  Header: defineAsyncComponent(() => import('@/components/layout/Header.vue')),

  NavBar: defineAsyncComponent(() => import('@/components/layout/Navbar.vue')),

  NavbarLanding: defineAsyncComponent(() => import('@/components/landingPage/NavbarLanding.vue')),

  GradientBackground: defineAsyncComponent(() => import('@/components/GradientBackground.vue')),

  TestFlashCard: defineAsyncComponent(() => import('@/components/test/TestFlashCard.vue')),
  // …
};

function mountIslands() {
  document
    .querySelectorAll<HTMLElement>('[data-vue-component]')
    .forEach((el) => {
      const name = el.dataset.vueComponent!;
      const props = JSON.parse(el.dataset.vueProps || '{}');
      const Comp = registry[name];
      if (!Comp) return console.error(`Component "${name}" introuvable`);
      createApp(Comp, props).mount(el);
    });
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', mountIslands);
} else {
  mountIslands();
}
