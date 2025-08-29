<script setup lang="ts">
  import FlashcardTemplate from '@/components/workspace/flashCard/FlashCardTemplate.vue';
  import {
    Carousel,
    CarouselContent,
    CarouselItem,
    type CarouselApi,
  } from '@/components/ui/carousel';
  import { ArrowLeft, RotateCcw } from 'lucide-vue-next';
  import { computed, ref, watch } from 'vue';
  import AppLayout from '../../../components/layout/AppLayout.vue';
  import { Button } from '@/components/ui/button';
  import { Card } from '@/components/ui/card';
  import Icon from '@/components/ui/icon/Icon.vue';

  interface props {
    content: Flashcard[];
    workspace_id: number;
  }

  const props = defineProps<props>();

  const api = ref<CarouselApi>();
  const current = ref(0);
  const total = ref(0);
  const flippedStates = ref<Record<number, boolean>>({});

  /* ------------------------------------------------------------------ */
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
      flippedStates.value = {}; // Réinitialise l'état de retournement à chaque changement de carte
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

  // function handleLog() {
  //   console.log(correctAnswersPercentage.value)
  //   console.log(correctAnswers.value)
  //   console.log(wrongAnswers.value)
  // }

  // On ne met plus finished à true automatiquement quand on arrive à la dernière carte
  // watch(current, (index) => {
  //   finished.value = index >= total.value - 1;
  // });
  
  // Plutôt, on vérifie si on a répondu à toutes les questions
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

  //props a rajouter
</script>

<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="true">
    <div class="fixed inset-0 flex flex-col items-center justify-center">
      <div class="absolute top-8 left-8 z-10 flex items-center gap-4">
        <a
          :href="`/workspaces/${props.workspace_id}/flashcards`"
          class="rounded-full bg-gray-800/50 p-2 text-white transition-colors hover:bg-gray-800/80"
        >
          <ArrowLeft class="h-6 w-6" />
        </a>
        <button
          @click="resetSeries"
          title="Recommencer à zéro"
          class="rounded-full bg-gray-800/50 p-2 text-white transition-colors hover:bg-gray-800/80"
        >
          <RotateCcw class="h-6 w-6" />
        </button>
      </div>

      <div v-if="finished" class="flex flex-col items-center justify-center min-h-screen px-4">
        <div class="text-center max-w-md mx-auto">
          <div class="mb-8">
            <div v-if="correctAnswersPercentage >= 80" 
                 class="w-24 h-24 mx-auto mb-4 rounded-full bg-gradient-to-r from-green-400 to-emerald-500 flex items-center justify-center animate-bounce">
              <Icon name="ShieldCheck" class="w-12 h-12 text-white" />
            </div>
            <div v-else-if="correctAnswersPercentage >= 60" 
                 class="w-24 h-24 mx-auto mb-4 rounded-full bg-gradient-to-r from-yellow-400 to-orange-500 flex items-center justify-center">
              <Icon name="Smile" class="w-12 h-12 text-white" />
            </div>
            <div v-else 
                 class="w-24 h-24 mx-auto mb-4 rounded-full bg-gradient-to-r from-red-400 to-pink-500 flex items-center justify-center">
              <Icon name="BookOpen" class="w-12 h-12 text-white" />
            </div>
          </div>

          <div class="mb-6">
            <h2 v-if="correctAnswersPercentage >= 80" 
                class="text-4xl font-bold text-green-600 mb-2">
              Excellent! 🎉
            </h2>
            <h2 v-else-if="correctAnswersPercentage >= 60" 
                class="text-4xl font-bold text-yellow-600 mb-2">
              Well done! 👍
            </h2>
            <h2 v-else 
                class="text-4xl font-bold text-red-500 mb-2">
              Keep going! 💪
            </h2>
            
            <p v-if="correctAnswersPercentage >= 80" 
               class="text-lg text-gray-600 dark:text-gray-300">
              Perfect! You have mastered the subject.
            </p>
            <p v-else-if="correctAnswersPercentage >= 60" 
               class="text-lg text-gray-600 dark:text-gray-300">
              Good work! Just a little more effort for perfection.
            </p>
            <p v-else 
               class="text-lg text-gray-600 dark:text-gray-300">
              Don't get discouraged, practice makes perfect!
            </p>
          </div>

          <Card class="p-6 mb-8">
            <div class="grid grid-cols-3 gap-4 text-center">
              <div>
                <div class="text-2xl font-bold text-green-600">{{ correctAnswers }}</div>
                <div class="text-sm text-muted-foreground">Correct</div>
              </div>
              <div>
                <div class="text-2xl font-bold text-red-500">{{ wrongAnswers }}</div>
                <div class="text-sm text-muted-foreground">Wrong</div>
              </div>
              <div>
                <div class="text-2xl font-bold text-primary">{{ correctAnswersPercentage }}%</div>
                <div class="text-sm text-muted-foreground">Score</div>
              </div>
            </div>
            
            <div class="mt-4">
              <div class="w-full bg-secondary rounded-full h-3">
                <div class="h-3 rounded-full transition-all duration-500 ease-out"
                     :class="{
                       'bg-gradient-to-r from-green-400 to-emerald-500': correctAnswersPercentage >= 80,
                       'bg-gradient-to-r from-yellow-400 to-orange-500': correctAnswersPercentage >= 60 && correctAnswersPercentage < 80,
                       'bg-gradient-to-r from-red-400 to-pink-500': correctAnswersPercentage < 60
                     }"
                     :style="`width: ${correctAnswersPercentage}%`">
                </div>
              </div>
            </div>
          </Card>

          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <Button 
              variant="secondary" 
              size="lg"
              as="a"
              :href="`/workspaces/${workspace_id}/flashcards`">
              <Icon name="ArrowLeft" size="sm" class="mr-2" />
              Back to collections
            </Button>
            <Button 
              variant="default" 
              size="lg"
              @click="resetSeries">
              <Icon name="RotateCcw" size="sm" class="mr-2" />
              Restart
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
              />
            </CarouselItem>
          </CarouselContent>
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
    </div>
  </AppLayout>
</template>
