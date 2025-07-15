import TestFlashCard from '@/components/test/TestFlashCard.vue';
import { createApp, defineAsyncComponent } from 'vue';

const registry: Record<string, any> = {
  UserAvatar: defineAsyncComponent(() => import('@/components/UserAvatar.vue')),
  BaseButton: defineAsyncComponent(() => import('@/components/BaseButton.vue')),
  Icon: defineAsyncComponent(() => import('@/components/Icon.vue')),
  Header: defineAsyncComponent(() => import('@/components/layout/Header.vue')),
  NavBar: defineAsyncComponent(() => import('@/components/layout/Navbar.vue')),

  NavbarLanding: defineAsyncComponent(
    () => import('@/components/landingPage/NavbarLanding.vue')
  ),

  GradientBackground: defineAsyncComponent(
    () => import('@/components/GradientBackground.vue')
  ),

  // Composants Dashboard
  Dashboard: defineAsyncComponent(
    () => import('@/components/dashboard/Dashboard.vue')
  ),
  SidebarMenu: defineAsyncComponent(
    () => import('@/components/dashboard/SidebarMenu.vue')
  ),
  DashboardContent: defineAsyncComponent(
    () => import('@/components/dashboard/DashboardContent.vue')
  ),
  DashboardWidgets: defineAsyncComponent(
    () => import('@/components/dashboard/DashboardWidgets.vue')
  ),
  TopNav: defineAsyncComponent(
    () => import('@/components/dashboard/TopNav.vue')
  ),

  // Composants Workspaces
  WorkspacesPage: defineAsyncComponent(
    () => import('@/components/workspaces/WorkspacesPage.vue')
  ),
  WorkspaceCard: defineAsyncComponent(
    () => import('@/components/workspaces/WorkspaceCard.vue')
  ),
  // …
};

function mountIslands() {
  // Nettoyer les anciennes instances Vue avant de remonter
  document
    .querySelectorAll<HTMLElement>('[data-vue-component]')
    .forEach((el) => {
      if ((el as any).__vue_app__) {
        (el as any).__vue_app__.unmount();
        delete (el as any).__vue_app__;
      }
    });

  // Monter les nouvelles instances
  document
    .querySelectorAll<HTMLElement>('[data-vue-component]')
    .forEach((el) => {
      const name = el.dataset.vueComponent!;
      const props = JSON.parse(el.dataset.vueProps || '{}');
      const Comp = registry[name];
      if (!Comp) return console.error(`Component "${name}" introuvable`);

      const app = createApp(Comp, props);
      app.mount(el);
      (el as any).__vue_app__ = app; // Stocker la référence pour le nettoyage
    });
}

// Exposer la fonction globalement pour Turbo
window.mountVueIslands = mountIslands;

// Montage initial
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', mountIslands);
} else {
  mountIslands();
}
