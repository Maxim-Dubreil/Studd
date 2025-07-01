<template>
  <button :class="buttonClasses" :disabled="disabled" @click="handleClick">
    <!-- Icône à gauche -->
    <svg
      v-if="icon && iconPosition === 'left'"
      :class="iconClasses"
      fill="none"
      stroke="currentColor"
      viewBox="0 0 24 24"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        :d="icon"
      />
    </svg>

    <span v-if="$slots.default || label">
      <slot>{{ label }}</slot>
    </span>

    <!-- Icône à droite -->
    <svg
      v-if="icon && iconPosition === 'right'"
      :class="iconClasses"
      fill="none"
      stroke="currentColor"
      viewBox="0 0 24 24"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        :d="icon"
      />
    </svg>

    <!-- Spinner de chargement -->
    <div
      v-if="loading"
      class="ml-2 w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin"
    />
  </button>
</template>

<script setup lang="ts">
import { computed } from "vue";
import {
  useStyleUtils,
  type ColorVariant,
  type SizeVariant,
} from "../../composables/useStyleUtils";

interface Props {
  label?: string;
  variant?: ColorVariant;
  size?: SizeVariant;
  outlined?: boolean;
  disabled?: boolean;
  loading?: boolean;
  icon?: string;
  iconPosition?: "left" | "right";
  fullWidth?: boolean;
}

interface Emits {
  click: [event: MouseEvent];
}

const props = withDefaults(defineProps<Props>(), {
  variant: "primary",
  size: "md",
  outlined: false,
  disabled: false,
  loading: false,
  iconPosition: "left",
  fullWidth: false,
});

const emit = defineEmits<Emits>();

const { getButtonClasses, getIconClasses } = useStyleUtils();

const buttonClasses = computed(() => {
  const baseClasses = getButtonClasses.value(
    props.variant,
    props.size,
    props.outlined
  );
  const extraClasses = [
    props.fullWidth && "w-full",
    (props.disabled || props.loading) && "opacity-50 cursor-not-allowed",
  ]
    .filter(Boolean)
    .join(" ");

  return `${baseClasses} ${extraClasses}`;
});

const iconClasses = computed(() => {
  const spacing = props.iconPosition === "left" ? "mr-2" : "ml-2";
  return `${getIconClasses.value(props.size)} ${spacing}`;
});

const handleClick = (event: MouseEvent) => {
  if (!props.disabled && !props.loading) {
    emit("click", event);
  }
};
</script>
