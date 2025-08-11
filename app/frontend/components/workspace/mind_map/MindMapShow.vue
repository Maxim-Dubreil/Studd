<template>
  <!-- Affichage de la mindmap si elle existe -->
  <div v-if="!isLoading && content" class="relative">
    <!-- conteneur avec hauteur fixe pour Vue Flow -->
    <div class="w-300 h-[600px] rounded-xl overflow-hidden">
      <VueFlow
        v-model:nodes="nodes"
        v-model:edges="edges"
        :fit-view-on-init="true"
        :nodes-draggable="true"
        :nodes-connectable="false"
        :elements-selectable="true"
      >
        <Background />
        <Controls />
        <!-- <MiniMap /> (optionnel) -->
      </VueFlow>
    </div>

    <button
      @click="deleteMindmap"
      class="absolute top-2 right-2 px-3 py-1 bg-red-500 hover:bg-red-600 text-white rounded-lg shadow-md"
    >
      Supprimer
    </button>
  </div>

  <!-- Affichage du loader pendant la génération -->
  <div v-else-if="isLoading" class="flex flex-col items-center justify-center h-[600px]">
    <svg class="animate-spin h-12 w-12 mb-4" viewBox="0 0 24 24" fill="none">
      <circle
        cx="12" cy="12" r="10"
        stroke="currentColor" stroke-width="4"
        stroke-linecap="round"
        stroke-dasharray="60"
        stroke-dashoffset="20"
      />
    </svg>
    <p class="text-lg">Génération de la mindmap en cours...</p>
  </div>

  <!-- Bouton de génération si pas de mindmap -->
  <div v-else class="flex flex-col items-center justify-center h-[600px]">
    <p class="text-lg mb-4">Aucune mindmap disponible</p>
    <button
      @click="generate"
      :disabled="isLoading"
      class="px-4 py-2 rounded-xl text-white"
      :class="isLoading ? 'bg-gray-400 cursor-not-allowed' : 'bg-red-500 hover:bg-red-600'"
    >
      <span v-if="!isLoading">Générer une mindmap</span>
      <span v-else class="flex items-center gap-2">
        <svg class="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
          <circle
            cx="12" cy="12" r="10"
            stroke="currentColor" stroke-width="4"
            stroke-linecap="round"
            stroke-dasharray="60"
            stroke-dashoffset="20"
          />
        </svg>
        Chargement…
      </span>
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'
import { VueFlow } from '@vue-flow/core'
import { Background } from '@vue-flow/background'
import { Controls } from '@vue-flow/controls'
import type { Node, Edge } from '@vue-flow/core'
import '@vue-flow/core/dist/style.css'
import '@vue-flow/core/dist/theme-default.css'
import { NodeToolbar } from '@vue-flow/node-toolbar'


interface Props {
  workspace_id: number
  content?: { nodes: Node[]; edges: Edge[] }
}
const props = defineProps<Props>()

const isLoading = ref(false)

// on crée des refs pour pouvoir éditer (drag) sans modifier props
const nodes = ref<Node[]>(props.content?.nodes ?? [])
const edges = ref<Edge[]>(props.content?.edges ?? [])

// si le serveur renvoie de nouvelles données, on remplace
watch(
  () => props.content,
  (val) => {
    if (val) {
      nodes.value = [...val.nodes]
      edges.value = [...val.edges]
    } else {
      nodes.value = []
      edges.value = []
    }
  },
  { immediate: true }
)

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
    window.location.href = `/workspaces/${props.workspace_id}/mindmaps`
  } catch (err: unknown) {
    console.error(err instanceof Error ? err.message : 'Erreur inconnue')
  } finally {
    isLoading.value = false
  }
}

// (facultatif) si tu veux ajuster après montage (fitView programmatique, etc.)
onMounted(() => {
  // rien à initialiser : Vue Flow lit nodes/edges réactifs
})
</script>
