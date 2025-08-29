<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="true">
    <!-- Main Structure -->
    <div class="flex flex-col h-screen">
      <!-- Header (visible only during quiz) -->
      <div v-if="!isStartScreen && !isCompleted" class="max-w-6xl w-full mx-auto p-6">
        <a
          :href="`/workspaces/${props.workspace_id}`"
          class="bg-card/50 hover:bg-card/80 absolute top-4 left-4 rounded-lg border p-2 backdrop-blur-sm z-10 transition-all"
        >
          <Icon name="arrow-left" class="h-5 w-5" />
        </a>
        
        <!-- Quiz Info -->
        <div class="text-center mb-6">
          <h1 class="text-xl font-semibold text-foreground mb-1">{{ quiz.title }}</h1>
          <p class="text-sm text-muted-foreground">Session {{ currentSession }}</p>
        </div>

        <!-- Progress and Timer -->
        <div class="max-w-2xl mx-auto">
          <div class="flex items-center justify-between mb-2">
            <div class="flex items-center gap-2">
              <Icon name="clock" class="h-4 w-4 text-muted-foreground" />
              <span class="text-sm font-medium text-foreground">{{ timer }}</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="text-sm text-muted-foreground">Question {{ currentQuestionIndex + 1 }} of {{ quiz.questions.length }}</span>
              <span class="text-sm font-medium text-foreground">{{ progressPercentage }}%</span>
            </div>
          </div>
          <div class="w-full bg-muted rounded-full h-2">
            <div
              class="bg-primary h-2 rounded-full transition-all duration-500 ease-out"
              :style="{ width: progressPercentage + '%' }"
            ></div>
          </div>
        </div>
      </div>

      <!-- Main Container -->
      <div class="flex-1 flex items-center justify-center py-4">
        <!-- Start Screen with QuizMenu -->
        <div v-if="isStartScreen" class="flex flex-col items-center justify-center min-h-screen p-6">
          <!-- Loading display during generation -->
          <div v-if="isLoading" class="flex flex-col items-center justify-center h-[600px]">
            <svg class="animate-spin h-12 w-12 mb-4" viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-dasharray="60" stroke-dashoffset="20" />
            </svg>
            <p class="text-lg">Generating quiz...</p>
          </div>

          <!-- QuizMenu instead of start button -->
          <div v-else>
            <QuizMenu
              :workspaceId="props.workspace_id"
              :hasQuiz="hasQuiz"
              @launchQuiz="startQuiz()"
              @testMode="setTestMode"
              @quizGenerated="handleQuizGenerated"
            />
          </div>
        </div>

        <!-- Quiz Content -->
        <div v-else class="w-full max-w-6xl mx-auto flex flex-col" style="height: calc(100vh - 180px);">
          <div class="bg-white rounded-3xl shadow-xl flex-1 flex flex-col overflow-hidden" :class="[animationClass]">
            <div class="flex-1 flex flex-col overflow-hidden">
              <!-- Question Display -->
              <div v-if="currentQuestion && !isCompleted" class="flex-1 flex flex-col p-6">
                <div class="mb-6">
                  <h2 class="text-xl font-bold text-foreground mb-3">Question {{ currentQuestionIndex + 1 }}</h2>
                  <p class="text-lg text-foreground leading-relaxed">{{ currentQuestion.question }}</p>
                </div>

                <!-- Navigation Buttons -->
                <div class="flex items-center justify-center gap-3 mb-6">
                  <Button
                    @click="previousQuestion"
                    variant="outline"
                    size="sm"
                    :disabled="currentQuestionIndex === 0"
                  >
                    <Icon name="chevron-left" class="h-4 w-4 mr-1" />
                    Previous
                  </Button>

                  <Button
                    v-if="!isLastQuestion && !testMode"
                    @click="questionValidated ? nextQuestion() : validateQuestion()"
                    variant="default"
                    size="sm"
                  >
                    {{ questionValidated ? 'Next' : 'Validate' }}
                    <Icon :name="questionValidated ? 'chevron-right' : 'check'" class="h-4 w-4 ml-1" />
                  </Button>

                  <Button
                    v-if="!isLastQuestion && testMode"
                    @click="nextQuestion"
                    variant="default"
                    size="sm"
                    :disabled="!hasAnsweredCurrentQuestion"
                  >
                    Next
                    <Icon name="chevron-right" class="h-4 w-4 ml-1" />
                  </Button>

                  <Button
                    v-if="isLastQuestion && !testMode"
                    @click="questionValidated ? finishQuiz() : validateQuestion()"
                    variant="default"
                    size="sm"
                  >
                    {{ questionValidated ? 'Finish' : 'Validate' }}
                    <Icon :name="questionValidated ? 'flag' : 'check'" class="h-4 w-4 ml-1" />
                  </Button>

                  <Button
                    v-if="isLastQuestion && testMode"
                    @click="finishQuiz"
                    variant="default"
                    size="sm"
                    :disabled="!hasAnsweredCurrentQuestion"
                  >
                    Finish
                    <Icon name="flag" class="h-4 w-4 ml-1" />
                  </Button>
                </div>

                <!-- Separator between navigation and answers -->
                <div class="h-px bg-border w-full mb-6"></div>

                <!-- Multiple Choice Questions -->
                <div v-if="currentQuestion.type === 'multiple_choice'" class="flex-1 overflow-y-auto">
                  <div class="space-y-4 pb-4">
                    <div
                      v-for="option in currentQuestion.options"
                      :key="option.id"
                      class="flex items-start p-4 bg-white border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors cursor-pointer shadow-sm"
                      :class="{
                        'border-purple-500 bg-purple-50 shadow-md shadow-purple-200': selectedAnswers.includes(option.id),
                        'border-gray-200': !selectedAnswers.includes(option.id),
                        'opacity-80': questionValidated
                      }"
                      @click="!questionValidated && selectAnswer(option.id)"
                    >
                      <div class="w-6 h-6 rounded-full border-2 flex items-center justify-center mr-3 mt-0.5 flex-shrink-0"
                        :class="{
                          'border-purple-500': selectedAnswers.includes(option.id),
                          'border-gray-300': !selectedAnswers.includes(option.id)
                        }">
                        <div v-if="selectedAnswers.includes(option.id)" class="w-3 h-3 rounded-full bg-purple-500"></div>
                      </div>
                      <span class="leading-relaxed">{{ option.text }}</span>
                    </div>
                  </div>
                </div>

                <!-- True/False Questions -->
                <div v-else-if="currentQuestion.type === 'true_false'" class="flex-1 overflow-y-auto">
                  <div class="space-y-4 pb-4">
                    <div
                      v-for="option in [{id: 'true', text: 'True'}, {id: 'false', text: 'False'}]"
                      :key="option.id"
                      class="flex items-center p-4 bg-white border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors cursor-pointer shadow-sm"
                      :class="{
                        'border-purple-500 bg-purple-50 shadow-md shadow-purple-200': selectedAnswers.includes(option.id),
                        'border-gray-200': !selectedAnswers.includes(option.id),
                        'opacity-80': questionValidated
                      }"
                      @click="!questionValidated && selectAnswer(option.id)"
                    >
                      <div class="w-6 h-6 rounded-full border-2 flex items-center justify-center mr-3 flex-shrink-0"
                        :class="{
                          'border-purple-500': selectedAnswers.includes(option.id),
                          'border-gray-300': !selectedAnswers.includes(option.id)
                        }">
                        <div v-if="selectedAnswers.includes(option.id)" class="w-3 h-3 rounded-full bg-purple-500"></div>
                      </div>
                      <span class="leading-relaxed">{{ option.text }}</span>
                    </div>
                  </div>
                </div>

                <!-- Answer Explanation -->
                <div v-if="showExplanation" class="mt-6 p-4 rounded-lg border" :class="isCurrentAnswerCorrect ? 'bg-green-50 border-green-200' : 'bg-red-50 border-red-200'">
                  <h3 class="font-medium mb-2" :class="isCurrentAnswerCorrect ? 'text-green-800' : 'text-red-800'">
                    {{ isCurrentAnswerCorrect ? 'Correct!' : 'Incorrect' }}
                  </h3>
                  <p class="leading-relaxed" :class="isCurrentAnswerCorrect ? 'text-green-700' : 'text-red-700'">
                    {{ currentQuestion.explanation }}
                  </p>
                </div>
              </div>

              <!-- Learning Mode Results -->
              <div v-if="isCompleted && !testMode" class="flex-1 flex flex-col items-center justify-center p-6">
                <div class="max-w-2xl w-full">
                  <!-- Success Animation & Icon -->
                  <div class="text-center mb-8">
                    <div class="inline-flex items-center justify-center w-20 h-20 bg-green-100 rounded-full mb-4">
                      <Icon name="check-circle" class="w-10 h-10 text-green-600" />
                    </div>
                    <h2 class="text-3xl font-bold text-foreground mb-2">Learning Complete!</h2>
                    <p class="text-muted-foreground text-lg">Great job on completing the learning session</p>
                  </div>

                  <!-- Score Card -->
                  <div class="bg-gradient-to-r from-green-50 to-emerald-50 border border-green-200 rounded-xl p-6 mb-6">
                    <div class="flex items-center justify-between">
                      <div>
                        <h3 class="text-lg font-semibold text-green-800 mb-1">Your Performance</h3>
                        <p class="text-green-600 text-sm">Questions answered correctly</p>
                      </div>
                      <div class="text-right">
                        <div class="text-3xl font-bold text-green-700">{{ score }}</div>
                        <div class="text-sm text-green-600">out of {{ quiz.questions.length }}</div>
                      </div>
                    </div>
                    
                    <!-- Progress Bar -->
                    <div class="mt-4">
                      <div class="flex justify-between text-sm text-green-600 mb-2">
                        <span>Accuracy</span>
                        <span>{{ Math.round((score / quiz.questions.length) * 100) }}%</span>
                      </div>
                      <div class="w-full bg-green-200 rounded-full h-2">
                        <div 
                          class="bg-green-600 h-2 rounded-full transition-all duration-500" 
                          :style="{ width: Math.round((score / quiz.questions.length) * 100) + '%' }"
                        ></div>
                      </div>
                    </div>
                  </div>

                  <!-- Action Buttons -->
                  <div class="flex flex-col sm:flex-row gap-3 justify-center">
                    <Button
                      @click="goToWorkspace"
                      variant="default"
                      size="lg"
                      class="flex-1 sm:flex-none"
                    >
                      <Icon name="check" class="w-4 h-4 mr-2" />
                      End
                    </Button>
                    <Button
                      @click="retryQuiz"
                      variant="outline"
                      size="lg"
                      class="flex-1 sm:flex-none"
                    >
                      <Icon name="refresh-cw" class="w-4 h-4 mr-2" />
                      Try Again
                    </Button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- Exam Mode Results with Explanations -->
          <div v-if="isCompleted && testMode" class="flex-1 flex flex-col p-6">
            <!-- Header with Score -->
            <div class="text-center mb-6">
              <div class="inline-flex items-center justify-center w-16 h-16 rounded-full mb-4" :class="getScoreColor().bg">
                <Icon :name="getScoreIcon()" class="w-8 h-8" :class="getScoreColor().text" />
              </div>
              <h2 class="text-3xl font-bold text-foreground mb-2">Exam Completed!</h2>
              <div class="inline-flex items-center gap-4 bg-card rounded-lg border p-4">
                <div class="text-center">
                  <div class="text-2xl font-bold text-foreground">{{ score }}/{{ quiz.questions.length }}</div>
                  <div class="text-sm text-muted-foreground">Score</div>
                </div>
                <div class="h-10 w-px bg-border"></div>
                <div class="text-center">
                  <div class="text-2xl font-bold" :class="getScoreColor().text">{{ Math.round((score / quiz.questions.length) * 100) }}%</div>
                  <div class="text-sm text-muted-foreground">Accuracy</div>
                </div>
              </div>
            </div>

            <!-- Answer Summary with Explanations -->
            <div class="flex-1 overflow-hidden">
              <h3 class="text-xl font-semibold text-foreground mb-4 flex items-center">
                <Icon name="list" class="w-5 h-5 mr-2" />
                Detailed Review
              </h3>
              
              <div class="h-full overflow-y-auto pr-2 space-y-4">
                <div v-for="(question, index) in quiz.questions" :key="question.id" class="bg-card border rounded-xl p-4 transition-all hover:shadow-md">
                  <!-- Question Header -->
                  <div class="flex items-start gap-3 mb-4">
                    <div class="flex-shrink-0 w-6 h-6 rounded-full flex items-center justify-center text-xs font-medium" :class="isAnswerCorrect(question) ? 'bg-green-100 text-green-600' : 'bg-red-100 text-red-600'">
                      {{ index + 1 }}
                    </div>
                    <div class="flex-1">
                      <h4 class="font-medium text-foreground mb-2">{{ question.question }}</h4>
                    </div>
                    <Icon :name="isAnswerCorrect(question) ? 'check-circle' : 'x-circle'" class="w-5 h-5" :class="isAnswerCorrect(question) ? 'text-green-500' : 'text-red-500'" />
                  </div>

                  <!-- Answers Comparison -->
                  <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <!-- Your Answer -->
                    <div class="space-y-2">
                      <div class="text-sm font-medium text-muted-foreground">Your Answer</div>
                      <div class="p-3 rounded-lg bg-muted/50">
                        <span v-if="question.type === 'fill_in_blank'" class="text-sm">
                          {{ userAnswers[question.id]?.[0] || 'Not answered' }}
                        </span>
                        <span v-else-if="question.type === 'true_false'" class="text-sm">
                          {{ userAnswers[question.id]?.[0] === 'true' ? 'True' : userAnswers[question.id]?.[0] === 'false' ? 'False' : 'Not answered' }}
                        </span>
                        <span v-else class="text-sm">
                          {{ userAnswers[question.id] ?
                            question.options?.filter((opt: Option) => userAnswers[question.id].includes(opt.id)).map((opt: Option) => opt.text).join(', ') :
                            'Not answered' }}
                        </span>
                      </div>
                    </div>

                    <!-- Correct Answer -->
                    <div class="space-y-2">
                      <div class="text-sm font-medium text-muted-foreground">Correct Answer</div>
                      <div class="p-3 rounded-lg bg-green-50 border border-green-200">
                        <span v-if="question.type === 'fill_in_blank'" class="text-sm text-green-700">
                          {{ question.correctAnswers[0] }}
                        </span>
                        <span v-else-if="question.type === 'true_false'" class="text-sm text-green-700">
                          {{ question.correctAnswers[0] === 'true' ? 'True' : 'False' }}
                        </span>
                        <span v-else class="text-sm text-green-700">
                          {{ question.options?.filter((opt: Option) => question.correctAnswers.includes(opt.id)).map((opt: Option) => opt.text).join(', ') }}
                        </span>
                      </div>
                    </div>
                  </div>

                  <!-- Explanation -->
                  <div class="bg-blue-50 border border-blue-200 rounded-lg p-3">
                    <div class="flex items-start gap-2">
                      <Icon name="info" class="w-4 h-4 text-blue-600 mt-0.5 flex-shrink-0" />
                      <p class="text-sm text-blue-700 leading-relaxed">{{ question.explanation }}</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row gap-3 justify-center mt-6 pt-4 border-t">
              <Button
                @click="goToWorkspace"
                variant="default"
                size="lg"
                class="flex-1 sm:flex-none"
              >
                <Icon name="check" class="w-4 h-4 mr-2" />
                End
              </Button>
              <Button
                @click="retryQuiz"
                variant="outline"
                size="lg"
                class="flex-1 sm:flex-none"
              >
                <Icon name="refresh-cw" class="w-4 h-4 mr-2" />
                Retake Exam
              </Button>
            </div>
          </div>
        </div>
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
  hasQuiz?: boolean;
}

const props = defineProps<Props>();

// State for start screen
const isStartScreen = ref(true);
const isLoading = ref(false);
const hasQuiz = ref(props.hasQuiz ?? !!props.quizData);

// Quiz state
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

// Function to start or generate a quiz
async function startQuiz(): Promise<void> {
  if (!hasQuiz.value) {
    alert('Please generate a quiz first');
    return;
  }
  
  isLoading.value = true;
  try {
    // If a quiz already exists in props, use it directly
    if (props.quizData) {
      isStartScreen.value = false;
      startTimer();
      await createQuizSession();
      return;
    }

    // Otherwise, use the quiz generated by QuizMenu
    isStartScreen.value = false;
    startTimer();
    await createQuizSession();
  } catch (err: unknown) {
    console.error(err instanceof Error ? err.message : 'Unknown error');
    alert('Error starting quiz');
  } finally {
    isLoading.value = false;
  }
}

// Function to handle quiz generation
function handleQuizGenerated(): void {
  hasQuiz.value = true;
}

// generateNewQuiz function is now handled by QuizMenu


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
    // En mode Learning, ne pas valider automatiquement pour permettre de revoir les explications
    // En mode Test, les questions sont déjà validées automatiquement
    questionValidated.value = testMode.value;
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
  testMode.value = false;
  currentQuizSessionId.value = null;
}

function restartQuiz() {
  resetQuizState();
  currentSession.value++;
  startTimer();
}

// Function to go back to workspace
function goToWorkspace() {
  window.location.href = `/workspaces/${props.workspace_id}`;
}

// Function to retry the quiz (go back to quiz show)
function retryQuiz() {
  window.location.href = `/workspaces/${props.workspace_id}/quiz`;
}

// Function to return to start screen
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
          quiz_id: (props.quizData as any)?.id || (quiz.value as any).id || 1,
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

// Helper functions for score display
function getScoreColor() {
  const percentage = Math.round((score.value / quiz.value.questions.length) * 100);
  
  if (percentage >= 80) {
    return { bg: 'bg-green-100', text: 'text-green-600' };
  } else if (percentage >= 60) {
    return { bg: 'bg-yellow-100', text: 'text-yellow-600' };
  } else {
    return { bg: 'bg-red-100', text: 'text-red-600' };
  }
}

function getScoreIcon() {
  const percentage = Math.round((score.value / quiz.value.questions.length) * 100);
  
  if (percentage >= 80) {
    return 'trophy';
  } else if (percentage >= 60) {
    return 'award';
  } else {
    return 'target';
  }
}

</script>