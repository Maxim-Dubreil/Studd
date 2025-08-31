<script setup lang="ts">
import Icon from '@/components/ui/icon/Icon.vue';
import Button from './Button.vue';

const props = defineProps<{
  label?: string;
  class?: string;
}>();

const emit = defineEmits(['click']);
</script>

<template>
  <Button
    type="button"
    @click="$emit('click')"
    :class="[
      'flex items-center gap-2 rounded-xl border border-violet-200/50 bg-white/80 p-3 shadow-xl backdrop-blur-sm transition-all hover:scale-105 hover:bg-white/90 hover:shadow-xl',
      props.class,
    ]"
    aria-label="Reset"
  >
    <Icon name="refresh-cw" class="h-5 w-5 text-violet-600" />
    <span v-if="props.label" class="ml-2 font-medium text-violet-700">{{ props.label }}</span>
  </Button>
</template>