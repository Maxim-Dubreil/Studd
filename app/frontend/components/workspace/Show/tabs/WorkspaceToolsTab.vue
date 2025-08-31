<template>
  <div class="h-full">
    <!-- Grille de cartes d'outils -->
    <WorkspaceGrid class="lg:grid-rows-3 max-h-[39rem] h-full">
      <WorkspaceCard
        name="Study Sheets"
        desc="Generate study sheets from your uploaded files"
        :href="`${workspaceId}/study_sheets`"
        cta="Open"
        :Icon="Clipboard"
        :bg-image="ficheDeRevisionsIcon"
        cls="lg:col-start-1 lg:col-end-2 lg:row-start-1 lg:row-end-3"
      />

      <WorkspaceCard
        name="Quiz"
        desc="Interactive learning and assessment tool with two modes: Learning (with immediate feedback) and Exam (formal evaluation)"
        :href="`${workspaceId}/quiz`"
        cta="Open"
        :Icon="HelpCircle"
        :bg-image="quizzIcon"
        cls="lg:col-start-2 lg:col-end-3 lg:row-start-1 lg:row-end-4"
      />

      <!-- Col 3 – ligne 1 -->
      <WorkspaceCard
        name="Mind Maps"
        desc="Generate mind maps from your uploaded files"
        :href="`${workspaceId}/mindmaps`"
        cta="Open"
        :Icon="Calendar"
        :bg-image="carteMentaleIcon"
        cls="lg:col-start-3 lg:col-end-4 lg:row-start-1 lg:row-end-2"
      />



      <WorkspaceCard
        name="Flash Cards"
        desc="Generate flash cards from your uploaded files"
        :href="`${workspaceId}/flashcards`"
        cta="Open"
        :Icon="SquareStack"
        :bg-image="flashcardsIcon"
        cls="lg:col-start-1 lg:col-end-2 lg:row-start-3 lg:row-end-4"
      />

      <div class="lg:col-start-3 lg:col-end-4 lg:row-start-2 lg:row-end-4 group relative flex items-center justify-center rounded-2xl border-2 border-dashed border-violet-300/50 bg-gradient-to-br from-violet-50/50 via-indigo-50/30 to-purple-50/50 backdrop-blur-sm transition-all duration-500 hover:border-violet-400/70 hover:shadow-lg hover:scale-[1.02]">
        <div class="absolute inset-0 overflow-hidden rounded-2xl">
          <div class="absolute top-4 right-4 w-8 h-8 bg-violet-200/30 rounded-full animate-pulse"></div>
          <div class="absolute bottom-6 left-6 w-6 h-6 bg-indigo-200/30 rounded-full animate-pulse" style="animation-delay: 0.5s"></div>
          <div class="absolute top-1/2 left-1/2 w-4 h-4 bg-purple-200/30 rounded-full animate-pulse" style="animation-delay: 1s"></div>
        </div>
        
        <div class="relative text-center p-6">
          <div class="relative w-16 h-16 mx-auto mb-4">
            <div class="absolute inset-0 bg-gradient-to-r from-violet-400 to-indigo-400 rounded-xl opacity-20 group-hover:opacity-30 transition-opacity duration-300 animate-pulse"></div>
            <div class="relative w-full h-full rounded-xl bg-gradient-to-r from-violet-100 to-indigo-100 flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
              <Icon name="sparkles" class="w-8 h-8 text-violet-600 group-hover:rotate-12 transition-transform duration-300" />
            </div>
          </div>
          <h3 class="text-lg font-semibold text-violet-700 mb-2 group-hover:text-violet-800 transition-colors duration-300">More Tools Coming</h3>
          <p class="text-sm text-violet-600/80 leading-relaxed">New learning tools are being developed to enhance your study experience</p>
          
          <div class="flex justify-center space-x-1 mt-4">
            <div class="w-2 h-2 bg-violet-400 rounded-full animate-bounce"></div>
            <div class="w-2 h-2 bg-indigo-400 rounded-full animate-bounce" style="animation-delay: 0.1s"></div>
            <div class="w-2 h-2 bg-purple-400 rounded-full animate-bounce" style="animation-delay: 0.2s"></div>
          </div>
        </div>
      </div>
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
  import { Calendar, Clipboard, HelpCircle, SquareStack } from 'lucide-vue-next';
  import Icon from '@/components/ui/icon/Icon.vue';

  defineProps<{
    workspaceId: number;
  }>();
</script>