<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="true">
    <!-- Structure principale -->
    <div class="flex flex-col h-screen">
      <!-- Header (visible uniquement pendant le test) -->
      <div v-if="!isStartScreen && !isCompleted" class="h-24 max-w-6xl w-full mx-auto p-6">
        <a
          :href="`/workspaces/${props.workspace_id}`"
          class="bg-card/50 hover:bg-card/80 absolute top-2 left-2 rounded-lg border p-2 backdrop-blur-sm"
        >
          <Icon name="arrow-left" class="h-6 w-6" />
        </a>
        <div class="flex items-center justify-between">
          <div class="flex flex-col">
            <h1 class="text-xl font-semibold text-gray-700">{{ quiz.title }} - Mode Test</h1>
            <p class="text-sm text-gray-500">Session {{ currentSession }}</p>
          </div>

          <div class="flex-grow mx-4">
            <div class="flex items-center">
              <span class="text-sm font-medium text-purple-600 mr-2">{{ progressPercentage }}%</span>
              <div class="w-3/4 bg-gray-200 rounded-full h-2">
                <div
                  class="bg-purple-600 h-2 rounded-full"
                  :style="{ width: progressPercentage + '%' }"
                ></div>
              </div>
            </div>
          </div>

          <div class="flex items-center">
            <span class="text-sm font-medium text-gray-700">{{ timer }}</span>
          </div>
        </div>
      </div>

      <!-- Conteneur principal -->
      <div class="flex-1 flex items-center justify-center py-4">
        <!-- Écran de départ -->
        <div v-if="isStartScreen" class="flex flex-col items-center justify-center min-h-screen p-6">
          <!-- Affichage du loader pendant la génération -->
          <div v-if="isLoading" class="flex flex-col items-center justify-center h-[600px]">
            <svg class="animate-spin h-12 w-12 mb-4" viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-dasharray="60" stroke-dashoffset="20" />
            </svg>
            <p class="text-lg">Génération du test en cours...</p>
          </div>

          <!-- Bouton démarrer le test -->
          <div v-else class="flex flex-col items-center justify-center h-[600px] gap-4">
            <Button @click="startQuiz" :disabled="isLoading" class="px-8 py-4 text-white text-xl font-medium">
              <span v-if="!isLoading">Démarrer le test</span>
              <span v-else class="flex items-center gap-2">
                <svg class="animate-spin h-5 w-5" viewBox="0 0 24 24" fill="none">
                  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-dasharray="60" stroke-dashoffset="20" />
                </svg>
                Chargement…
              </span>
            </Button>

            <Button @click="generateNewQuiz" :disabled="isLoading" variant="outline" class="px-8 py-4 text-xl font-medium">
              <span v-if="!isLoading">Générer un nouveau test</span>
              <span v-else class="flex items-center gap-2">
                <svg class="animate-spin h-5 w-5" viewBox="0 0 24 24" fill="none">
                  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-dasharray="60" stroke-dashoffset="20" />
                </svg>
                Chargement…
              </span>
            </Button>
          </div>

          <!-- Lien de retour -->
          <a
            :href="`/workspaces/${props.workspace_id}`"
            class="bg-card/50 hover:bg-card/80 absolute top-2 left-2 rounded-lg border p-2 backdrop-blur-sm"
          >
            <Icon name="arrow-left" class="h-6 w-6" />
          </a>
        </div>

        <!-- Écran du test -->
        <div v-else class="max-w-6xl w-full mx-auto h-[500px] bg-white rounded-3xl shadow-xl overflow-hidden flex flex-col">
          <div class="p-6 bg-gray-50 flex-grow overflow-y-auto">
            <!-- Affichage des questions -->
            <div v-if="currentQuestion && !isCompleted" class="max-w-5xl mx-auto">
              <h2 class="text-xl font-bold text-gray-800 mb-2">Question {{ currentQuestionIndex + 1 }}</h2>
              <p class="text-lg text-gray-700 mb-4">{{ currentQuestion.question }}</p>

              <!-- Séparateur entre la question et les réponses -->
              <div class="h-px bg-gray-200 w-full my-10"></div>

              <!-- Questions à choix multiples -->
              <div v-if="currentQuestion.type === 'multiple_choice'" class="space-y-4">
                <div
                  v-for="option in currentQuestion.options"
                  :key="option.id"
                  class="flex items-center p-4 bg-white border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors cursor-pointer shadow-sm"
                  :class="{
                    'border-purple-500 bg-purple-50 shadow-md shadow-purple-200': selectedAnswers.includes(option.id),
                    'border-gray-200': !selectedAnswers.includes(option.id)
                  }"
                  @click="selectAnswer(option.id)"
                >
                  <div class="w-6 h-6 rounded-full border-2 flex items-center justify-center mr-3"
                    :class="{
                      'border-purple-500': selectedAnswers.includes(option.id),
                      'border-gray-300': !selectedAnswers.includes(option.id)
                    }">
                    <div v-if="selectedAnswers.includes(option.id)" class="w-3 h-3 rounded-full bg-purple-500"></div>
                  </div>
                  <span>{{ option.text }}</span>
                </div>
              </div>

              <!-- Questions vrai/faux -->
              <div v-else-if="currentQuestion.type === 'true_false'" class="space-y-4">
                <div
                  v-for="option in [{id: 'true', text: 'Vrai'}, {id: 'false', text: 'Faux'}]"
                  :key="option.id"
                  class="flex items-center p-4 bg-white border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors cursor-pointer shadow-sm"
                  :class="{
                    'border-purple-500 bg-purple-50 shadow-md shadow-purple-200': selectedAnswers.includes(option.id),
                    'border-gray-200': !selectedAnswers.includes(option.id)
                  }"
                  @click="selectAnswer(option.id)"
                >
                  <div class="w-6 h-6 rounded-full border-2 flex items-center justify-center mr-3"
                    :class="{
                      'border-purple-500': selectedAnswers.includes(option.id),
                      'border-gray-300': !selectedAnswers.includes(option.id)
                    }">
                    <div v-if="selectedAnswers.includes(option.id)" class="w-3 h-3 rounded-full bg-purple-500"></div>
                  </div>
                  <span>{{ option.text }}</span>
                </div>
              </div>

              <!-- Questions à compléter -->
              <div v-else-if="currentQuestion.type === 'fill_in_blank'" class="space-y-4">
                <div class="p-4 bg-white border border-gray-200 rounded-xl shadow-sm">
                  <input
                    type="text"
                    v-model="blankAnswer"
                    class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                    placeholder="Votre réponse..."
                    @input="updateBlankAnswer"
                  />
                </div>
              </div>
            </div>

            <!-- Résultats finaux avec explications -->
            <div v-if="isCompleted" class="py-8 h-full flex flex-col items-center justify-center max-w-3xl mx-auto">
              <h2 class="text-2xl font-bold text-gray-800 mb-4">Test terminé !</h2>
              <p class="text-lg text-gray-700 mb-6">Votre score: {{ score }}/{{ quiz.questions.length }}</p>
              
              <!-- Résumé des réponses avec explications -->
              <div class="w-full mb-8 space-y-6">
                <h3 class="text-xl font-semibold text-gray-700 mb-4">Résumé des réponses</h3>
                
                <div v-for="(question, index) in quiz.questions" :key="question.id" class="border border-gray-200 rounded-lg p-4">
                  <h4 class="font-medium text-gray-800 mb-2">Question {{ index + 1 }}: {{ question.question }}</h4>
                  
                  <!-- Affichage de la réponse de l'utilisateur -->
                  <div class="mb-2">
                    <span class="font-medium">Votre réponse: </span>
                    <span v-if="question.type === 'fill_in_blank'">
                      {{ userAnswers[question.id]?.[0] || 'Non répondu' }}
                    </span>
                    <span v-else-if="question.type === 'true_false'">
                      {{ userAnswers[question.id]?.[0] === 'true' ? 'Vrai' : userAnswers[question.id]?.[0] === 'false' ? 'Faux' : 'Non répondu' }}
                    </span>
                    <span v-else>
                      {{ userAnswers[question.id] ? 
                        question.options?.filter(opt => userAnswers[question.id].includes(opt.id)).map(opt => opt.text).join(', ') : 
                        'Non répondu' }}
                    </span>
                  </div>
                  
                  <!-- Affichage de la réponse correcte -->
                  <div class="mb-2">
                    <span class="font-medium">Réponse correcte: </span>
                    <span v-if="question.type === 'fill_in_blank'">
                      {{ question.correctAnswers[0] }}
                    </span>
                    <span v-else-if="question.type === 'true_false'">
                      {{ question.correctAnswers[0] === 'true' ? 'Vrai' : 'Faux' }}
                    </span>
                    <span v-else>
                      {{ question.options?.filter(opt => question.correctAnswers.includes(opt.id)).map(opt => opt.text).join(', ') }}
                    </span>
                  </div>
                  
                  <!-- Explication -->
                  <div class="mt-2 p-3" :class="isAnswerCorrect(question) ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-700'">
                    <p>{{ question.explanation }}</p>
                  </div>
                </div>
              </div>
              
              <div class="flex gap-4">
                <button
                  @click="goToStartScreen"
                  class="px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
                >
                  Retour à l'accueil
                </button>
                <button
                  @click="generateNewQuiz"
                  class="px-6 py-3 border border-purple-600 text-purple-600 rounded-lg hover:bg-purple-50 transition-colors"
                >
                  Générer un nouveau test
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Footer avec navigation (visible uniquement pendant le test) -->
      <div v-if="!isStartScreen && !isCompleted" class="h-24 max-w-6xl w-full mx-auto p-6 flex justify-between">
        <button
          @click="previousQuestion"
          class="flex items-center px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100 transition-colors"
          :disabled="currentQuestionIndex === 0"
          :class="{ 'opacity-50 cursor-not-allowed': currentQuestionIndex === 0 }"
        >
          <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
          </svg>
          Précédent
        </button>

        <button
          v-if="!isLastQuestion"
          @click="nextQuestion"
          class="flex items-center px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
          :disabled="!hasAnsweredCurrentQuestion"
          :class="{ 'opacity-50 cursor-not-allowed': !hasAnsweredCurrentQuestion }"
        >
          Suivant
          <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
          </svg>
        </button>

        <button
          v-else
          @click="finishQuiz"
          class="flex items-center px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
          :disabled="!hasAnsweredCurrentQuestion"
          :class="{ 'opacity-50 cursor-not-allowed': !hasAnsweredCurrentQuestion }"
        >
          Terminer
        </button>
      </div>
    </div>
  </AppLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import AppLayout from '../../../components/layout/AppLayout.vue'
import Icon from '@/components/ui/icon/Icon.vue'
import { Button } from '@/components/ui/button';

interface Option {
  id: string;
  text: string;
}

interface Question {
  id: string;
  type: 'multiple_choice' | 'true_false' | 'fill_in_blank';
  question: string;
  options?: Option[];
  correctAnswers: string[];
  explanation: string;
}

interface Quiz {
  quizId: string;
  title: string;
  description: string;
  questions: Question[];
}

interface Props {
  quizData?: Quiz;
  workspace_id: number;
}

const props = defineProps<Props>();

// État pour l'écran de départ
const isStartScreen = ref(true);
const isLoading = ref(false);

// État du quiz
const quiz = ref<Quiz>(props.quizData || {
  quizId: '',
  title: '',
  description: '',
  questions: []
});

const currentQuestionIndex = ref(0);
const selectedAnswers = ref<string[]>([]);
const blankAnswer = ref('');
const userAnswers = ref<Record<string, string[]>>({});
const isCompleted = ref(false);
const score = ref(0);
const currentSession = ref(1);
const seconds = ref(0);
const timerInterval = ref<number | null>(null);
const currentQuizSessionId = ref<number | null>(null);

const currentQuestion = computed(() => {
  return quiz.value.questions[currentQuestionIndex.value];
});

const isLastQuestion = computed(() => {
  return currentQuestionIndex.value === quiz.value.questions.length - 1;
});

const progressPercentage = computed(() => {
  return Math.round(((currentQuestionIndex.value + 1) / quiz.value.questions.length) * 100);
});

const timer = computed(() => {
  const minutes = Math.floor(seconds.value / 60);
  const remainingSeconds = seconds.value % 60;
  return `${minutes.toString().padStart(2, '0')}.${remainingSeconds.toString().padStart(2, '0')} Min`;
});

const hasAnsweredCurrentQuestion = computed(() => {
  if (!currentQuestion.value) return false;
  return !!userAnswers.value[currentQuestion.value.id]?.length;
});

// Fonction pour obtenir le token CSRF
function getCsrfToken(): string {
  const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]');
  if (!meta) throw new Error('Balise <meta name="csrf-token"> introuvable');
  return meta.content;
}

// Fonction pour démarrer ou générer un quiz
async function startQuiz(): Promise<void> {
  isLoading.value = true;
  try {
    // Si un quiz existe déjà dans les props, on l'utilise directement
    if (props.quizData) {
      isStartScreen.value = false;
      startTimer();
      await createQuizSession();
      return;
    }

    // Sinon, on génère un nouveau quiz
    const res = await fetch(`/workspaces/${props.workspace_id}/quiz`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      },
      body: JSON.stringify({})
    });

    if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`);

    const data = await res.json();
    quiz.value = data.quiz.content;
    isStartScreen.value = false;
    startTimer();
    await createQuizSession();
  } catch (err: unknown) {
    console.error(err instanceof Error ? err.message : 'Erreur inconnue');
    alert('Erreur lors de la génération du test');
  } finally {
    isLoading.value = false;
  }
}

// Fonction pour générer un nouveau quiz depuis l'écran de résultats
async function generateNewQuiz(): Promise<void> {
  isLoading.value = true;
  stopTimer();
  try {
    const res = await fetch(`/workspaces/${props.workspace_id}/quiz`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      },
      body: JSON.stringify({})
    });

    if (!res.ok) throw new Error(`Erreur HTTP ${res.status}`);

    const data = await res.json();
    quiz.value = data.quiz.content;
    resetQuizState();
    isCompleted.value = false;
    startTimer();
  } catch (err: unknown) {
    console.error(err instanceof Error ? err.message : 'Erreur inconnue');
    alert('Erreur lors de la génération du test');
  } finally {
    isLoading.value = false;
  }
}

function selectAnswer(answerId: string) {
  if (isMultipleAnswersQuestion.value) {
    if (selectedAnswers.value.includes(answerId)) {
      selectedAnswers.value = selectedAnswers.value.filter(id => id !== answerId);
    } else {
      selectedAnswers.value.push(answerId);
    }
  } else {
    selectedAnswers.value = [answerId];
  }

  userAnswers.value[currentQuestion.value.id] = [...selectedAnswers.value];
}

function updateBlankAnswer() {
  userAnswers.value[currentQuestion.value.id] = [blankAnswer.value];
}

function nextQuestion() {
  if (currentQuestionIndex.value < quiz.value.questions.length - 1) {
    currentQuestionIndex.value++;
    loadQuestionState();
  }
}

function previousQuestion() {
  if (currentQuestionIndex.value > 0) {
    currentQuestionIndex.value--;
    loadQuestionState();
  }
}

function loadQuestionState() {
  const questionId = currentQuestion.value.id;

  if (userAnswers.value[questionId]) {
    if (currentQuestion.value.type === 'fill_in_blank') {
      blankAnswer.value = userAnswers.value[questionId][0] || '';
    } else {
      selectedAnswers.value = [...userAnswers.value[questionId]];
    }
  } else {
    selectedAnswers.value = [];
    blankAnswer.value = '';
  }
}

async function finishQuiz() {
  calculateScore();
  isCompleted.value = true;
  stopTimer();
  
  await updateQuizSession();
}

function calculateScore() {
  score.value = 0;

  quiz.value.questions.forEach(question => {
    const userAnswer = userAnswers.value[question.id] || [];

    if (question.type === 'fill_in_blank') {
      if (userAnswer[0]?.toLowerCase() === question.correctAnswers[0].toLowerCase()) {
        score.value++;
      }
    } else {
      const isCorrect =
        userAnswer.length === question.correctAnswers.length &&
        userAnswer.every(answer => question.correctAnswers.includes(answer));

      if (isCorrect) {
        score.value++;
      }
    }
  });
}

function isAnswerCorrect(question: Question): boolean {
  const userAnswer = userAnswers.value[question.id] || [];

  if (question.type === 'fill_in_blank') {
    return userAnswer[0]?.toLowerCase() === question.correctAnswers[0].toLowerCase();
  } else {
    return userAnswer.length === question.correctAnswers.length &&
      userAnswer.every(answer => question.correctAnswers.includes(answer));
  }
}

function resetQuizState() {
  currentQuestionIndex.value = 0;
  selectedAnswers.value = [];
  blankAnswer.value = '';
  userAnswers.value = {};
  score.value = 0;
  seconds.value = 0;
  currentQuizSessionId.value = null;
}

// Nouvelle fonction pour retourner à l'écran de démarrage
function goToStartScreen() {
  resetQuizState();
  isCompleted.value = false;
  isStartScreen.value = true;
}

function startTimer() {
  if (timerInterval.value === null) {
    timerInterval.value = window.setInterval(() => {
      seconds.value++;
    }, 1000);
  }
}

function stopTimer() {
  if (timerInterval.value !== null) {
    clearInterval(timerInterval.value);
    timerInterval.value = null;
  }
}

onMounted(() => {
  // Si un quiz est déjà disponible, on démarre le timer
  if (!isStartScreen.value) {
    startTimer();
  }
});

onUnmounted(() => {
  stopTimer();
});

const isMultipleAnswersQuestion = computed(() => {
  return currentQuestion.value.type === 'multiple_choice' &&
         currentQuestion.value.correctAnswers.length > 1;
});

async function createQuizSession(): Promise<void> {
  try {
    const response = await fetch(`/workspaces/${props.workspace_id}/quiz_sessions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      },
      body: JSON.stringify({
        quiz_session: {
          quiz_id: props.quizData?.id || quiz.value.id || 1,
          quiz_mode: 'test',
          session_type: 'standard',
          total_questions: quiz.value.questions.length,
          metadata: {
            quiz_title: quiz.value.title,
            quiz_description: quiz.value.description
          }
        }
      })
    });

    if (!response.ok) throw new Error(`Erreur HTTP ${response.status}`);

    const data = await response.json();
    currentQuizSessionId.value = data.quiz_session.id;
  } catch (error) {
    console.error('Erreur lors de la création de la session:', error);
  }
}

async function updateQuizSession(): Promise<void> {
  if (!currentQuizSessionId.value) return;

  try {
    const quiz_session_answers_attributes = quiz.value.questions.map((question: any) => {
      const userAnswer = userAnswers.value[question.id] || [];
      const isCorrect = isAnswerCorrectForQuestion(question);
      
      const safeUserAnswers = userAnswer.length > 0 ? userAnswer : ['non_répondu'];
      const safeCorrectAnswers = question.correctAnswers && question.correctAnswers.length > 0 
        ? question.correctAnswers 
        : ['inconnu'];
        
      return {
        question_id: question.id,
        question_text: question.question,
        question_type: question.type,
        user_answers: safeUserAnswers,
        correct_answers: safeCorrectAnswers,
        is_correct: isCorrect,
        time_spent_seconds: Math.floor(seconds.value / quiz.value.questions.length),
        attempts_count: 1,
        analytics_data: {
          question_index: quiz.value.questions.indexOf(question)
        }
      };
    });

    const response = await fetch(`/workspaces/${props.workspace_id}/quiz_sessions/${currentQuizSessionId.value}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      },
      body: JSON.stringify({
        quiz_session: {
          completed_at: new Date().toISOString(),
          duration_seconds: seconds.value,
          score: score.value,
          accuracy_percentage: (score.value / quiz.value.questions.length * 100).toFixed(2),
          metadata: {
            quiz_title: quiz.value.title,
            final_score: score.value,
            total_questions: quiz.value.questions.length
          },
          quiz_session_answers_attributes: quiz_session_answers_attributes
        }
      })
    });

    if (!response.ok) throw new Error(`Erreur HTTP ${response.status}`);
    
    console.log('Session de test sauvegardée avec succès');
  } catch (error) {
    console.error('Erreur lors de la mise à jour de la session:', error);
  }
}

function isAnswerCorrectForQuestion(question: Question): boolean {
  const userAnswer = userAnswers.value[question.id] || [];

  if (question.type === 'fill_in_blank') {
    return userAnswer[0]?.toLowerCase() === question.correctAnswers[0].toLowerCase();
  } else {
    return userAnswer.length === question.correctAnswers.length &&
      userAnswer.every(answer => question.correctAnswers.includes(answer));
  }
}
</script>