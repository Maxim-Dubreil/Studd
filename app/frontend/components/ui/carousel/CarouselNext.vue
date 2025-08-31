<script setup lang="ts">
import type { WithClassAsProps } from './interface'
import { ChevronRight } from 'lucide-vue-next'
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

const { orientation, canScrollNext, scrollNext } = useCarousel()
</script>

<template>
  <Button
    data-slot="carousel-next"
    :disabled="!canScrollNext"
    :class="cn(
      'absolute',
      orientation === 'horizontal'
        ? 'top-1/2 -right-1 -translate-y-1/2'
        : '-bottom-12 left-1/2 -translate-x-1/2 rotate-90',
      props.class,
    )"
    :variant="variant"
    :size="size"
    :radius="radius"
    @click="scrollNext"
  >
    <slot>
      <ChevronRight />
      <span class="sr-only">Next Slide</span>
    </slot>
  </Button>
</template>
