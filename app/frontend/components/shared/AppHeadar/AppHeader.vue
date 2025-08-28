<script setup lang="ts">
import { SidebarTrigger } from '@/components/ui/sidebar'
import { Button } from '@/components/ui/button'
import { Icon } from '@/components/ui/icon'
import { useTheme } from '@/composables/useTheme'
import AppBreadcrumb from './AppBreadcrumb.vue'

const props = withDefaults(defineProps<{ hideCollapse?: boolean }>(), {
    hideCollapse: false,
})
const { theme, toggleTheme } = useTheme()

const breadcrumbLabels = {
    workspaces: 'Workspaces',
    settings: 'Settings',
    dashboard: 'Dashboard',
    blog: 'Blog',
    courses: 'Courses',
    calendar: 'Calendar',
}
</script>

<template>
    <!-- Header avec sidebar (style complet) -->
    <header v-if="!props.hideCollapse"
        class="sticky top-3 z-50 flex h-14 px-4 items-center rounded-2xl justify-between mx-2 bg-background/75 backdrop-blur-lg border-b border-border/40 shadow-sm dark:bg-background/40 dark:border-zinc-800">
        <!-- Gauche : bouton collapse + breadcrumbs -->
        <div class="flex items-center gap-3 min-w-0 h-full">
            <SidebarTrigger
                class="inline-flex items-center justify-center rounded-2xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 hover:bg-ring hover:text-background h-9 w-9"
                aria-label="Toggle sidebar" />

            <!-- Separator -->
            <div class="h-6 w-px bg-gray-300 dark:bg-gray-600 mr-2"></div>

            <!-- Breadcrumbs -->
            <div class="flex items-center">
                <AppBreadcrumb :labels="breadcrumbLabels" />
            </div>
        </div>

        <!-- Droite : Dark mode -->
        <div class="flex items-center gap-3">
            <Button @click="toggleTheme" variant="ghost" size="sm"
                class="group relative overflow-hidden rounded-lg border border-border/50 bg-background/50 backdrop-blur-sm shadow-sm hover:shadow-md hover:scale-105 transition-all duration-200 hover:border-border">
                <div
                    class="absolute inset-0 bg-gradient-to-r from-violet-500/10 to-purple-500/10 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                </div>
                <Icon :name="theme === 'dark' ? 'sun' : 'moon'" size="sm" :class="[
                    'relative z-10 transition-all duration-500',
                    theme === 'dark'
                        ? 'text-amber-500 group-hover:rotate-180 group-hover:text-amber-400 drop-shadow-[0_0_8px_rgba(245,158,11,0.5)]'
                        : 'text-slate-600 group-hover:rotate-180 group-hover:text-indigo-500 dark:text-slate-400',
                ]" />
            </Button>
        </div>
    </header>

    <!-- Header sans sidebar (style minimal/transparent) -->
    <header v-else class="fixed top-8 right-8 z-50">
        <div class="flex items-center gap-3">
            <Button @click="toggleTheme" variant="ghost" size="sm"
                class="group relative overflow-hidden rounded-lg border border-border/50 bg-background/50 backdrop-blur-sm shadow-sm hover:shadow-md hover:scale-105 transition-all duration-200 hover:border-border">
                <div
                    class="absolute inset-0 bg-gradient-to-r from-violet-500/10 to-purple-500/10 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                </div>
                <Icon :name="theme === 'dark' ? 'sun' : 'moon'" size="sm" :class="[
                    'relative z-10 transition-all duration-500',
                    theme === 'dark'
                        ? 'text-amber-500 group-hover:rotate-180 group-hover:text-amber-400 drop-shadow-[0_0_8px_rgba(245,158,11,0.5)]'
                        : 'text-slate-600 group-hover:rotate-180 group-hover:text-indigo-500 dark:text-slate-400',
                ]" />
            </Button>
        </div>
    </header>
</template>