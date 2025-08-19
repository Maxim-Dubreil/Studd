<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="true">
    <!-- Structure principale -->  
    <div class="flex flex-col h-screen">
      <!-- Header -->  
      <div v-if="!isCompleted" class="h-24 max-w-6xl w-full mx-auto p-6">
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

          <div class="flex items-center">
            <span class="text-sm font-medium text-gray-700">{{ timer }}</span>
          </div>
        </div>
      </div>

      <!-- Conteneur principal -->  
      <div class="flex-1 flex items-center justify-center py-4">
        <div class="max-w-6xl w-full mx-auto h-[500px] bg-white rounded-3xl shadow-xl overflow-hidden flex flex-col">
          <div class="p-6 bg-gray-50 flex-grow overflow-y-auto">
            <!-- Affichage des questions -->  
            <div v-if="currentQuestion && !isCompleted">
              <h2 class="text-xl font-medium text-gray-800 mb-6">Question {{ currentQuestionIndex + 1 }}</h2>
              <p class="text-lg text-gray-700 mb-8">{{ currentQuestion.question }}</p>

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

              <!-- Questions à compléter -->  
              <div v-else-if="currentQuestion.type === 'fill_in_blank'" class="space-y-4">
                <div class="p-4 bg-white border border-gray-200 rounded-xl shadow-sm" :class="{'opacity-80': questionValidated}">
                  <input
                    type="text"
                    v-model="blankAnswer"
                    class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                    placeholder="Votre réponse..."
                    @input="updateBlankAnswer"
                    :disabled="questionValidated"
                  />
                </div>
              </div>

              <!-- Explication de la réponse -->  
              <div v-if="showExplanation" class="mt-8 p-4" :class="isCurrentAnswerCorrect ? 'bg-green-50 border border-green-200 rounded-lg' : 'bg-red-50 border border-red-200 rounded-lg'">
                <h3 class="font-medium mb-2" :class="isCurrentAnswerCorrect ? 'text-green-800' : 'text-red-800'">{{ isCurrentAnswerCorrect ? 'Vrai' : 'Faux' }}</h3>
                <p :class="isCurrentAnswerCorrect ? 'text-green-700' : 'text-red-700'">{{ currentQuestion.explanation }}</p>
              </div>
            </div>

            <!-- Résultats finaux -->  
            <div v-if="isCompleted" class="text-center py-8 h-full flex flex-col items-center justify-center">
              <h2 class="text-2xl font-bold text-gray-800 mb-4">Quiz terminé !</h2>
              <p class="text-lg text-gray-700 mb-6">Votre score: {{ score }}/{{ quiz.questions.length }}</p>
              <button
                @click="restartQuiz"
                class="px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
              >
                Recommencer
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Footer avec navigation -->  
      <div v-if="!isCompleted" class="h-24 max-w-6xl w-full mx-auto p-6 flex justify-between">
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
          v-if="!isLastQuestion"
          @click="questionValidated ? nextQuestion() : validateQuestion()"
          class="flex items-center px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
        >
          {{ questionValidated ? 'Next' : 'Valider' }}
          <svg v-if="questionValidated" class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
          </svg>
        </button>

        <button
          v-else
          @click="questionValidated ? finishQuiz() : validateQuestion()"
          class="flex items-center px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
        >
          {{ questionValidated ? 'Finish' : 'Valider' }}
        </button>
      </div>
    </div>
  </AppLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import AppLayout from '../../../components/layout/AppLayout.vue'
import Icon from '@/components/ui/icon/Icon.vue'

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

const props = withDefaults(defineProps<Props>(), {
  quizData: undefined
});

const quiz = ref<Quiz>(props.quizData || {
  "quizId": "quiz_001",
  "title": "Révision sur les bases de Git",
  "description": "Un quiz pour tester tes connaissances sur Git.",
  "questions": [
    {
      "id": "q1",
      "type": "multiple_choice",
      "question": "Quelle commande permet de créer une nouvelle branche ?",
      "options": [
        { "id": "a", "text": "git branch nouvelle_branche" },
        { "id": "b", "text": "git checkout nouvelle_branche" },
        { "id": "c", "text": "git init nouvelle_branche" }
      ],
      "correctAnswers": ["a"],
      "explanation": "On crée une branche avec `git branch <nom>`. La commande `git checkout` sert à changer de branche."
    },
    {
      "id": "q2",
      "type": "true_false",
      "question": "La commande `git clone` sert à créer un nouveau commit.",
      "correctAnswers": ["false"],
      "explanation": "`git clone` sert à copier un dépôt existant, pas à créer un commit."
    },
    {
      "id": "q3",
      "type": "fill_in_blank",
      "question": "La commande pour voir l'historique des commits est `git _____`.",
      "correctAnswers": ["log"],
      "explanation": "`git log` permet d'afficher l'historique des commits."
    }
  ]
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

const currentQuestion = computed(() => {
  return quiz.value.questions[currentQuestionIndex.value];
});

const isLastQuestion = computed(() => {
  return currentQuestionIndex.value === quiz.value.questions.length - 1;
});

const progressPercentage = computed(() => {
  const answeredQuestionsCount = Object.keys(userAnswers.value).length;
  return Math.round((answeredQuestionsCount / quiz.value.questions.length) * 100);
});

const timer = computed(() => {
  const minutes = Math.floor(seconds.value / 60);
  const remainingSeconds = seconds.value % 60;
  return `${minutes.toString().padStart(2, '0')}.${remainingSeconds.toString().padStart(2, '0')} Min`;
});

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
  questionValidated.value = true;
  showExplanation.value = true;
  
  const questionId = currentQuestion.value.id;
  if (!questionsForReview.value.includes(questionId)) {
    questionsForReview.value.push(questionId);
  }
  
  reviewQuiz();
}

function nextQuestion() {
  showExplanation.value = false;
  questionValidated.value = false;

  if (currentQuestionIndex.value < quiz.value.questions.length - 1) {
    currentQuestionIndex.value++;
    loadQuestionState();
  }
}

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

function finishQuiz() {
  calculateScore();
  isCompleted.value = true;
  stopTimer();
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

function restartQuiz() {
  currentQuestionIndex.value = 0;
  selectedAnswers.value = [];
  blankAnswer.value = '';
  userAnswers.value = {};
  showExplanation.value = false;
  isCompleted.value = false;
  score.value = 0;
  seconds.value = 0;
  questionsForReview.value = [];
  currentSession.value++;
  questionValidated.value = false;
  startTimer();
}

function markForReview() {
  const questionId = currentQuestion.value.id;
  if (!questionsForReview.value.includes(questionId)) {
    questionsForReview.value.push(questionId);
  }
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
  startTimer();
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
</script>