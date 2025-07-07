<script setup lang="ts">
import { Menubar, MenubarMenu, MenubarTrigger } from '@/components/ui/menubar';
import { Button } from '@/components/ui/button';
import Icon from '@/components/Icon.vue';
import { cn } from '@/lib/utils';

interface NavItem {
  label: string;
  url: string;
  variant?: 'gradient' | 'outline' | 'link' | 'default';
  external?: boolean;
}

const props = defineProps<{
  left: NavItem[];
  center: NavItem[];
  right: NavItem[];
}>();
</script>

<template>
  <Menubar
    class="mx-auto max-w-6xl mt-6 rounded-2xl grid grid-cols-3 items-center px-10 border-b dark:border-zinc-800 h-14 bg-background/70 dark:bg-background/40 backdrop-blur-md shadow-lg w-[calc(100%-2rem)]"
  >
    <!-- Colonne gauche -->
    <div class="flex items-center gap-4">
      <slot name="logo" />
      <template v-for="item in props.left" :key="item.label">
        <MenubarMenu>
          <MenubarTrigger as-child>
            <a
              v-if="i === 0"
              :href="item.url"
              :rel="item.external ? 'noopener noreferrer' : undefined"
              class="group flex items-center gap-2 text-2xl font-extrabold tracking-tight bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 bg-clip-text text-transparent drop-shadow-sm"
            >
              {{ item.label }}
              <!-- Icône décorative animée -->
              <Icon
                name="zap"
                size="lg"
                class="text-indigo-400 transition-transform duration-300 group-hover:rotate-6 group-hover:scale-110"
              />
            </a>

            <a
              v-else
              :href="item.url"
              :rel="item.external ? 'noopener noreferrer' : undefined"
              class="font-medium text-sm transition-colors duration-200 hover:text-indigo-600 dark:hover:text-indigo-400"
            >
              {{ item.label }}
            </a>
          </MenubarTrigger>
        </MenubarMenu>
      </template>
    </div>

    <!-- Colonne centrale -->
    <div class="flex justify-center gap-4">
      <template v-for="item in props.center" :key="item.label">
        <MenubarMenu>
          <MenubarTrigger as-child>
            <a
              :href="item.url"
              class="font-medium text-sm transition-colors duration-200 hover:text-indigo-600 dark:hover:text-indigo-400"
            >
              {{ item.label }}
            </a>
          </MenubarTrigger>
        </MenubarMenu>
      </template>
    </div>

    <!-- Colonne droite -->
    <div class="flex justify-end gap-2">
      <template v-for="item in props.right" :key="item.label">
        <!-- On délègue le style à <Button> → cohérence DS -->
        <Button
          as="a"
          :href="item.url"
          :variant="
            item.variant === 'gradient'
              ? 'gradient'
              : item.variant === 'outline'
                ? 'outline'
                : (item.variant ?? 'default')
          "
          size="sm"
          class="min-w-[84px]"
        >
          {{ item.label }}
        </Button>
      </template>
    </div>
  </Menubar>
</template>
