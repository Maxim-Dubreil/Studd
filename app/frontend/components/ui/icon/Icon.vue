<template>
  <component :is="iconComponent" :class="finalClass" v-bind="$attrs" />
</template>

<script setup lang="ts">
import type { HTMLAttributes } from 'vue'
import { computed } from 'vue'
import { cn } from '@/lib/utils'
import { iconVariants, type IconVariants } from './iconVariants'
import * as Lucide from 'lucide-vue-next'

interface Props {
  /** nom kebab/pascal/camel : 'home', 'log-out', 'GraduationCap' ... */
  name: string
  size?: IconVariants['size']
  spin?: IconVariants['spin']
  color?: string
  class?: HTMLAttributes['class']
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  spin: false,
  color: 'text-current',
})

const toPascal = (s: string) =>
  s
    .split(/[-_ ]+/)
    .map(p => p.charAt(0).toUpperCase() + p.slice(1))
    .join('')

const iconComponent = computed(() => {
  if ((Lucide as any)[props.name]) return (Lucide as any)[props.name]
  // sinon tente le pascal-case
  const pascal = toPascal(props.name)
  return (Lucide as any)[pascal] ?? Lucide.HelpCircle
})

const finalClass = computed(() =>
  cn(iconVariants({ size: props.size, spin: props.spin }), props.color, props.class)
)
</script>