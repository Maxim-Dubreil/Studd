<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="true">
    <!-- Structure principale -->
    <div class="flex flex-col h-screen">
      <!-- Header (visible uniquement pendant le quiz) -->
      <div v-if="!isStartScreen && !isCompleted" class="h-24 max-w-6xl w-full mx-auto p-6">
        <a
          :href="`/workspaces/${props.workspace_id}`"
          class="bg-card/50 hover:bg-card/80 absolute top-2 left-2 rounded-lg border p-2 backdrop-blur-sm"
        >
          <Icon name="arrow-left" class="h-6 w-6" />
        </a>
        <div class="flex items-center justify-between">
          <div class="flex flex-col">
            <h1 class="text-xl font-semibold text-gray-700">{{ quiz.title }}</h1>
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
          <div class="flex flex-col items-end">
            <span class="text-sm font-medium text-purple-600">{{ timer }}</span>
          </div>
        </div>
      </div>

      <!-- Conteneur principal -->
      <div class="flex-1 flex items-center justify-center py-4">
        <!-- Écran de départ avec QuizMenu -->
        <div v-if="isStartScreen" class="flex flex-col items-center justify-center min-h-screen p-6">
          <!-- Affichage du loader pendant la génération -->
          <div v-if="isLoading" class="flex flex-col items-center justify-center h-[600px]">
            <svg class="animate-spin h-12 w-12 mb-4" viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-dasharray="60" stroke-dashoffset="20" />
            </svg>
            <p class="text-lg">Génération du quizz en cours...</p>
          </div>

          <!-- QuizMenu à la place du bouton démarrer -->
          <div v-else>
            <QuizMenu
              :workspaceId="props.workspace_id"
              @launchQuiz="startQuiz()"
              @testMode="setTestMode"
            />
          </div>
        </div>

        <!-- Reste du contenu inchangé -->
        <div v-else class="max-w-6xl w-full mx-auto h-[500px] bg-white rounded-3xl shadow-xl overflow-hidden flex flex-col"
             :class="[animationClass]">
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
                    'border-gray-200': !selectedAnswers.includes(option.id),
                    'opacity-80': questionValidated
                  }"
                  @click="!questionValidated && selectAnswer(option.id)"
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
                    'border-gray-200': !selectedAnswers.includes(option.id),
                    'opacity-80': questionValidated
                  }"
                  @click="!questionValidated && selectAnswer(option.id)"
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

              <!-- Explication de la réponse -->
              <div v-if="showExplanation" class="mt-8 p-4" :class="isCurrentAnswerCorrect ? 'bg-green-50 border border-green-200 rounded-lg' : 'bg-red-50 border border-red-200 rounded-lg'">
                <h3 class="font-medium mb-2" :class="isCurrentAnswerCorrect ? 'text-green-800' : 'text-red-800'">{{ isCurrentAnswerCorrect ? 'Vrai' : 'Faux' }}</h3>
                <p :class="isCurrentAnswerCorrect ? 'text-green-700' : 'text-red-700'">{{ currentQuestion.explanation }}</p>
              </div>
            </div>

            <!-- Résultats finaux -->
            <div v-if="isCompleted && !testMode" class="text-center py-8 h-full flex flex-col items-center justify-center max-w-3xl mx-auto">
              <h2 class="text-2xl font-bold text-gray-800 mb-4">Quiz terminé !</h2>
              <p class="text-lg text-gray-700 mb-6">Votre score: {{ score }}/{{ quiz.questions.length }}</p>
              <div class="flex gap-4">
                <button
                  @click="goToStartScreen"
                  class="px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
                >
                  Suivant
                </button>
              </div>
            </div>
          </div>
          <!-- Résultats finaux avec explications -->
            <div v-if="isCompleted && testMode" class="py-8 h-full flex flex-col items-center justify-center max-w-3xl mx-auto">
              <h2 class="text-2xl font-bold text-gray-800 mb-4">Test terminé !</h2>
              <p class="text-lg text-gray-700 mb-6">Votre score: {{ score }}/{{ quiz.questions.length }}</p>

              <!-- Résumé des réponses avec explications -->
              <div class="w-full mb-8 space-y-6 max-h-[70vh] overflow-y-auto pr-2">
                <h3 class="text-xl font-semibold text-gray-700 mb-4 sticky top-0 bg-white py-2 z-10">Résumé des réponses</h3>

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

              <div class="flex gap-4 mt-auto">
                <button
                  @click="goToStartScreen"
                  class="px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
                >
                  Retour à l'accueil
                </button>
                <!-- Le bouton "Générer un nouveau test" a été supprimé -->
              </div>
            </div>
        </div>
      </div>

      <!-- Footer avec navigation (visible uniquement pendant le quiz) -->
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
          Previous
        </button>

        <button
          v-if="!isLastQuestion && !testMode"
          @click="questionValidated ? nextQuestion() : validateQuestion()"
          class="flex items-center px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
        >
          {{ questionValidated ? 'Next' : 'Valider' }}
          <svg v-if="questionValidated" class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
          </svg>
        </button>

        <button
          v-if="!isLastQuestion && testMode"
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
          v-if="isLastQuestion && !testMode"
          @click="questionValidated ? finishQuiz() : validateQuestion()"
          class="flex items-center px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
        >
          {{ questionValidated ? 'Finish' : 'Valider' }}
        </button>

        <button
          v-if="isLastQuestion && testMode"
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
import { ref, computed, onMounted, onUnmounted } from 'vue';
import AppLayout from '../../../components/layout/AppLayout.vue'
import Icon from '@/components/ui/icon/Icon.vue';
import { Button } from '@/components/ui/button';
import QuizMenu from './QuizMenu.vue';
import './animations.css';

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
const showExplanation = ref(false);
const isCompleted = ref(false);
const score = ref(0);
const currentSession = ref(1);
const seconds = ref(0);
const timerInterval = ref<number | null>(null);
const questionsForReview = ref<string[]>([]);
const questionValidated = ref(false);
const testMode = ref(false);
const animationClass = ref('');
const animationTimeout = ref<number | null>(null);
const currentQuizSessionId = ref<number | null>(null);

const currentQuestion = computed(() => {
  return quiz.value.questions[currentQuestionIndex.value];
});

const isLastQuestion = computed(() => {
  return currentQuestionIndex.value === quiz.value.questions.length - 1;
});

const progressPercentage = computed(() => {
  // Au lieu de compter les questions répondues, on utilise l'index de la question actuelle
  return Math.round(((currentQuestionIndex.value + 1) / quiz.value.questions.length) * 100);
});

const timer = computed(() => {
  const minutes = Math.floor(seconds.value / 60);
  const remainingSeconds = seconds.value % 60;
  return `${minutes.toString().padStart(2, '0')}.${remainingSeconds.toString().padStart(2, '0')} Min`;
});

function setTestMode() {
  testMode.value = true;
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

    // Sinon, on utilise le quiz généré par QuizMenu
    isStartScreen.value = false;
    startTimer();
    await createQuizSession();
  } catch (err: unknown) {
    console.error(err instanceof Error ? err.message : 'Erreur inconnue');
    alert('Erreur lors du démarrage du quiz');
  } finally {
    isLoading.value = false;
  }
}

// Supprimer la fonction generateNewQuiz qui est maintenant gérée par QuizMenu


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
  questionValidated.value = false;
  showExplanation.value = false;
}

function updateBlankAnswer() {
  userAnswers.value[currentQuestion.value.id] = [blankAnswer.value];
  questionValidated.value = false;
  showExplanation.value = false;
}

function validateQuestion() {

  if (testMode.value) {
    questionValidated.value = true;
    showExplanation.value = false;
    return;
  }

  questionValidated.value = true;
  showExplanation.value = true;

  triggerAnimation(isCurrentAnswerCorrect.value);

  const questionId = currentQuestion.value.id;
  if (!questionsForReview.value.includes(questionId)) {
    questionsForReview.value.push(questionId);
  }

  reviewQuiz();
}


function triggerAnimation(isCorrect: boolean) {
  // Nettoyer toute animation précédente
  if (animationTimeout.value) {
    clearTimeout(animationTimeout.value);
    animationClass.value = '';
  }

  // Appliquer la nouvelle classe d'animation
  animationClass.value = isCorrect ? 'answer-correct-animation' : 'answer-incorrect-animation';

  // Supprimer la classe après l'animation
  animationTimeout.value = window.setTimeout(() => {
    animationClass.value = '';
    animationTimeout.value = null;
  }, 1500);
}

function nextQuestion() {
  showExplanation.value = false;
  questionValidated.value = false; // (au lieu de seulement en !testMode)

  if (currentQuestionIndex.value < quiz.value.questions.length - 1) {
    currentQuestionIndex.value++;
    loadQuestionState();
  }
}

const hasAnsweredCurrentQuestion = computed(() => {
  if (!currentQuestion.value) return false;
  return !!userAnswers.value[currentQuestion.value.id]?.length;
});

function previousQuestion() {
  showExplanation.value = false;
  questionValidated.value = false;

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
    questionValidated.value = true;
  } else {
    selectedAnswers.value = [];
    blankAnswer.value = '';
    questionValidated.value = false;
  }
}

async function finishQuiz() {
  // En mode test, on s'assure que toutes les questions ont été répondues
  if (testMode.value) {
    const allQuestionsAnswered = quiz.value.questions.every(question =>
      userAnswers.value[question.id] && userAnswers.value[question.id].length > 0
    );

    if (!allQuestionsAnswered) {
      alert('Veuillez répondre à toutes les questions avant de terminer le test.');
      return;
    }
  }

  calculateScore();
  isCompleted.value = true;
  stopTimer();
  
  await updateQuizSession();
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

function resetQuizState() {
  currentQuestionIndex.value = 0;
  selectedAnswers.value = [];
  blankAnswer.value = '';
  userAnswers.value = {};
  showExplanation.value = false;
  score.value = 0;
  seconds.value = 0;
  questionsForReview.value = [];
  questionValidated.value = false;
  currentQuizSessionId.value = null;
}

function restartQuiz() {
  resetQuizState();
  currentSession.value++;
  startTimer();
}

// Nouvelle fonction pour retourner à l'écran de démarrage
function goToStartScreen() {
  resetQuizState();
  isCompleted.value = false;
  isStartScreen.value = true;
}

function reviewQuiz() {
  showExplanation.value = true;
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

const isCurrentAnswerCorrect = computed(() => {
  const userAnswer = userAnswers.value[currentQuestion.value.id] || [];

  if (currentQuestion.value.type === 'fill_in_blank') {
    return userAnswer[0]?.toLowerCase() === currentQuestion.value.correctAnswers[0].toLowerCase();
  } else {
    return userAnswer.length === currentQuestion.value.correctAnswers.length &&
      userAnswer.every(answer => currentQuestion.value.correctAnswers.includes(answer));
  }
});

const isMultipleAnswersQuestion = computed(() => {
  return currentQuestion.value.type === 'multiple_choice' &&
         currentQuestion.value.correctAnswers.length > 1;
});

function getCsrfToken(): string {
  const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]');
  if (!meta) throw new Error('Balise <meta name="csrf-token"> introuvable');
  return meta.content;
}

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
          quiz_mode: testMode.value ? 'test' : 'quiz',
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

    if (!response.ok) {
      const errorData = await response.json();
      console.error('Erreur de sauvegarde:', errorData);
      throw new Error(`Erreur HTTP ${response.status}: ${JSON.stringify(errorData)}`);
    }
    
    console.log('Session sauvegardée avec succès');
  } catch (error) {
    console.error('Erreur lors de la mise à jour de la session:', error);
    console.error('Données envoyées:', {
      completed_at: new Date().toISOString(),
      duration_seconds: seconds.value,
      score: score.value,
      accuracy_percentage: (score.value / quiz.value.questions.length * 100).toFixed(2),
      quiz_session_answers_attributes: quiz.value.questions.map((q: any) => ({
        question_id: q.id,
        user_answers: userAnswers.value[q.id] || [],
        correct_answers: q.correctAnswers
      }))
    });
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