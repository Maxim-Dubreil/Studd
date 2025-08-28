<script setup lang="ts">
import { Button } from '@/components/ui/button';
import { Menubar, MenubarMenu, MenubarTrigger } from '@/components/ui/menubar';

interface NavItem {
  label: string;
  url: string;
  variant?: 'gradient' | 'outline' | 'link' | 'default';
  external?: boolean;
  data?: { [key: string]: any };
}

const props = defineProps<{
  left: NavItem[];
  center: NavItem[];
  right: NavItem[];
}>();
</script>

<template>
  <Menubar class="fixed left-1/2 top-6 -translate-x-1/2 z-50
        grid h-14 grid-cols-3 items-center
         w-[min(100%-2rem,64rem)]
          rounded-2xl border bg-background/70 px-6 shadow-lg backdrop-blur-md
          dark:bg-background/40 dark:border-zinc-800">
    <div class="flex gap-4">
      <slot name="logo" />
      <template v-for="(item, i) in props.left" :key="item.label">
        <MenubarMenu>
          <MenubarTrigger as-child>
            <a :href="item.url" :data-turbo="item.url.includes('/dashboard') || item.url.includes('/workspaces')
              ? 'false'
              : 'true'
              "
              class="text-sm font-medium transition-colors duration-200 hover:text-indigo-600 dark:hover:text-indigo-400">
              {{ item.label }}
            </a>
          </MenubarTrigger>
        </MenubarMenu>
      </template>
    </div>

    <!-- Colonne centrale -->
    <div class="flex gap-4 justify-center">
      <template v-for="item in props.center" :key="item.label">
        <MenubarMenu>
          <MenubarTrigger as-child>
            <a :href="item.url" :data-turbo="item.url.includes('/dashboard') || item.url.includes('/workspaces')
              ? 'false'
              : 'true'
              "
              class="text-sm font-medium transition-colors duration-200 hover:text-indigo-600 dark:hover:text-indigo-400">
              {{ item.label }}
            </a>
          </MenubarTrigger>
        </MenubarMenu>
      </template>
    </div>

    <!-- Colonne droite -->
    <div class="flex gap-4 justify-end">
      <template v-for="item in props.right" :key="item.label">
        <Button as="a" :href="item.url" :data-turbo-method="item.data?.['data-turbo-method']" :data-turbo="item.url.includes('/dashboard') || item.url.includes('/workspaces') ? 'false' : 'true'
          " :variant="item.variant === 'gradient'
            ? 'gradient'
            : item.variant === 'outline'
              ? 'outline'
              : (item.variant ?? 'default')
            " size="sm" class="min-w-[84px]">
          {{ item.label }}
        </Button>
      </template>
    </div>
  </Menubar>
</template>
