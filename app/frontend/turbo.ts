export {}; // Ensure this file is a module

declare global {
  interface Window {
    Turbo: any;
    mountVueIslands: () => void; // Exposer la fonction globalement
  }
}

// Démarrer Turbo si disponible
if (typeof window !== 'undefined' && (window as any).Turbo) {
  (window as any).Turbo.start();
} else {
  // Import statique pour éviter les problèmes de résolution Vite
  try {
    import('@hotwired/turbo-rails')
      .then((turboModule) => {
        const { Turbo } = turboModule;
        if (Turbo) {
          Turbo.start();
        }
      })
      .catch((error) => {
        console.warn('Turbo not available:', error);
      });
  } catch (error) {
    console.warn('Failed to import Turbo:', error);
  }
}

// Écoute les événements Turbo et remonte les composants Vue
document.addEventListener('turbo:load', () => {
  console.log('🔄 Turbo load - Remontage des composants Vue');
  if (window.mountVueIslands) {
    window.mountVueIslands();
  }
});

document.addEventListener('turbo:render', () => {
  console.log('🎨 Turbo render - Remontage des composants Vue');
  if (window.mountVueIslands) {
    window.mountVueIslands();
  }
});

document.addEventListener('turbo:before-cache', () => {
  console.log('💾 Turbo before cache');
});
