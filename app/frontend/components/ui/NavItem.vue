<template>
  <button :class="linkClasses" @click="handleClick">
    <Icon :name="iconName" :class="iconClasses" />
    {{ label }}
  </button>
</template>

<script setup lang="ts">
import { computed } from "vue";
import { useNavigation } from "../../composables/useNavigation";
import Icon from "./Icon.vue";

interface Props {
  id: string;
  label: string;
  iconName: string;
}

interface Emits {
  click: [id: string];
}

const props = defineProps<Props>();

const emit = defineEmits<Emits>();

const { isActive, getActiveItemClass, getIconClass } = useNavigation();

const linkClasses = computed(() => {
  const baseClasses =
    "w-full flex items-center px-4 py-3 rounded-[16px] text-sm font-light transition-all duration-300 text-left border-none bg-transparent cursor-pointer";
  return `${baseClasses} ${getActiveItemClass.value(props.id)}`;
});

const iconClasses = computed(() => {
  const baseClasses = "w-5 h-5 mr-4";
  return `${baseClasses} ${getIconClass.value(props.id)}`;
});

const handleClick = () => {
  emit("click", props.id);
};
</script>
