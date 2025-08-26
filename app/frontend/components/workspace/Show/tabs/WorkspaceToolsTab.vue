<template>
  <div class="h-full">
    <!-- Grille de cartes d'outils -->
    <WorkspaceGrid class="lg:grid-rows-4 max-h-[39rem] h-full">
      <!-- Col 1 – lignes 1-3 -->
      <WorkspaceCard
        name="Fiche de révisions"
        desc="Génère des fiches de révisions à partir des fichiers uploadés"
        href="#"
        cta="Ouvrir"
        :Icon="Clipboard"
        :bg-image="ficheDeRevisionsIcon"
        cls="lg:col-start-1 lg:col-end-2 lg:row-start-1 lg:row-end-4"
      />

      <!-- Col 2 – lignes 1-4 -->
      <WorkspaceCard
        name="Quiz"
        desc="Apprenez votre sujet en testant vos connaissances"
        :href="`${workspaceId}/quiz`"
        cta="Ouvrir"
        :Icon="HelpCircle"
        :bg-image="quizzIcon"
        cls="lg:col-start-2 lg:col-end-3 lg:row-start-1 lg:row-end-5"
      />

      <!-- Col 3 – ligne 1 -->
      <WorkspaceCard
        name="Cartes mentales"
        desc="Génère des cartes mentales à partir des fichiers uploadés"
        :href="`${workspaceId}/mindmaps`"
        cta="Ouvrir"
        :Icon="Calendar"
        :bg-image="carteMentaleIcon"
        cls="lg:col-start-3 lg:col-end-4 lg:row-start-1 lg:row-end-2"
      />

      <!-- Col 3 – lignes 2-4 -->
      <WorkspaceCard
        name="Test"
        desc="Testez vos connaissances sur le sujet"
        href="#"
        cta="Voir"
        :Icon="LineChart"
        :bg-image="progressionIcon"
        cls="lg:col-start-3 lg:col-end-4 lg:row-start-2 lg:row-end-5"
      />

      <!-- Col 1 – ligne 4 -->
      <WorkspaceCard
        name="Flash-cards"
        desc="Génère des flash-cards à partir des fichiers uploadés"
        :href="`${workspaceId}/flashcards`"
        cta="Ouvrir"
        :Icon="SquareStack"
        :bg-image="flashcardsIcon"
        cls="lg:col-start-1 lg:col-end-2 lg:row-start-4 lg:row-end-5"
      />
    </WorkspaceGrid>
  </div>
</template>

<script setup lang="ts">
  import WorkspaceCard from '@/components/workspace/Show/WorkspaceShowCard.vue';
  import WorkspaceGrid from '@/components/workspace/Show/WorkspaceShowGrid.vue';
  import carteMentaleIcon from '@/images/carte_mentales_icon.png';
  import ficheDeRevisionsIcon from '@/images/fiche_de_revision.png';
  import flashcardsIcon from '@/images/flash_card.png';
  import progressionIcon from '@/images/mecha.png';
  import quizzIcon from '@/images/quizz_icon.png';
  import { Calendar, Clipboard, HelpCircle, LineChart, SquareStack } from 'lucide-vue-next';

  defineProps<{
    workspaceId: number;
  }>();
</script>