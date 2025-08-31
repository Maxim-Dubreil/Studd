<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="true">
    <BackButton :href="`/workspaces/${props.workspace_id}/study_sheets`" />
    <HomeButton :href="`/dashboard`" />

    <div class="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <!-- En-tête -->
      <div class="mb-12 text-center">
        <h1 class="mb-4 text-4xl font-extrabold tracking-tight text-gray-900 sm:text-5xl dark:text-white">
          {{ props.studySheetName || content.title }}
        </h1>
        <div class="mx-auto h-1 w-24 rounded-full bg-gradient-to-r from-violet-500 to-indigo-500"></div>
      </div>

      <!-- Résumé -->
      <div class="mb-12 rounded-xl bg-gradient-to-r from-violet-50 to-indigo-50 p-6 shadow-sm dark:from-violet-900/20 dark:to-indigo-900/20">
        <div class="flex items-start">
          <Icon name="info" class="mr-3 mt-1 h-5 w-5 flex-shrink-0 text-violet-600 dark:text-violet-400" />
          <p class="text-gray-700 dark:text-gray-300" v-html="sanitize(content.summary)"></p>
        </div>
      </div>

      <!-- Table des matières -->
      <nav class="mb-12 rounded-lg border border-gray-200 bg-gray-50 p-6 dark:border-gray-700 dark:bg-gray-800/50">
        <h2 class="mb-4 text-lg font-semibold text-gray-900 dark:text-white">Table of Contents</h2>
        <ol class="space-y-2">
          <li v-for="(section, index) in content.sections" :key="index">
            <a 
              :href="`#section-${index}`"
              class="text-violet-600 hover:text-violet-700 hover:underline dark:text-violet-400 dark:hover:text-violet-300"
            >
              {{ index + 1 }}. {{ section.title }}
            </a>
          </li>
        </ol>
      </nav>

      <!-- Sections -->
      <div class="space-y-12">
        <section 
          v-for="(section, index) in content.sections" 
          :key="index"
          :id="`section-${index}`"
          class="scroll-mt-8"
        >
          <h2 class="mb-6 text-2xl font-bold text-gray-900 dark:text-white">
            {{ index + 1 }}. {{ section.title }}
          </h2>
          
          <div class="mb-6 rounded-lg bg-white p-6 shadow-sm dark:bg-gray-800">
            <p class="text-gray-700 dark:text-gray-300" v-html="sanitize(section.content)"></p>
          </div>

          <!-- Sous-sections -->
          <div v-if="section.subsections && section.subsections.length > 0" class="ml-6 space-y-6">
            <div 
              v-for="(subsection, subIndex) in section.subsections" 
              :key="subIndex"
              class="border-l-4 border-violet-200 pl-6 dark:border-violet-700"
            >
              <h3 class="mb-3 text-lg font-semibold text-gray-800 dark:text-gray-200">
                {{ section.subsections.length > 1 ? `${index + 1}.${subIndex + 1}` : '' }} {{ subsection.subtitle }}
              </h3>
              <ul class="space-y-2">
                <li 
                  v-for="(point, pointIndex) in subsection.points" 
                  :key="pointIndex"
                  class="flex items-start"
                >
                  <Icon name="chevron-right" class="mr-2 mt-0.5 h-4 w-4 flex-shrink-0 text-violet-500" />
                  <span class="text-gray-600 dark:text-gray-400" v-html="sanitize(point)"></span>
                </li>
              </ul>
            </div>
          </div>
        </section>
      </div>

      <!-- Points clés -->
      <div class="mt-16 rounded-xl bg-gradient-to-br from-violet-100 to-indigo-100 p-8 dark:from-violet-900/30 dark:to-indigo-900/30">
        <h2 class="mb-6 flex items-center text-2xl font-bold text-gray-900 dark:text-white">
          <Icon name="key" class="mr-3 h-6 w-6 text-violet-600 dark:text-violet-400" />
          Key Points to Remember
        </h2>
        <ul class="space-y-3">
          <li 
            v-for="(point, index) in content.key_points" 
            :key="index"
            class="flex items-start"
          >
            <span class="mr-3 flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-violet-600 text-sm font-medium text-white dark:bg-violet-500">
              {{ index + 1 }}
            </span>
            <span class="text-gray-700 dark:text-gray-300" v-html="sanitize(point)"></span>
          </li>
        </ul>
      </div>



      <!-- Action Buttons -->
      <div class="mt-16 flex flex-col justify-center gap-3 border-t py-4 sm:flex-row">
        <Button @click="goToStudySheets" variant="default">
          <Icon name="circle-chevron-left" />
          <span>Back to study sheets</span>
        </Button>
        <Button @click="goToWorkspace" variant="outline">
          <Icon name="home" />
          <span>Back to workspace</span>
        </Button>
      </div>
    </div>
  </AppLayout>
</template>

<script setup lang="ts">
  import { Button } from '@/components/ui/button';
  import BackButton from '@/components/ui/button/BackButton.vue';
  import HomeButton from '@/components/ui/button/HomeButton.vue';
  import Icon from '@/components/ui/icon/Icon.vue';
  import AppLayout from '../../../components/layout/AppLayout.vue';

  interface StudySheetContent {
    title: string;
    summary: string;
    sections: Section[];
    key_points: string[];
  }

  interface Section {
    title: string;
    content: string;
    subsections: Subsection[];
  }

  interface Subsection {
    subtitle: string;
    points: string[];
  }

  interface props {
    content: StudySheetContent;
    workspace_id: number;
    studySheetName?: string;
  }

  const props = defineProps<props>();

  // Fonction pour nettoyer le HTML
  function sanitize(html: string): string {
    // Ici on pourrait utiliser une vraie librairie de sanitization
    // Pour l'instant on fait confiance au backend qui utilise déjà sanitize
    return html;
  }

  // Navigation functions
  function goToStudySheets() {
    window.location.href = `/workspaces/${props.workspace_id}/study_sheets`;
  }

  function goToWorkspace() {
    window.location.href = `/workspaces/${props.workspace_id}`;
  }
</script>

<style scoped>
/* Smooth scroll pour les ancres */
html {
  scroll-behavior: smooth;
}

/* Animation pour les sections au survol */
section:hover > h2 {
  color: rgb(124 58 237);
}

.dark section:hover > h2 {
  color: rgb(196 181 253);
}

/* Style pour les liens dans le contenu */
:deep(a) {
  color: rgb(124 58 237);
  text-decoration: underline;
}

:deep(a:hover) {
  color: rgb(109 40 217);
}

.dark :deep(a) {
  color: rgb(196 181 253);
}

.dark :deep(a:hover) {
  color: rgb(221 214 254);
}

/* Style pour le texte en gras */
:deep(strong) {
  font-weight: 600;
  color: rgb(17 24 39);
}

.dark :deep(strong) {
  color: rgb(255 255 255);
}

/* Style pour le texte en italique */
:deep(em) {
  font-style: italic;
}

/* Style pour les listes */
:deep(ul) {
  list-style-type: disc;
  list-style-position: inside;
  margin-left: 1rem;
}

:deep(ul > li) {
  margin-bottom: 0.25rem;
}

:deep(ol) {
  list-style-type: decimal;
  list-style-position: inside;
  margin-left: 1rem;
}

:deep(ol > li) {
  margin-bottom: 0.25rem;
}
</style>
