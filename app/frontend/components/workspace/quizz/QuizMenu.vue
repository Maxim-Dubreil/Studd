<!-- QuizMenu.vue -->
<template>
    <a
    :href="`/workspaces/${workspaceId}`"
    class="bg-card/50 hover:bg-card/80 absolute top-2 left-2 rounded-lg border p-2 backdrop-blur-sm"
    >
    <Icon name="arrow-left" class="h-6 w-6" />
    </a>
  <div class="max-w-2xl mx-auto p-8 bg-background rounded-2xl border shadow-lg relative">

    <!-- Header -->
    <div class="text-center mb-8">
      <h1 class="text-3xl font-bold text-foreground mb-3">
        Choisissez votre mode
      </h1>
      <p class="text-muted-foreground text-lg">
        Sélectionnez le type d'évaluation que vous souhaitez commencer
      </p>
    </div>

    <!-- Menu Options -->
    <div class="space-y-4 mb-8">
      <button
        @click="setSelectedMode('quiz')"
        class="w-full p-6 rounded-xl border-2 transition-all duration-300 text-left group"
        :class="[
          'hover:shadow-lg hover:scale-[1.02] transform',
          selectedMode === 'quiz'
            ? 'border-primary bg-primary/5 shadow-md'
            : 'border-border bg-background hover:border-primary/50'
        ]"
      >
        <div class="flex items-start gap-4">
          <div class="p-3 rounded-lg transition-colors duration-300"
            :class="[
              selectedMode === 'quiz'
                ? 'bg-primary text-primary-foreground'
                : 'bg-muted text-muted-foreground group-hover:bg-primary group-hover:text-primary-foreground'
            ]">
            <Icon name="book-open" class="h-6 w-6" />
          </div>
          <div class="flex-1">
            <h3 class="font-semibold text-lg mb-2 transition-colors duration-300"
              :class="[
                selectedMode === 'quiz'
                  ? 'text-primary'
                  : 'text-foreground group-hover:text-primary'
              ]">
              Quiz
            </h3>
            <p class="text-muted-foreground text-sm leading-relaxed">
              Mode d'apprentissage interactif avec feedback immédiat. Parfait pour réviser et consolider vos connaissances de manière ludique.
            </p>
          </div>
        </div>
      </button>

      <button
        @click="setSelectedMode('test')"
        class="w-full p-6 rounded-xl border-2 transition-all duration-300 text-left group"
        :class="[
          'hover:shadow-lg hover:scale-[1.02] transform',
          selectedMode === 'test'
            ? 'border-primary bg-primary/5 shadow-md'
            : 'border-border bg-background hover:border-primary/50'
        ]"
      >
        <div class="flex items-start gap-4">
          <div class="p-3 rounded-lg transition-colors duration-300"
            :class="[
              selectedMode === 'test'
                ? 'bg-primary text-primary-foreground'
                : 'bg-muted text-muted-foreground group-hover:bg-primary group-hover:text-primary-foreground'
            ]">
            <Icon name="file-text" class="h-6 w-6" />
          </div>
          <div class="flex-1">
            <h3 class="font-semibold text-lg mb-2 transition-colors duration-300"
              :class="[
                selectedMode === 'test'
                  ? 'text-primary'
                  : 'text-foreground group-hover:text-primary'
              ]">
              Test
            </h3>
            <p class="text-muted-foreground text-sm leading-relaxed">
              Évaluation formelle avec notation finale. Testez vos compétences dans des conditions d'examen pour mesurer votre progression.
            </p>
          </div>
        </div>
      </button>
    </div>

    <!-- Launch Button -->
    <div class="text-center">
      <button
        @click="handleLaunchQuiz"
        :disabled="!selectedMode"
        class="inline-flex items-center gap-3 px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 mb-4"
        :class="[
          'disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none',
          selectedMode
            ? 'bg-primary text-primary-foreground hover:bg-primary/90 shadow-lg hover:shadow-xl transform hover:scale-105'
            : 'bg-muted text-muted-foreground'
        ]"
      >
        <Icon name="play" class="h-5 w-5" />
        {{ selectedMode ? `Lancer le ${selectedMode}` : 'Sélectionnez un mode' }}
      </button>

      <!-- Bouton Générer un quizz avec modal de confirmation -->
      <div class="mt-3">
        <DecoDialog
          title="Générer un quizz"
          description="Êtes-vous sûr de vouloir générer un nouveau quizz ? Cette action entraînera la perte des statistiques de progression actuelles."
          actionLabel="Générer"
          cancelLabel="Annuler"
          :onConfirm="generateNewQuiz"
        >
          <template #trigger>
            <button
              class="inline-flex items-center gap-2 px-4 py-2 rounded-lg font-medium text-sm transition-all duration-300 bg-muted hover:bg-muted/80 text-muted-foreground hover:text-foreground shadow-sm hover:shadow-md"
            >
              <Icon name="refresh-cw" class="h-4 w-4" />
              Générer un quizz
            </button>
          </template>
        </DecoDialog>
      </div>
    </div>
    
    <!-- Modal de chargement -->
    <div v-if="isLoading" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div class="bg-background p-8 rounded-xl shadow-xl flex flex-col items-center">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mb-4"></div>
        <p class="text-lg font-medium">Génération du quiz en cours...</p>
        <p class="text-sm text-muted-foreground mt-2">Veuillez patienter, cela peut prendre quelques instants.</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Icon from '@/components/ui/icon/Icon.vue';
import DecoDialog from '@/components/ui/alert-dialog/DecoDialog.vue';

// Définition des props
const props = defineProps<{
  workspaceId?: number;
}>();

// Définition des émissions d'événements
const emit = defineEmits<{
  'launchQuiz': [],
  'testMode': [],
}>();

const selectedMode = ref<'quiz' | 'test' | null>(null);
const isLoading = ref<boolean>(false);

const setSelectedMode = (mode: 'quiz' | 'test') => {
    if (mode === "test") {
        selectedMode.value = mode;
        emit('testMode');
    }else if (mode === "quiz") {
        selectedMode.value = mode;
    }
};

const handleLaunchQuiz = () => {
    emit('launchQuiz');
};

const generateNewQuiz = async () => {
  try {
    // Afficher le modal de chargement
    isLoading.value = true;
    
    const res = await fetch(`/workspaces/${props.workspaceId}/quiz`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      },
      body: JSON.stringify({})
    });

    if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`);

    // Recharger la page pour afficher le nouveau quiz
    window.location.reload();
  } catch (err) {
    // Fermer le modal de chargement en cas d'erreur
    isLoading.value = false;
    console.error(err instanceof Error ? err.message : 'Erreur inconnue');
    alert('Erreur lors de la génération du quiz');
  }
};

// Fonction pour obtenir le token CSRF
function getCsrfToken(): string {
  const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]');
  if (!meta) throw new Error('Balise <meta name="csrf-token"> introuvable');
  return meta.content;
}
</script>
