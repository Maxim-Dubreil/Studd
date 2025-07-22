<script setup lang="ts">
import { computed } from 'vue'
import { useTheme } from '@/composables/useTheme'
import { Button } from '@/components/ui/button'
import Icon from '@/components/Icon.vue'

const { theme, toggleTheme } = useTheme()
const isDark = computed(() => theme.value === 'dark')
</script>

<template>
    <Button @click="toggleTheme" variant="outline" size="icon"
        class="group p-3 rounded-full bg-white/50 dark:bg-slate-800/50 hover:bg-white/70 dark:hover:bg-slate-700/70 backdrop-blur-sm border border-white/20 dark:border-slate-600/50 shadow-lg dark:shadow-xl hover:scale-105 transition-all">
        <Icon :name="isDark ? 'sun' : 'moon'" class="w-5 h-5 transition-all duration-300" :class="isDark
            ? 'text-yellow-500 group-hover:text-yellow-400 group-hover:rotate-12'
            : 'text-indigo-600 dark:text-indigo-400 group-hover:text-indigo-500 group-hover:-rotate-12'" />
    </Button>
</template>
