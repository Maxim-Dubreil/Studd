<script setup lang="ts">
  import { cn } from '@/lib/utils';
  import { Plus } from 'lucide-vue-next';
  import type { FunctionalComponent } from 'vue';
  import { computed, ref } from 'vue';

  interface Icons {
    Icon: FunctionalComponent;
    href?: string;
    className?: string;
  }

  interface Props {
    icons: Icons[];
    className?: string;
    iconSize?: number;
  }

  const props = defineProps<Props>();

  const active = ref(false);
  const buttonSize = 'size-10 sm:size-16';

  const translateX = computed(() =>
    active.value ? 'translateX(calc(100% + 16px))' : 'translateX(0)'
  );
  const plusRotate = computed(() => (active.value ? 'rotate(45deg)' : 'rotate(0)'));
  const iconStyle = computed(() => ({
    filter: active.value ? 'blur(0)' : 'blur(2px)',
    transform: active.value ? 'scale(1) rotate(0deg)' : 'scale(0.9) rotate(45deg)',
    transition: 'all .4s ease-in',
  }));
</script>

<template>
  <div
    :class="cn('relative flex w-full items-start justify-start sm:justify-center', props.className)"
  >
    <div class="relative flex items-center justify-center gap-4">
      <div
        class="bg-background absolute left-0 z-10 w-full rounded-full"
        :style="{ transform: translateX, transition: 'transform .5s ease-in' }"
      >
        <button
          :class="
            cn(
              buttonSize,
              'flex items-center justify-center rounded-full',
              'bg-primary hover:bg-primary/90 transition-colors'
            )
          "
          :style="{ transform: plusRotate, transition: 'transform .5s ease-in' }"
          @click="active = !active"
        >
          <Plus :size="props.iconSize ?? 20" stroke-width="3" class="text-primary-foreground" />
        </button>
      </div>

      <div
        v-for="({ Icon, href, className }, i) in props.icons"
        :key="i"
        :class="
          cn(
            buttonSize,
            'flex items-center justify-center rounded-full',
            'bg-background shadow-lg hover:shadow-xl',
            'border-border border',
            className
          )
        "
        :style="iconStyle"
      >
        <a
          v-if="href"
          :href="href"
          target="_blank"
          rel="noopener noreferrer"
          class="flex items-center justify-center"
        >
          <component
            :is="Icon"
            :size="props.iconSize ?? 20"
            class="text-muted-foreground hover:text-foreground transition-all hover:scale-110"
          />
        </a>
        <component
          v-else
          :is="Icon"
          :size="props.iconSize ?? 20"
          class="text-muted-foreground hover:text-foreground transition-all hover:scale-110"
        />
      </div>
    </div>
  </div>
</template>
