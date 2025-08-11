<script setup lang="ts">
import type { HTMLAttributes } from 'vue'
import { Primitive, type PrimitiveProps } from 'reka-ui'
import { cn } from '@/lib/utils'
import { type ButtonVariants, buttonVariants } from '.'

interface Props extends PrimitiveProps {
  variant?: ButtonVariants['variant']
  size?: ButtonVariants['size']
  class?: HTMLAttributes['class']
  radius?: ButtonVariants['radius']
}

const props = withDefaults(defineProps<Props>(), {
  as: 'button',
})
</script>

<template>
  <Primitive data-slot="button" :as="as" :as-child="asChild" class="cursor-pointer"
    :class="cn(buttonVariants({ variant, size, radius }), props.class)">
    <slot />
  </Primitive>
</template>
