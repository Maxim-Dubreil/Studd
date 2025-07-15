// app/frontend/turbo.ts
declare global {
  interface Window {
    Turbo: any;
    mountVueIslands: () => void; // Exposer la fonction globalement
  }
}

// Démarrer Turbo si disponible
if (typeof window !== 'undefined' && window.Turbo) {
  window.Turbo.start()
} else {
  // @ts-ignore
  import('@hotwired/turbo-rails').then(({ Turbo }) => {
    Turbo.start()
  }).catch(() => {
    console.log('Turbo not available')
  })
}

// Écoute les événements Turbo et remonte les composants Vue
document.addEventListener('turbo:load', () => {
  console.log('🔄 Turbo load - Remontage des composants Vue')
  if (window.mountVueIslands) {
    window.mountVueIslands()
  }
})

document.addEventListener('turbo:render', () => {
  console.log('🎨 Turbo render - Remontage des composants Vue')
  if (window.mountVueIslands) {
    window.mountVueIslands()
  }
})

document.addEventListener('turbo:before-cache', () => {
  console.log('💾 Turbo before cache')
})