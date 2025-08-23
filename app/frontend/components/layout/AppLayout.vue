<!-- AppLayout.vue (simplifié, propre) -->
<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import GradientBackground from '@/components/shared/GradientBackground.vue'
import SidebarMenuV2 from '@/components/shared/sidebar/SidebarMenuV2.vue'
import AppHeader from '@/components/shared/AppHeadar/AppHeader.vue'
import { SidebarProvider } from '@/components/ui/sidebar'

interface Props {
  hideSidebar?: boolean
  hideGradient?: boolean
  hideCollapse?: boolean
  user?: { name: string; email: string; avatar?: string }
}
const props = withDefaults(defineProps<Props>(), {
  hideSidebar: false,
  hideGradient: false,
  hideCollapse: false,
  user: () => ({ name: 'Utilisateur', email: 'user@example.com' }),
})

// Récupérer l'état depuis localStorage ou utiliser true par défaut
const getSavedSidebarState = () => {
  if (typeof window !== 'undefined') {
    const saved = localStorage.getItem('sidebar-open')
    return saved !== null ? JSON.parse(saved) : true
  }
  return true
}

const open = ref(getSavedSidebarState())
const defaultOpen = getSavedSidebarState()

watch(open, (newValue: boolean) => {
  if (typeof window !== 'undefined') {
    localStorage.setItem('sidebar-open', JSON.stringify(newValue))
  }
}, { immediate: false })

// S'assurer que l'état est bien récupéré au montage
onMounted(() => {
  open.value = getSavedSidebarState()
})
</script>


<template>
  <!-- ====== BRANCHE AVEC SIDEBAR ====== -->
  <template v-if="!props.hideSidebar">
    <SidebarProvider v-model:open="open" :defaultOpen="defaultOpen" style="--sidebar-width-mobile: 20rem;">
      <div class="relative z-20 flex w-full min-h-screen flex-col overflow-hidden">
        <GradientBackground v-if="!props.hideGradient" />

        <div class="relative z-10 flex flex-1 overflow-hidden">
          <SidebarMenuV2 :user="props.user" />
          <div class="flex flex-1 flex-col w-full min-w-0">
            <AppHeader :hideCollapse="false" />
            <main class="min-h-screen flex-1 overflow-auto p-1 w-full min-w-0">
              <slot />
            </main>
          </div>
        </div>
      </div>
    </SidebarProvider>
  </template>

  <!-- ====== BRANCHE SANS SIDEBAR (landing / login / autre page sans sidebar) ====== -->
  <template v-else>
    <div class="relative z-20 flex min-h-screen flex-col overflow-hidden">
      <GradientBackground v-if="!props.hideGradient" />
      <div class="relative z-10 flex flex-1 overflow-hidden">
        <div class="flex flex-1 flex-col w-full min-w-0">
          <AppHeader :hideCollapse="true" class="bg-none" />
          <main class="min-h-screen flex-1 overflow-auto p-2 w-full min-w-0">
            <slot />
          </main>
        </div>
      </div>
    </div>
  </template>
</template>
