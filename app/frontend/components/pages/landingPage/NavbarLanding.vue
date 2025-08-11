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
  <Menubar
    class="bg-background/70 dark:bg-background/40 mt-6 grid h-14 max-w-250 grid-cols-3 items-center rounded-2xl border-b px-10 shadow-lg backdrop-blur-md dark:border-zinc-800"
  >
    <!-- Colonne gauche -->
    <div class="flex gap-4">
      <slot name="logo" />
      <template v-for="(item, i) in props.left" :key="item.label">
        <MenubarMenu>
          <MenubarTrigger as-child>
            <a
              :href="item.url"
              :data-turbo="
                item.url.includes('/dashboard') || item.url.includes('/workspaces')
                  ? 'false'
                  : 'true'
              "
              class="text-sm font-medium transition-colors duration-200 hover:text-indigo-600 dark:hover:text-indigo-400"
            >
              {{ item.label }}
            </a>
          </MenubarTrigger>
        </MenubarMenu>
      </template>
    </div>

    <!-- Colonne centrale -->
    <div class="flex gap-4">
      <template v-for="item in props.center" :key="item.label">
        <MenubarMenu>
          <MenubarTrigger as-child>
            <a
              :href="item.url"
              :data-turbo="
                item.url.includes('/dashboard') || item.url.includes('/workspaces')
                  ? 'false'
                  : 'true'
              "
              class="text-sm font-medium transition-colors duration-200 hover:text-indigo-600 dark:hover:text-indigo-400"
            >
              {{ item.label }}
            </a>
          </MenubarTrigger>
        </MenubarMenu>
      </template>
    </div>

    <!-- Colonne droite -->
    <div class="flex gap-4">
      <template v-for="item in props.right" :key="item.label">
        <Button
          as="a"
          :href="item.url"
          :data-turbo-method="item.data?.['data-turbo-method']"
          :data-turbo="
            item.url.includes('/dashboard') || item.url.includes('/workspaces') ? 'false' : 'true'
          "
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
