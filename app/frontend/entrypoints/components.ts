import { createApp, defineAsyncComponent } from 'vue';

const registry: Record<string, any> = {
  // Layout
  AppLayout: defineAsyncComponent(() => import('@/components/layout/AppLayout.vue')),

  // Shared Components
  GradientBackground: defineAsyncComponent(
    () => import('@/components/shared/GradientBackground.vue')
  ),
  ThemeToggle: defineAsyncComponent(() => import('@/components/shared/ThemeToggle.vue')),

  // UI Components
  UserAvatar: defineAsyncComponent(() => import('@/components/ui/avatar/UserAvatar.vue')),
  Icon: defineAsyncComponent(() => import('@/components/ui/icon/Icon.vue')),

  // Pages components
    // Landing Page
  LandingPage: defineAsyncComponent(
    () => import('@/components/pages/landingPage/LandingPage.vue')
  ),
  NavbarLanding: defineAsyncComponent(
    () => import('@/components/pages/landingPage/NavbarLanding.vue')
  ),

  // Dashboard
  Dashboard: defineAsyncComponent(() => import('@/components/dashboard/Dashboard.vue')),
  DashboardContent: defineAsyncComponent(
    () => import('@/components/dashboard/DashboardContent.vue')
  ),
  DashboardWidgets: defineAsyncComponent(
    () => import('@/components/dashboard/DashboardWidgets.vue')
  ),

  // Workspace
  WorkspaceShow: defineAsyncComponent(
    () => import('@/components/workspace/Show/WorkspaceShow.vue')
  ),
  CreateFlashCard: defineAsyncComponent(
    () => import('@/components/workspace/flashCard/CreateFlashCard.vue')
  ),
  WorkspaceIndex: defineAsyncComponent(
    () => import('@/components/workspace/Index/WorkspaceIndex.vue')
  ),
  FlashCardSet: defineAsyncComponent(
    () => import('@/components/workspace/flashCard/FlashCardSet.vue')
  ),
  MindMapShow: defineAsyncComponent(
    () => import('@/components/workspace/mind_map/MindMapShow.vue')
  ),

  // Auth
  RegistrationForm: defineAsyncComponent(() => import('@/components/auth/RegistrationForm.vue')),
  LoginForm: defineAsyncComponent(() => import('@/components/auth/LoginForm.vue')),
  PasswordResetForm: defineAsyncComponent(() => import('@/components/auth/PasswordResetForm.vue')),
};

function mountIslands() {
  // Nettoye les anciennes instances Vue avant de remonter
  document.querySelectorAll<HTMLElement>('[data-vue-component]').forEach((el) => {
    if ((el as any).__vue_app__) {
      (el as any).__vue_app__.unmount();
      delete (el as any).__vue_app__;
    }
  });

  // Monter les nouvelles instances
  document.querySelectorAll<HTMLElement>('[data-vue-component]').forEach((el) => {
    const name = el.dataset.vueComponent!;
    const props = JSON.parse(el.dataset.vueProps || '{}');
    const Comp = registry[name];
    if (!Comp) return console.error(`Component "${name}" introuvable`);

    const app = createApp(Comp, props);
    app.mount(el);
    (el as any).__vue_app__ = app; // Stocker la référence pour le nettoyage
  });
}

// Expose la fonction globalement pour Turbo
window.mountVueIslands = mountIslands;

// Montage initial
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', mountIslands);
} else {
  mountIslands();
}
