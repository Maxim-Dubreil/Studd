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

  watch(current, (index) => {
    finished.value = index >= total.value - 1;
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

      <div v-if="finished" class="flex flex-col items-center gap-4">
        <p class="text-2xl font-semibold">Series over!</p>
        <p>
          {{ correctAnswers }} / {{ correctAnswers + wrongAnswers }} correct answers ({{
            correctAnswersPercentage
          }}
          %)
        </p>
        <div class="mt-6 flex flex-col items-center gap-4">
          <button class="rounded bg-indigo-600 px-6 py-2 text-white" @click="resetSeries">
            Restart
          </button>
          <a :href="`/workspaces/${workspace_id}`" class="rounded bg-red-600 px-6 py-2 text-white">
            Quit
          </a>
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
