<script setup lang="ts">
import { SidebarTrigger } from '@/components/ui/sidebar'
import { Button } from '@/components/ui/button';
import { Icon } from '@/components/ui/icon';
import { useTheme } from '@/composables/useTheme'

const props = withDefaults(defineProps<{
    /** Cache le bouton collapse du header (le dark mode reste) */
    hideCollapse?: boolean
}>(), {
    hideCollapse: false,
})

const { theme, toggleTheme } = useTheme()
</script>

<template>
    <header class="sticky top-0 z-40 flex h-14 w-full items-center justify-between
         px-3">
        <!-- Gauche : bouton collapse -->
        <div class="flex items-center gap-2">
            <SidebarTrigger v-if="!props.hideCollapse" class="-ml-1" aria-label="Basculer la sidebar" />
        </div>

        <!-- Droite : Dark mode -->
        <div class="flex items-center gap-2">
            <Button @click="toggleTheme" variant="outline" size="default" class="shadow-lg backdrop-blur-sm">
                <Icon :name="theme === 'dark' ? 'sun' : 'moon'" size="md" :class="[
                    'transition-all duration-300',
                    theme === 'dark'
                        ? 'text-yellow-500 group-hover:rotate-12 group-hover:text-yellow-400'
                        : 'text-indigo-600 group-hover:-rotate-12 group-hover:text-indigo-500 dark:text-indigo-400',
                ]" />
            </Button>
        </div>
    </header>
</template>