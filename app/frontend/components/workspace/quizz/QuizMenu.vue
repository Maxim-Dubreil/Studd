<!-- QuizMenu.vue -->
<template>
  <AppLayout :hide-sidebar="true" :hide-toggle="false" :hide-gradient="false" class="overflow-hidden">
    <BackButton :href="`/workspaces/${workspaceId}`" />
    <HomeButton :href="`/dashboard`" />
    <div class=" mt-15 bg-background relative max-w-3xl rounded-2xl border p-8 shadow-lg">
      <!-- Header -->
      <div class="mb-8 text-center">
        <h1 class="text-foreground mb-3 text-3xl font-bold">
          {{ hasQuiz ? 'Choose Your Mode' : 'Generate Quiz First' }}
        </h1>
        <p class="text-muted-foreground text-lg">
          {{
            hasQuiz
              ? 'Select the type of assessment you want to start'
              : 'Generate a quiz from your workspace content before starting'
          }}
        </p>
      </div>

      <div v-if="!hasQuiz" class="mb-8">
        <div class="mb-6 rounded-xl border border-yellow-200 bg-yellow-50 p-6">
          <div class="flex items-start gap-4">
            <div class="rounded-lg bg-yellow-100 p-2">
              <Icon name="lightbulb" class="h-5 w-5 text-yellow-600" />
            </div>
            <div>
              <h3 class="mb-1 font-semibold text-yellow-800">No Quiz Available</h3>
              <p class="text-sm text-yellow-700">
                Generate a quiz from your workspace content to get started. This will create
                personalized questions based on your content.
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Menu Options -->
      <div v-if="hasQuiz" class="mb-8 space-y-4">
        <button
          @click="setSelectedMode('quiz')"
          class="group w-full rounded-xl border-2 p-6 text-left transition-all duration-300"
          :class="[
            'transform hover:scale-[1.02] hover:shadow-lg',
            selectedMode === 'quiz'
              ? 'border-primary bg-primary/5 shadow-md'
              : 'border-border bg-background hover:border-primary/50',
          ]"
        >
          <div class="flex items-start gap-4">
            <div
              class="rounded-lg p-3 transition-colors duration-300"
              :class="[
                selectedMode === 'quiz'
                  ? 'bg-primary text-primary-foreground'
                  : 'bg-muted text-muted-foreground group-hover:bg-primary group-hover:text-primary-foreground',
              ]"
            >
              <Icon name="book-open" class="h-6 w-6" />
            </div>
            <div class="cursor-pointer">
              <h3
                class="mb-2 text-lg font-semibold transition-colors duration-300"
                :class="[
                  selectedMode === 'quiz'
                    ? 'text-primary'
                    : 'text-foreground group-hover:text-primary',
                ]"
              >
                Learning Mode
              </h3>
              <p class="text-muted-foreground text-sm leading-relaxed">
                Interactive learning mode with immediate feedback. Perfect for reviewing and
                consolidating your knowledge in an engaging way.
              </p>
              <div class="text-muted-foreground mt-2 flex items-center gap-2 text-xs">
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
          class="group w-full rounded-xl border-2 p-6 text-left transition-all duration-300"
          :class="[
            'transform hover:scale-[1.02] hover:shadow-lg',
            selectedMode === 'test'
              ? 'border-primary bg-primary/5 shadow-md'
              : 'border-border bg-background hover:border-primary/50',
          ]"
        >
          <div class="flex items-start gap-4">
            <div
              class="rounded-lg p-3 transition-colors duration-300"
              :class="[
                selectedMode === 'test'
                  ? 'bg-primary text-primary-foreground'
                  : 'bg-muted text-muted-foreground group-hover:bg-primary group-hover:text-primary-foreground',
              ]"
            >
              <Icon name="file-text" class="h-6 w-6" />
            </div>
            <div class="cursor-pointer">
              <h3
                class="mb-2 text-lg font-semibold transition-colors duration-300"
                :class="[
                  selectedMode === 'test'
                    ? 'text-primary'
                    : 'text-foreground group-hover:text-primary',
                ]"
              >
                Exam Mode
              </h3>
              <p class="text-muted-foreground text-sm leading-relaxed">
                Formal assessment with final scoring. Test your skills under exam conditions to
                measure your progress.
              </p>
              <div class="text-muted-foreground mt-2 flex items-center gap-2 text-xs">
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
              <Button
                class="bg-primary text-primary-foreground hover:bg-primary/90 inline-flex h-12 transform items-center gap-2 rounded-xl text-lg font-semibold shadow-lg transition-all duration-300 hover:scale-105 hover:shadow-xl"
              >
                <Icon name="plus" class="h-6 w-6" />
                Generate Quiz
              </Button>
            </template>
          </DecoDialog>

          <p class="text-muted-foreground mt-3 text-xs">This process may take a few moments</p>
        </div>

        <!-- Launch Quiz Button (when quiz exists) -->
        <div v-else>
          <Button
            @click="handleLaunchQuiz"
            :disabled="!selectedMode"
            class="mb-4 inline-flex items-center gap-3 rounded-xl px-8 py-4 text-lg font-semibold transition-all duration-300"
            :class="[
              'disabled:transform-none disabled:cursor-not-allowed disabled:opacity-50',
              selectedMode
                ? 'bg-primary text-primary-foreground hover:bg-primary/90 transform shadow-lg hover:scale-105 hover:shadow-xl'
                : 'bg-muted text-muted-foreground',
            ]"
          >
            <Icon name="play" class="h-5 w-5" />
            {{
              selectedMode
                ? `Start ${selectedMode === 'quiz' ? 'Learning' : 'Exam'}`
                : 'Select a mode'
            }}
          </Button>

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
                <Button
                  class="bg-muted hover:bg-muted/80 text-muted-foreground hover:text-foreground inline-flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-medium shadow-sm transition-all duration-300 hover:shadow-md"
                >
                  <Icon name="refresh-cw" class="h-4 w-4" />
                  Generate New Quiz
                </Button>
              </template>
            </DecoDialog>
          </div>
        </div>
      </div>

      <!-- Loading Modal -->
      <div v-if="isLoading" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
        <div
          class="bg-background mx-4 flex max-w-sm flex-col items-center rounded-xl p-8 shadow-xl"
        >
          <div class="border-primary mb-4 h-12 w-12 animate-spin rounded-full border-b-2"></div>
          <p class="text-center text-lg font-medium">Generating Quiz...</p>
          <p class="text-muted-foreground mt-2 text-center text-sm">
            Please wait, this may take a few moments.
          </p>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup lang="ts">
  import AppLayout from '@/components/layout/AppLayout.vue';
  import DecoDialog from '@/components/ui/alert-dialog/DecoDialog.vue';
  import BackButton from '@/components/ui/button/BackButton.vue';
  import HomeButton from '@/components/ui/button/HomeButton.vue';

  import Button from '@/components/ui/button/Button.vue';
  import Icon from '@/components/ui/icon/Icon.vue';
  import { ref } from 'vue';

  // Props definition
  const props = defineProps<{
    workspaceId?: number;
    hasQuiz?: boolean;
  }>();

  // Event emissions definition
  const emit = defineEmits<{
    launchQuiz: [];
    testMode: [];
    quizGenerated: [];
  }>();

  const selectedMode = ref<'quiz' | 'test' | null>(null);
  const isLoading = ref<boolean>(false);

  const setSelectedMode = (mode: 'quiz' | 'test') => {
    if (mode === 'test') {
      selectedMode.value = mode;
      emit('testMode');
    } else if (mode === 'quiz') {
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
          Accept: 'application/json',
          'X-CSRF-Token': getCsrfToken(),
        },
        body: JSON.stringify({}),
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
