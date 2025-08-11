<template>
  <AppLayout :hide-sidebar="true" :hide-top-nav="true" :hide-toggle="false" :hide-gradient="false">
    <section class="px-10 pb-16">
      <div class="relative mb-10 text-center">
        <a
          href="/workspaces"
          class="bg-card/50 hover:bg-card/80 absolute top-1/2 left-0 -translate-y-1/2 rounded-lg border p-2 backdrop-blur-sm"
        >
          <Icon name="arrow-left" class="h-6 w-6" />
        </a>
        <div class="flex items-center justify-center gap-4">
          <img
            v-if="props.workspace.icon"
            :src="getIconUrl(props.workspace.icon.path)"
            :alt="props.workspace.icon.name"
            class="h-12 w-12 rounded-lg"
          />
          <h1 class="text-3xl font-semibold md:text-4xl">
            {{ props.workspace.name }}
          </h1>
        </div>
        <div class="mt-4 flex flex-col items-center justify-center gap-2">
          <div
            v-if="props.workspace.raw_content"
            class="text-muted-foreground flex items-center gap-2 text-sm"
          >
            <span>
              Contenu:
              {{ props.workspace.raw_content.content_type === 'text/plain' ? 'Texte' : 'Fichier' }}
            </span>
          </div>
          <div v-else class="flex items-center gap-2 text-sm text-amber-500">
            <Icon name="alert-triangle" class="h-4 w-4" />
            <span>Aucun contenu</span>
          </div>
        </div>
      </div>
      <!-- 4 lignes sur desktop -->
      <WorkspaceGrid class="lg:grid-rows-4">
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
          name="Quizz et tests"
          desc="Génère des quizz intelligents qui s’adaptent selon vos erreurs"
          href="#"
          cta="Ouvrir"
          :Icon="HelpCircle"
          :bg-image="quizzIcon"
          cls="lg:col-start-2 lg:col-end-3 lg:row-start-1 lg:row-end-5"
        />

        <!-- Col 3 – ligne 1 -->
        <WorkspaceCard
          name="Cartes mentales"
          desc="Génère des cartes mentales à partir des fichiers uploadés"
          :href="`${props.workspace.id}/mindmaps`"
          cta="Ouvrir"
          :Icon="Calendar"
          :bg-image="carteMentaleIcon"
          cls="lg:col-start-3 lg:col-end-4 lg:row-start-1 lg:row-end-2"
        />

        <!-- Col 3 – lignes 2-4 -->
        <WorkspaceCard
          name="Progression"
          desc="Consulter votre progression et vos statistiques"
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
          :href="`${props.workspace.id}/flashcards`"
          cta="Ouvrir"
          :Icon="SquareStack"
          :bg-image="flashcardsIcon"
          cls="lg:col-start-1 lg:col-end-2 lg:row-start-4 lg:row-end-5"
        />
      </WorkspaceGrid>
    </section>
  </AppLayout>
</template>

<script setup lang="ts">
  import Icon from '@/components/ui/icon/Icon.vue';
  import WorkspaceCard from '@/components/workspace/Show/WorkspaceShowCard.vue';
  import WorkspaceGrid from '@/components/workspace/Show/WorkspaceShowGrid.vue';
  import { useIconResolver } from '@/composables/useIconResolver';
  import carteMentaleIcon from '@/images/carte_mentales_icon.png';
  import ficheDeRevisionsIcon from '@/images/fiche_de_revision.png';
  import flashcardsIcon from '@/images/flash_card.png';
  import progressionIcon from '@/images/mecha.png';
  import quizzIcon from '@/images/quizz_icon.png';
  import { Calendar, Clipboard, HelpCircle, LineChart, SquareStack } from 'lucide-vue-next';
  import AppLayout from '../../layout/AppLayout.vue';

  interface IconInfo {
    id: number;
    name: string;
    path: string;
  }

  interface RawContent {
    id: number;
    content?: string | null;
    content_type?: string | null;
    file_name?: string | null;
  }

  interface Workspace {
    id: number;
    name: string;
    icon?: IconInfo;
    raw_content?: RawContent | null;
  }

  const props = defineProps<{
    workspace: Workspace;
  }>();

  const { getIconUrl } = useIconResolver();
</script>
