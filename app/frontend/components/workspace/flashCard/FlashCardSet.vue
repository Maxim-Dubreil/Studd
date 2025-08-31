<script setup lang="ts">
  import { Button } from '@/components/ui/button';
  import BackButton from '@/components/ui/button/BackButton.vue';
  import HomeButton from '@/components/ui/button/HomeButton.vue';
  import ResetButton from '@/components/ui/button/ResetButton.vue';
  import { Card } from '@/components/ui/card';
  import {
    Carousel,
    CarouselContent,
    CarouselItem,
    CarouselNext,
    CarouselPrevious,
    type CarouselApi,
  } from '@/components/ui/carousel';
  import Icon from '@/components/ui/icon/Icon.vue';
  import FlashcardTemplate from '@/components/workspace/flashCard/FlashCardTemplate.vue';
  import { computed, onMounted, onUnmounted, ref, watch } from 'vue';
  import AppLayout from '../../../components/layout/AppLayout.vue';

  interface props {
    content: Flashcard[];
    workspace_id: number;
    collectionName?: string;
  }
  const props = defineProps<props>();

  const qs = new URLSearchParams(window.location.search);
  const fallbackName = qs.get('name') || '';

  const title = computed(() => props.collectionName || fallbackName || '');
  const titleLetters = computed(() => (title.value || '').split(''));

  const api = ref<CarouselApi>();
  const current = ref(0);
  const total = ref(0);
  const flippedStates = ref<Record<number, boolean>>({});

  /*  Fonction de « restart » ------------------------------------------ */
  function resetSeries() {
    finished.value = false;
    current.value = 0;
    correctAnswers.value = 0;
    wrongAnswers.value = 0;
    api.value?.scrollTo(0, true);
    flippedStates.value = {};
  }

  function initApi(val?: CarouselApi) {
    if (!val) return;

    api.value = val;
    total.value = val.scrollSnapList().length;
    current.value = val.selectedScrollSnap();

    val.on('select', () => {
      current.value = val.selectedScrollSnap();
      flippedStates.value = {};
    });
  }

  const finished = ref(false);

  const correctAnswers = ref(0);
  const wrongAnswers = ref(0);

  const correctAnswersPercentage = computed(() => {
    const total = correctAnswers.value + wrongAnswers.value;
    if (total === 0) return 0;

    // → on calcule le ratio * 100 puis on arrondit à l'entier le plus proche
    return Math.round((correctAnswers.value / total) * 100);
  });

  watch([correctAnswers, wrongAnswers], () => {
    const totalAnswered = correctAnswers.value + wrongAnswers.value;
    finished.value = totalAnswered >= total.value && total.value > 0;
  });

  interface Flashcard {
    id: number;
    term: string;
    definition: string;
    color: string;
  }

  function setFlipState() {}

  const isGrabbing = ref(false);

  const onPointerDown = () => {
    isGrabbing.value = true;
  };
  const onPointerUpLike = () => {
    isGrabbing.value = false;
  };

  onMounted(() => {
    document.body.style.cursor = `url(/icons/hand.svg) 16 16, grab`;
    window.addEventListener('pointerdown', onPointerDown, { passive: true });
    window.addEventListener('pointerup', onPointerUpLike, { passive: true });
    window.addEventListener('pointercancel', onPointerUpLike, { passive: true });
    window.addEventListener('blur', onPointerUpLike); // si la fenêtre perd le focus
  });

  onUnmounted(() => {
    window.removeEventListener('pointerdown', onPointerDown);
    window.removeEventListener('pointerup', onPointerUpLike);
    window.removeEventListener('pointercancel', onPointerUpLike);
    window.removeEventListener('blur', onPointerUpLike);
    document.body.style.cursor = '';
  });
</script>

<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="true">
    <BackButton :href="`/workspaces/${props.workspace_id}/flashcards`" />
    <HomeButton :href="`/dashboard`" />

    <div
      class="fixed inset-0 z-40"
      :style="{
        cursor: isGrabbing
          ? 'url(/icons/hand-grab.svg) 16 16, grabbing'
          : 'url(/icons/hand.svg) 16 16, grab',
      }"
    >
      <div class="mt-12 text-center">
        <h2
          class="motion-safe:animate-float text-4xl font-extrabold tracking-tight text-slate-900 sm:text-4xl lg:text-4xl dark:text-slate-100"
        >
          <span
            class="motion-safe:animate-shimmer inline-block bg-gradient-to-r from-fuchsia-500 via-violet-500 to-indigo-500 [background-size:260%_100%] bg-clip-text align-middle text-transparent"
          >
            Collection :
          </span>
          <span class="mx-2 font-semibold text-slate-800 dark:text-slate-200"></span>
          <span
            v-for="(ch, i) in titleLetters"
            :key="i"
            class="wave-letter"
            :style="{ animationDelay: i * 90 + 'ms' }"
          >
            {{ ch }}
          </span>
        </h2>

        <div
          class="motion-safe:animate-glow mx-auto mt-2 h-1 w-38 rounded-full bg-gradient-to-r from-fuchsia-500 via-violet-500 to-indigo-500/80"
        ></div>
      </div>

      <div class="fixed inset-0 flex flex-col items-center justify-center">
        <div class="absolute bottom-20 z-50">
          <ResetButton label="Restart the quizz" @click="resetSeries" />
        </div>

        <div v-if="finished" class="flex min-h-screen flex-col items-center justify-center px-4">
          <div class="mx-auto max-w-md text-center">
            <div class="mb-8">
              <div
                v-if="correctAnswersPercentage >= 80"
                class="mx-auto mb-4 flex h-24 w-24 animate-bounce items-center justify-center rounded-full bg-gradient-to-r from-green-400 to-emerald-500"
              >
                <Icon name="ShieldCheck" class="h-12 w-12 text-white" />
              </div>
              <div
                v-else-if="correctAnswersPercentage >= 60"
                class="mx-auto mb-4 flex h-24 w-24 items-center justify-center rounded-full bg-gradient-to-r from-yellow-400 to-orange-500"
              >
                <Icon name="Smile" class="h-12 w-12 text-white" />
              </div>
              <div
                v-else
                class="mx-auto mb-4 flex h-24 w-24 items-center justify-center rounded-full bg-gradient-to-r from-red-400 to-pink-500"
              >
                <Icon name="BookOpen" class="h-12 w-12 text-white" />
              </div>
            </div>

            <div class="mb-6">
              <h2
                v-if="correctAnswersPercentage >= 80"
                class="mb-2 text-4xl font-bold text-green-600"
              >
                Excellent! 🎉
              </h2>
              <h2
                v-else-if="correctAnswersPercentage >= 60"
                class="mb-2 text-4xl font-bold text-yellow-600"
              >
                Well done! 👍
              </h2>
              <h2 v-else class="mb-2 text-4xl font-bold text-red-500">Keep going! 💪</h2>

              <p
                v-if="correctAnswersPercentage >= 80"
                class="text-lg text-gray-600 dark:text-gray-300"
              >
                Perfect! You have mastered the subject.
              </p>
              <p
                v-else-if="correctAnswersPercentage >= 60"
                class="text-lg text-gray-600 dark:text-gray-300"
              >
                Good work! Just a little more effort for perfection.
              </p>
              <p v-else class="text-lg text-gray-600 dark:text-gray-300">
                Don't get discouraged, practice makes perfect!
              </p>
            </div>

            <Card class="mb-8 p-6">
              <div class="grid grid-cols-3 gap-4 text-center">
                <div>
                  <div class="text-2xl font-bold text-green-600">{{ correctAnswers }}</div>
                  <div class="text-muted-foreground text-sm">Correct</div>
                </div>
                <div>
                  <div class="text-2xl font-bold text-red-500">{{ wrongAnswers }}</div>
                  <div class="text-muted-foreground text-sm">Wrong</div>
                </div>
                <div>
                  <div class="text-primary text-2xl font-bold">{{ correctAnswersPercentage }}%</div>
                  <div class="text-muted-foreground text-sm">Score</div>
                </div>
              </div>

              <div class="mt-4">
                <div class="bg-secondary h-3 w-full rounded-full">
                  <div
                    class="h-3 rounded-full transition-all duration-500 ease-out"
                    :class="{
                      'bg-gradient-to-r from-green-400 to-emerald-500':
                        correctAnswersPercentage >= 80,
                      'bg-gradient-to-r from-yellow-400 to-orange-500':
                        correctAnswersPercentage >= 60 && correctAnswersPercentage < 80,
                      'bg-gradient-to-r from-red-400 to-pink-500': correctAnswersPercentage < 60,
                    }"
                    :style="`width: ${correctAnswersPercentage}%`"
                  ></div>
                </div>
              </div>
            </Card>

            <div class="flex flex-col justify-center gap-4 sm:flex-row">
              <Button variant="gradient" as="a" :href="`/workspaces/${workspace_id}/flashcards`">
                <Icon name="circle-chevron-left" />
                Back to collections
              </Button>
              <Button variant="gradient" as="a" :href="`/workspaces/${workspace_id}`">
                <Icon name="home" />
                Back to workspace
              </Button>
            </div>
          </div>
        </div>

        <Carousel
          v-else
          @init-api.once="initApi"
          class="flex w-full max-w-4xl flex-col items-center gap-4 px-4"
        >
          <div>
            <CarouselContent class="w-full">
              <CarouselItem
                v-for="card in props.content"
                :key="card.id"
                class="flex items-center justify-center py-35"
              >
                <FlashcardTemplate
                  :term="card.term"
                  :definition="card.definition"
                  :color="card.color"
                  v-model="flippedStates[card.id]"
                  @correct="correctAnswers++"
                  @wrong="wrongAnswers++"
                  :question-number="props.content.indexOf(card) + 1"
                />
              </CarouselItem>
            </CarouselContent>
            <CarouselPrevious />
            <CarouselNext />
          </div>

          <div class="m-10 mt-6 flex justify-center gap-2">
            <span
              v-for="idx in total"
              :key="idx - 1"
              aria-hidden="true"
              class="h-3 w-3 cursor-default rounded-full"
              :class="idx - 1 === current ? 'bg-indigo-600' : 'bg-gray-300/60'"
            />
          </div>
        </Carousel>
        <div
          class="absolute right-10 bottom-8 z-50 rounded-xl bg-gradient-to-r from-violet-500/80 to-indigo-500/80 px-6 py-2 text-lg font-semibold text-white shadow-lg ring-2 ring-violet-300/40 backdrop-blur-md"
        >
          <Icon name="hand-point-up" class="mr-2 inline-block h-6 w-6 text-white opacity-80" />
          Finish to see your results
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<style scoped>
  @media (prefers-reduced-motion: no-preference) {
    @keyframes float {
      0%,
      100% {
        transform: translateY(0);
      }
      50% {
        transform: translateY(-6px);
      }
    }
    @keyframes shimmer {
      0% {
        background-position: 0% 50%;
      }
      100% {
        background-position: 100% 50%;
      }
    }
    @keyframes glow {
      0%,
      100% {
        box-shadow: 0 0 0 rgba(124, 58, 237, 0);
      }
      50% {
        box-shadow: 0 0 24px rgba(124, 58, 237, 0.35);
      }
    }

    .animate-float,
    .motion-safe\:animate-float {
      animation: float 4s ease-in-out infinite;
    }
    .animate-shimmer,
    .motion-safe\:animate-shimmer {
      animation: shimmer 2.8s linear infinite;
      background-size: 260% 100%;
    }
    .animate-glow,
    .motion-safe\:animate-glow {
      animation: glow 2.3s ease-in-out infinite;
    }

    /* --- vague lente lettre par lettre --- */
    @keyframes wave {
      0%,
      100% {
        transform: translateY(0);
      }
      50% {
        transform: translateY(-8px);
      }
    }
    .wave-letter {
      display: inline-block;
      will-change: transform;
      animation: wave 2.6s ease-in-out infinite;
    }
  }
</style>
