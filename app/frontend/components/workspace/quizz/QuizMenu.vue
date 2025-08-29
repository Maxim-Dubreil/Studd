<!-- QuizMenu.vue -->
<template>
    <a
    :href="`/workspaces/${workspaceId}`"
    class="bg-card/50 hover:bg-card/80 absolute top-2 left-2 rounded-lg border p-2 backdrop-blur-sm"
    >
    <Icon name="arrow-left" class="h-6 w-6" />
    </a>
  <div class="max-w-3xl mx-auto p-8 bg-background rounded-2xl border shadow-lg relative">

    <!-- Header -->
    <div class="text-center mb-8">
      <h1 class="text-3xl font-bold text-foreground mb-3">
        {{ hasQuiz ? 'Choose Your Mode' : 'Generate Quiz First' }}
      </h1>
      <p class="text-muted-foreground text-lg">
        {{ hasQuiz ? 'Select the type of assessment you want to start' : 'Generate a quiz from your workspace content before starting' }}
      </p>
    </div>

    <div v-if="!hasQuiz" class="mb-8">
      <div class="bg-yellow-50 border border-yellow-200 rounded-xl p-6 mb-6">
        <div class="flex items-start gap-4">
          <div class="p-2 bg-yellow-100 rounded-lg">
            <Icon name="lightbulb" class="h-5 w-5 text-yellow-600" />
          </div>
          <div>
            <h3 class="font-semibold text-yellow-800 mb-1">No Quiz Available</h3>
            <p class="text-yellow-700 text-sm">
              Generate a quiz from your workspace content to get started. This will create personalized questions based on your content.
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Menu Options -->
    <div v-if="hasQuiz" class="space-y-4 mb-8">
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
              Learning Mode
            </h3>
            <p class="text-muted-foreground text-sm leading-relaxed">
              Interactive learning mode with immediate feedback. Perfect for reviewing and consolidating your knowledge in an engaging way.
            </p>
            <div class="mt-2 flex items-center gap-2 text-xs text-muted-foreground">
              <Icon name="check" class="h-3 w-3" />
              <span>Immediate feedback</span>
              <Icon name="check" class="h-3 w-3" />
              <span>Explanations shown</span>
              <Icon name="check" class="h-3 w-3" />
            </div>
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
              Exam Mode
            </h3>
            <p class="text-muted-foreground text-sm leading-relaxed">
              Formal assessment with final scoring. Test your skills under exam conditions to measure your progress.
            </p>
            <div class="mt-2 flex items-center gap-2 text-xs text-muted-foreground">
              <Icon name="clock" class="h-3 w-3" />
              <span>Timed evaluation</span>
              <Icon name="target" class="h-3 w-3" />
              <span>Final score</span>
              <Icon name="eye-off" class="h-3 w-3" />
              <span>No immediate feedback</span>
            </div>
          </div>
        </div>
      </button>
    </div>

    <!-- Action Buttons -->
    <div class="text-center">
      <!-- Generate Quiz Button (when no quiz) -->
      <div v-if="!hasQuiz">
        <DecoDialog
          title="Generate Quiz"
          description="This will generate a new quiz based on your workspace content. Are you ready to proceed?"
          actionLabel="Generate"
          cancelLabel="Cancel"
          :onConfirm="generateNewQuiz"
        >
          <template #trigger>
            <button
              class="inline-flex items-center gap-3 px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 bg-primary text-primary-foreground hover:bg-primary/90 shadow-lg hover:shadow-xl transform hover:scale-105"
            >
              <Icon name="plus" class="h-5 w-5" />
              Generate Quiz
            </button>
          </template>
        </DecoDialog>
        
        <p class="text-xs text-muted-foreground mt-3">
          This process may take a few moments
        </p>
      </div>

      <!-- Launch Quiz Button (when quiz exists) -->
      <div v-else>
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
          {{ selectedMode ? `Start ${selectedMode === 'quiz' ? 'Learning' : 'Exam'}` : 'Select a mode' }}
        </button>

        <!-- Generate New Quiz Button -->
        <div class="mt-3">
          <DecoDialog
            title="Generate New Quiz"
            description="Are you sure you want to generate a new quiz? This will replace the current quiz and reset any progress statistics."
            actionLabel="Generate"
            cancelLabel="Cancel"
            :onConfirm="generateNewQuiz"
          >
            <template #trigger>
              <button
                class="inline-flex items-center gap-2 px-4 py-2 rounded-lg font-medium text-sm transition-all duration-300 bg-muted hover:bg-muted/80 text-muted-foreground hover:text-foreground shadow-sm hover:shadow-md"
              >
                <Icon name="refresh-cw" class="h-4 w-4" />
                Generate New Quiz
              </button>
            </template>
          </DecoDialog>
        </div>
      </div>
    </div>
    
    <!-- Loading Modal -->
    <div v-if="isLoading" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div class="bg-background p-8 rounded-xl shadow-xl flex flex-col items-center max-w-sm mx-4">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mb-4"></div>
        <p class="text-lg font-medium text-center">Generating Quiz...</p>
        <p class="text-sm text-muted-foreground mt-2 text-center">Please wait, this may take a few moments.</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Icon from '@/components/ui/icon/Icon.vue';
import DecoDialog from '@/components/ui/alert-dialog/DecoDialog.vue';

// Props definition
const props = defineProps<{
  workspaceId?: number;
  hasQuiz?: boolean;
}>();

// Event emissions definition
const emit = defineEmits<{
  'launchQuiz': [],
  'testMode': [],
  'quizGenerated': [],
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

    // Emit event to notify parent component
    emit('quizGenerated');
    // Reload page to show the new quiz
    window.location.reload();
  } catch (err) {
    // Fermer le modal de chargement en cas d'erreur
    isLoading.value = false;
    console.error(err instanceof Error ? err.message : 'Unknown error');
    alert('Error generating quiz');
  }
};

// Function to get CSRF token
function getCsrfToken(): string {
  const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]');
  if (!meta) throw new Error('<meta name="csrf-token"> tag not found');
  return meta.content;
}
</script>
