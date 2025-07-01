<template>
  <div :class="avatarClasses" @click="handleClick">
    <img v-if="src" :src="src" :alt="alt" class="w-full h-full object-cover" />
    <span v-else :class="textClasses">
      {{ initials }}
    </span>

    <!-- Badge de statut -->
    <div v-if="status" :class="statusClasses" />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useStyleUtils, type SizeVariant } from '../composables/useStyleUtils';

interface Props {
  src?: string;
  alt?: string;
  name?: string;
  size?: SizeVariant;
  status?: 'online' | 'offline' | 'away' | 'busy';
  clickable?: boolean;
  gradient?: string;
}

interface Emits {
  click: [];
}

const props = withDefaults(defineProps<Props>(), {
  alt: 'User avatar',
  size: 'md',
  clickable: false,
  gradient: 'from-violet-400 via-purple-400 to-blue-400',
});

const emit = defineEmits<Emits>();

const { getIconContainerClasses } = useStyleUtils();

const initials = computed(() => {
  if (!props.name) return 'U';
  return props.name
    .split(' ')
    .map((word) => word.charAt(0))
    .join('')
    .toUpperCase()
    .slice(0, 2);
});

const avatarClasses = computed(() => {
  const baseClasses = getIconContainerClasses.value(
    props.size,
    `bg-gradient-to-br ${props.gradient}`
  );
  const extraClasses = [
    'relative overflow-hidden ring-2 ring-white/20 backdrop-blur-sm',
    props.clickable &&
      'cursor-pointer hover:scale-105 transition-transform duration-200',
  ]
    .filter(Boolean)
    .join(' ');

  return `${baseClasses} ${extraClasses}`;
});

const textClasses = computed(() => {
  const sizeMap = {
    sm: 'text-xs',
    md: 'text-sm',
    lg: 'text-base',
    xl: 'text-lg',
  };
  return `text-white font-medium ${sizeMap[props.size]}`;
});

const statusClasses = computed(() => {
  if (!props.status) return '';

  const sizeMap = {
    sm: 'w-2 h-2',
    md: 'w-2.5 h-2.5',
    lg: 'w-3 h-3',
    xl: 'w-4 h-4',
  };

  const colorMap = {
    online: 'bg-green-400',
    offline: 'bg-gray-400',
    away: 'bg-yellow-400',
    busy: 'bg-red-400',
  };

  return `absolute -bottom-0.5 -right-0.5 rounded-full border-2 border-white ${
    sizeMap[props.size]
  } ${colorMap[props.status]}`;
});

const handleClick = () => {
  if (props.clickable) {
    emit('click');
  }
};
</script>
