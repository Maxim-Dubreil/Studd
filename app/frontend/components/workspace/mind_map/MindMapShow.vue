<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="false">
    <!-- Affichage de la mindmap si elle existe -->
    <div v-if="!isLoading && content" class="relative flex items-center justify-center min-h-screen">
      <div id="map" class="w-300 h-[600px] rounded-xl"></div>
      <div class="absolute top-2 right-2 flex gap-2">
        <Button
          @click="saveMindmap"
          variant="default"
          size="sm"
          :disabled="isSaving"
        >
          <span v-if="!isSaving">Sauvegarder</span>
          <span v-else class="flex items-center gap-2">
            <svg class="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-dasharray="60" stroke-dashoffset="20" />
            </svg>
            Sauvegarde...
          </span>
        </Button>
        <Button
          @click="deleteMindmap"
          variant="destructive"
          size="sm"
        >
          Supprimer
        </Button>
      </div>
      <a
        :href="`/workspaces/${props.workspace_id}`"
        class="bg-card/50 hover:bg-card/80 absolute top-2 left-2 rounded-lg border p-2 backdrop-blur-sm"
      >
        <Icon name="arrow-left" class="h-6 w-6" />
      </a>
    </div>
    <!-- Affichage du loader pendant la génération -->
    <div v-else-if="isLoading" class="flex flex-col items-center justify-center h-[600px]">
      <svg class="animate-spin h-12 w-12 mb-4" viewBox="0 0 24 24" fill="none">
        <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-dasharray="60" stroke-dashoffset="20" />
      </svg>
      <p class="text-lg">Génération de la mindmap en cours...</p>
    </div>
    <!-- Bouton de génération si pas de mindmap -->
    <div v-else class="flex flex-col items-center justify-center h-[600px]">
      <p class="text-lg mb-4">Aucune mindmap disponible</p>
      <button @click="generate" :disabled="isLoading" class="px-4 py-2 rounded-xl text-white" :class="isLoading ? 'bg-gray-400 cursor-not-allowed' : 'bg-red-500 hover:bg-red-600'"
      >
        <span v-if="!isLoading">Générer une mindmap</span>
        <span v-else class="flex items-center gap-2">
          <svg class="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-dasharray="60" stroke-dashoffset="20" />
          </svg>
          Chargement…
        </span>
      </button>
    </div>
  </AppLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import MindElixir from 'mind-elixir'
import type { MindElixirData } from 'mind-elixir'
import type { Options } from 'mind-elixir'
import 'mind-elixir/style.css'
import Icon from '@/components/ui/icon/Icon.vue'
import { Button } from '@/components/ui/button'
import AppLayout from '../../../components/layout/AppLayout.vue'

interface props {
  workspace_id: number
  content?: MindElixirData
}
const props = defineProps<props>()

/* ---------- State ---------- */
const isLoading = ref(false)
const isSaving = ref(false)
const mindInstance = ref<any>(null)

/* ---------- Helpers ---------- */
function getCsrfToken(): string {
  const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]')
  if (!meta) throw new Error('Balise <meta name="csrf-token"> introuvable')
  return meta.content
}

/* ---------- Actions ---------- */
const generate = async (): Promise<void> => {
  isLoading.value = true
  try {
    const res = await fetch(`/workspaces/${props.workspace_id}/mindmaps`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      }
    })
    if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`)
    window.location.href = `/workspaces/${props.workspace_id}/mindmaps`
  } catch (err: unknown) {
    console.error(err instanceof Error ? err.message : 'Erreur inconnue')
  } finally {
    isLoading.value = false
  }
}

const saveMindmap = async (): Promise<void> => {
  if (!mindInstance.value) return

  isSaving.value = true
  try {
    const updatedData = mindInstance.value.getData()

    const res = await fetch(`/workspaces/${props.workspace_id}/mindmaps`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      },
      body: JSON.stringify({ content: updatedData })
    })

    if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`)

    // Afficher une notification de succès (optionnel)
    alert('Mindmap sauvegardée avec succès')
  } catch (err: unknown) {
    console.error(err instanceof Error ? err.message : 'Erreur inconnue')
    alert('Erreur lors de la sauvegarde de la mindmap')
  } finally {
    isSaving.value = false
  }
}

const deleteMindmap = async (): Promise<void> => {
  if (!confirm('Êtes-vous sûr de vouloir supprimer cette mindmap ?')) return
  isLoading.value = true
  try {
    const res = await fetch(`/workspaces/${props.workspace_id}/mindmaps`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      }
    })
    if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`)
    // Redirection vers la page du workspace après suppression
    window.location.href = `/workspaces/${props.workspace_id}/mindmaps`
  } catch (err: unknown) {
    console.error(err instanceof Error ? err.message : 'Erreur inconnue')
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  if (props.content) {
    // 1) Options : ici on cible l'élément via son sélecteur CSS
    const options = { el: '#map'}
    // 2) Création de l'instance
    const mind = new MindElixir(options)
    // 3) Données par défaut (un seul nœud "new topic")
    const data: MindElixirData = props.content
    // 4) Initialisation du mindmap
    mind.init(data)
    // 5) Stocker l'instance pour pouvoir y accéder plus tard
    mindInstance.value = mind
  }
})
</script>