<template>
  <div :class="cardClasses">
    <!-- Header avec titre et icône -->
    <div
      v-if="title || icon || $slots.header"
      class="flex items-center justify-between mb-4"
    >
      <h3 v-if="title" class="text-lg font-medium text-gray-700">
        {{ title }}
      </h3>
      <slot name="header" />
      <div v-if="icon" :class="iconContainerClasses">
        <component :is="icon" class="w-6 h-6 text-white" />
      </div>
    </div>

    <!-- Contenu principal -->
    <slot />

    <!-- Footer optionnel -->
    <div v-if="$slots.footer" class="mt-4 pt-4 border-t border-gray-100">
      <slot name="footer" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from "vue";
import {
  useStyleUtils,
  type SizeVariant,
} from "../../composables/useStyleUtils";

interface Props {
  title?: string;
  icon?: any;
  iconBgClass?: string;
  variant?: "glass" | "solid" | "outlined";
  rounded?: SizeVariant;
  padding?: SizeVariant;
  customClasses?: string;
}

const props = withDefaults(defineProps<Props>(), {
  iconBgClass: "from-violet-400 to-purple-500",
  variant: "glass",
  rounded: "lg",
  padding: "md",
});

const { getCardClasses, getIconContainerClasses } = useStyleUtils();

const cardClasses = computed(() => {
  const baseClasses = getCardClasses.value(
    props.variant,
    props.padding,
    props.rounded
  );
  return props.customClasses
    ? `${baseClasses} ${props.customClasses}`
    : baseClasses;
});

const iconContainerClasses = computed(() => {
  return getIconContainerClasses.value(
    "lg",
    `bg-gradient-to-br ${props.iconBgClass}`
  );
});
</script>
