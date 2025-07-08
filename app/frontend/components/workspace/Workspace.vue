<template>
  <section class="pb-16">
    <!-- titre dynamique -->
    <h1 class="mb-10 text-center text-3xl md:text-4xl font-semibold">
      {{ title }}
    </h1>

    <!-- 4 lignes sur desktop -->
    <WorkspaceGrid class="lg:grid-rows-4">
      <!-- Col 1 – lignes 1-3 -->
      <WorkspaceCard
        name="Fiche de révisions"
        desc="Génère des fiches de révisions à partir des fichiers uploadés"
        href="#"
        cta="Ouvrir"
        :Icon="Clipboard"
        cls="lg:col-start-1 lg:col-end-2 lg:row-start-1 lg:row-end-4"
      >
        <template #bg>
          <div class="absolute -right-20 -top-20 h-40 w-40 rounded-full bg-indigo-300/20 blur-3xl"/>
        </template>
      </WorkspaceCard>

      <!-- Col 2 – lignes 1-4 -->
      <WorkspaceCard
        name="Quizz et tests"
        desc="Génère des quizz intelligents qui s’adaptent selon vos erreurs"
        href="#"
        cta="Ouvrir"
        :Icon="HelpCircle"
        cls="lg:col-start-2 lg:col-end-3 lg:row-start-1 lg:row-end-5"
      />

      <!-- Col 3 – ligne 1 -->
      <WorkspaceCard
        name="Cartes mentales"
        desc="Génère des cartes mentales à partir des fichiers uploadés"
        href="#"
        cta="Ouvrir"
        :Icon="Calendar"
        cls="lg:col-start-3 lg:col-end-4 lg:row-start-1 lg:row-end-2"
      />

      <!-- Col 3 – lignes 2-4 -->
      <WorkspaceCard
        name="Progression"
        desc="Consulter votre progression et vos statistiques"
        href="#"
        cta="Voir"
        :Icon="LineChart"
        cls="lg:col-start-3 lg:col-end-4 lg:row-start-2 lg:row-end-5"
      />

      <!-- Col 1 – ligne 4 -->
      <WorkspaceCard
        name="Flash-cards"
        desc="Génère des flash-cards à partir des fichiers uploadés"
        href="#"
        cta="Ouvrir"
        :Icon="SquareStack"
        cls="lg:col-start-1 lg:col-end-2 lg:row-start-4 lg:row-end-5"
      />
    </WorkspaceGrid>
  </section>
</template>

<script setup lang="ts">
import WorkspaceGrid  from '@/components/workspace/WorkspaceGrid.vue'
import WorkspaceCard  from '@/components/workspace/WorkspaceCard.vue'

import {
  Clipboard,
  Calendar,
  HelpCircle,
  SquareStack,
  LineChart,
} from 'lucide-vue-next'

interface Props {
  title: string
}

const props = defineProps<Props>()

console.log('[Workspace] Title value:', props.title)
</script>
