<template>
  <!-- L’ensemble prend la classe `flipped` quand on clique -->
  <div
    class="flashcard h-[25rem] w-[48rem] cursor-pointer select-none"
    :class="{ flipped }"
    @click="flipped = !flipped"
  >
    <div class="flashcard-inner h-full w-full rounded-xl">
      <!-- Face avant -->
      <div
        class="flashcard-front flex items-center justify-center rounded-xl bg-white p-4 text-4xl font-extrabold text-neutral-700 shadow-lg"
        :style="{ backgroundColor: color }"
      >
        <slot name="term">{{ term }}</slot>
      </div>

      <!-- Face arrière -->
      <div
        class="flashcard-back flex flex-col overflow-hidden rounded-xl"
        :style="{ backgroundColor: color }"
      >
        <!-- Zone texte au centre -->
        <div
          class="flex flex-1 items-center justify-center p-8 text-lg font-semibold text-neutral-900"
        >
          <slot name="definition">{{ definition }}</slot>
        </div>

        <!-- Barre d’actions en bas -->
        <div class="flex h-14">
          <!-- Wrong (rouge vif) -->
          <Button
            @click.stop="handleWrong"
            class="peer flex h-full w-1/2 origin-bottom items-center justify-center gap-2 rounded-none bg-rose-500 text-white transition hover:scale-y-110"
          >
            <X class="h-5 w-5" />
            <span>Wrong</span>
          </Button>

          <!-- Correct (vert vif) -->
          <Button
            @click.stop="handleCorrect"
            class="flex h-full w-1/2 items-center justify-center gap-2 rounded-none bg-emerald-500 text-white hover:bg-emerald-600"
          >
            <Check class="h-5 w-5" />
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
  import { Check, X } from 'lucide-vue-next';

  /* Props : libellé et réponse */
  const props = defineProps<{
    term: string;
    definition: string;
    color: string;
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
