<!-- app/frontend/components/ui/Loading.vue -->
<script setup lang="ts">
import { cn } from '@/lib/utils'

interface Props {
  variant?: 'spinner' | 'skeleton' | 'dots' | 'pulse'
  size?: 'sm' | 'md' | 'lg' | 'xl'
  text?: string
  fullscreen?: boolean
  overlay?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'spinner',
  size: 'md',
  fullscreen: false,
  overlay: false
})

const sizeClasses = {
  sm: 'w-4 h-4',
  md: 'w-8 h-8', 
  lg: 'w-12 h-12',
  xl: 'w-16 h-16'
}
</script>

<template>
  <!-- Container principal -->
  <div 
    :class="cn(
      'flex items-center justify-center',
      fullscreen && 'fixed inset-0 z-50',
      overlay && 'bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm'
    )"
  >
    <div class="flex flex-col items-center space-y-4">
      
      <!-- Spinner classique -->
      <div 
        v-if="variant === 'spinner'"
        :class="cn(
          'animate-spin rounded-full border-2 border-primary/20 border-t-primary',
          sizeClasses[size]
        )"
      />
      
      <!-- Loading dots -->
      <div 
        v-else-if="variant === 'dots'"
        class="flex space-x-1"
      >
        <div 
          v-for="i in 3" 
          :key="i"
          :class="cn(
            'rounded-full bg-primary animate-bounce',
            size === 'sm' && 'w-2 h-2',
            size === 'md' && 'w-3 h-3',
            size === 'lg' && 'w-4 h-4',
            size === 'xl' && 'w-5 h-5'
          )"
          :style="{ animationDelay: `${i * 0.1}s` }"
        />
      </div>
      
      <!-- Pulse -->
      <div 
        v-else-if="variant === 'pulse'"
        :class="cn(
          'rounded-full bg-primary animate-pulse',
          sizeClasses[size]
        )"
      />
      
      <!-- Skeleton loader -->
      <div 
        v-else-if="variant === 'skeleton'"
        class="space-y-3"
      >
        <div class="animate-pulse space-y-2">
          <div class="h-4 bg-gray-300 dark:bg-gray-600 rounded w-48"></div>
          <div class="h-4 bg-gray-300 dark:bg-gray-600 rounded w-36"></div>
          <div class="h-4 bg-gray-300 dark:bg-gray-600 rounded w-24"></div>
        </div>
      </div>
      
      <!-- Texte optionnel -->
      <p 
        v-if="text" 
        class="text-sm text-muted-foreground animate-pulse"
      >
        {{ text }}
      </p>
      
    </div>
  </div>
</template>