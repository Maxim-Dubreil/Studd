<template>
  <div
    :class="[
      // Layout & base
      'group relative col-span-3 flex flex-col overflow-hidden rounded-xl',
      'bg-white shadow-[0_0_0_1px_rgba(0,0,0,.03),0_2px_4px_rgba(0,0,0,.05),0_12px_24px_rgba(0,0,0,.05)]',
      'dark:border dark:border-white/10 dark:bg-black dark:shadow-[inset_0_-20px_80px_-20px_#ffffff1f]',
      cls,
    ]"
  >
    <!-- background décoratif -->
    <div class="absolute inset-0 overflow-hidden rounded-xl">
      <img
        v-if="bgImage"
        :src="bgImage"
        alt=""
        class="absolute inset-0 h-full w-full object-cover opacity-30 transition-opacity duration-300 group-hover:opacity-50"
      />
    </div>
    <slot name="bg" />

    <!-- Contenu principal -->
    <div
      class="pointer-events-none z-10 mt-auto flex transform-gpu flex-col gap-1 p-6 transition-all duration-300 group-hover:-translate-y-10"
    >
      <component
        :is="Icon"
        class="h-12 w-12 text-indigo-600 transition-transform duration-300 group-hover:scale-75"
      />
      <h3 class="text-xl font-semibold text-indigo-600">{{ name }}</h3>
      <p class="text-sm text-neutral-500 dark:text-neutral-400">{{ desc }}</p>
    </div>

    <!-- CTA -->
    <div
      class="pointer-events-none absolute bottom-0 flex w-full translate-y-10 transform-gpu p-4 opacity-0 transition-all duration-300 group-hover:translate-y-0 group-hover:opacity-100"
    >
      <a
        :href="href"
        class="pointer-events-auto inline-flex items-center gap-2 text-sm font-medium text-indigo-600 hover:underline"
      >
        {{ cta }}
        <ArrowRight class="h-4 w-4" />
      </a>
    </div>

    <!-- overlay hover -->
    <div
      class="pointer-events-none absolute inset-0 transition-all duration-300 group-hover:bg-black/5 dark:group-hover:bg-neutral-800/10"
    />
  </div>
</template>

<script setup lang="ts">
  import { ArrowRight } from 'lucide-vue-next';

  const props = defineProps<{
    name: string;
    desc: string;
    href: string;
    cta: string;
    Icon: any;
    cls?: string;
    bgImage?: string;
  }>();

  /* On garde 'cls' dans le template directement : pas besoin de destructurer. */
  const { cls } = props;
</script>
