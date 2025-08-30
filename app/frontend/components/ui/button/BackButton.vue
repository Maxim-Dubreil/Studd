<script setup lang="ts">
  import Icon from '@/components/ui/icon/Icon.vue';

  const props = defineProps<{
    href: string;
    label?: string;
    class?: string;
  }>();
</script>

<template>
  <a
    :href="props.href"
    :class="[
      'fixed top-8 left-8 z-50 flex items-center gap-2 rounded-xl border border-violet-200/50 bg-white/80 p-3 shadow-lg backdrop-blur-sm transition-all hover:scale-105 hover:bg-white/90 hover:shadow-xl',
      props.class,
    ]"
    aria-label="Back"
  >
    <Icon name="arrow-left" class="h-5 w-5 text-violet-600" />
    <span v-if="props.label" class="ml-2 font-medium text-violet-700">{{ props.label }}</span>
  </a>
</template>
