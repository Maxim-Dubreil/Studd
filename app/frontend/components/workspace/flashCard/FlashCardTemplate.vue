<template>
  <!-- L’ensemble prend la classe `flipped` quand on clique -->
  <div
    class="flashcard h-[30rem] w-[25rem] cursor-pointer select-none"
    :class="{ flipped }"
    @click="flipped = !flipped"
  >
    <div class="flashcard-inner border-accent h-full w-full rounded-xl border shadow-xl">
      <!-- Face avant -->

      <div
        class="flashcard-front align-justify flex items-center justify-center bg-white p-8 text-justify text-xl font-extrabold text-neutral-700 shadow-lg"
        :style="{ backgroundColor: color }"
      >
        <TooltipProvider>
          <Tooltip>
            <TooltipTrigger>
              <Icon
                name="message-circle-question-mark"
                size="lg"
                class="absolute top-4 right-4 text-purple-600"
              />
              <TooltipContent side="left">Click to turn the card, and respond !</TooltipContent>
            </TooltipTrigger>
          </Tooltip>
        </TooltipProvider>
        <span
          class="absolute top-4 left-4 rounded-lg bg-purple-500 px-3 py-1 text-sm font-medium text-purple-100 shadow"
        >
          Q. {{ questionNumber }}
        </span>
        <slot name="term">{{ term }}</slot>
      </div>

      <!-- Face arrière -->
      <div
        class="flashcard-back flex flex-col overflow-hidden rounded-xl"
        :style="{ backgroundColor: color }"
      >
        <!-- Zone texte au centre -->
        <div
          class="flex flex-1 items-center justify-center p-8 text-justify text-lg font-semibold text-neutral-900"
        >
          <slot name="definition">{{ definition }}</slot>
        </div>

        <!-- Barre d’actions en bas -->
        <div class="border-accent flex justify-center gap-4 border-t bg-white p-3 shadow-inner">
          <TooltipProvider>
            <Tooltip>
              <TooltipTrigger>
                <Icon
                  name="message-circle-question-mark"
                  size="lg"
                  class="absolute top-4 right-4 text-purple-600"
                />
                <TooltipContent side="left">
                  Click on the button to validate your answer
                </TooltipContent>
              </TooltipTrigger>
            </Tooltip>
          </TooltipProvider>

          <!-- Wrong (rouge vif) -->
          <Button variant="destructive" @click.stop="handleWrong">
            <Icon name="X" class="h-5 w-5" />
            <span>Wrong</span>
          </Button>

          <!-- Correct (vert vif) -->
          <Button variant="success" @click.stop="handleCorrect">
            <Icon name="Check" class="h-5 w-5" />
            <span>Correct</span>
          </Button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  import Button from '@/components/ui/button/Button.vue';
  import { useCarousel } from '@/components/ui/carousel/useCarousel';
  import Icon from '@/components/ui/icon/Icon.vue';
  import {
    Tooltip,
    TooltipContent,
    TooltipProvider,
    TooltipTrigger,
  } from '@/components/ui/tooltip';

  /* Props : libellé et réponse */
  const props = defineProps<{
    term: string;
    definition: string;
    color: string;
    questionNumber?: number;
  }>();

  const emit = defineEmits<{
    (e: 'correct'): void;
    (e: 'wrong'): void;
  }>();

  /* État local : retournée ou non (synchronisé avec le parent) */
  const flipped = defineModel<boolean>();
  const { scrollNext } = useCarousel();

  function handleCorrect() {
    if (!flipped.value) return; // Empêche de répondre si la carte n'est pas retournée
    flipped.value = false; // Retourne la carte
    scrollNext();
    emit('correct');
  }

  function handleWrong() {
    if (!flipped.value) return; // Empêche de répondre si la carte n'est pas retournée
    flipped.value = false; // Retourne la carte
    scrollNext();
    emit('wrong');
  }
</script>

<style scoped>
  /* Effet « flip » -----------------------------------------------------------*/
  .flashcard {
    perspective: 1000px; /* profondeur 3D */
  }
  .flashcard-inner {
    position: relative;
    width: 100%;
    height: 100%;
    transition: transform 0.6s;
    transform-style: preserve-3d; /* garde les 2 faces dans le même espace 3D */
  }
  .flipped .flashcard-inner {
    transform: rotateY(180deg); /* rotation quand flipped = true */
  }
  /* Faces ---------------------------------------------------------------*/
  .flashcard-front,
  .flashcard-back {
    position: absolute;
    inset: 0;
    backface-visibility: hidden; /* cache la face arrière */
    border-radius: inherit; /* suit le même arrondi */
  }
  .flashcard-back {
    transform: rotateY(180deg); /* prépare la face arrière */
  }
</style>
