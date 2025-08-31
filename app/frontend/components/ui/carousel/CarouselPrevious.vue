<script setup lang="ts">
import type { WithClassAsProps } from './interface'
import { ChevronLeft } from 'lucide-vue-next'
import { cn } from '@/lib/utils'
import { Button, type ButtonVariants } from '@/components/ui/button'
import { useCarousel } from './useCarousel'

const props = withDefaults(defineProps<{
  variant?: ButtonVariants['variant']
  size?: ButtonVariants['size']
  radius?: ButtonVariants['radius']
}
& WithClassAsProps>(), {
  variant: 'NextPrevious',
  size: 'icon',
  radius: 'xl'
})

const { orientation, canScrollPrev, scrollPrev } = useCarousel()
</script>

<template>
  <Button
    data-slot="carousel-previous"
    :disabled="!canScrollPrev"
    :class="cn(
      'absolute',
      orientation === 'horizontal'
        ? 'top-1/2 -left-1 -translate-y-1/2'
        : '-top-12 left-1/2 -translate-x-1/2 rotate-90',
      props.class,
    )"
    :variant="variant"
    :size="size"
    :radius="radius"
    @click="scrollPrev"
  >
    <slot>
      <ChevronLeft />
      <span class="sr-only">Previous Slide</span>
    </slot>
  </Button>
</template>