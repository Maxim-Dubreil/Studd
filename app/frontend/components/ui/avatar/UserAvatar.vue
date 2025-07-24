<script setup lang="ts">
import { computed } from 'vue'
import { Avatar, AvatarImage, AvatarFallback } from '@/components/ui/avatar'
import { User as UserIcon } from 'lucide-vue-next'
import { cn } from '@/lib/utils'
import { avatarWrapper, avatarRoot, notifyDot } from './avatarVariants'


const props = withDefaults(defineProps<{
  src?: string
  name?: string
  status?: 'online' | 'offline' | 'away' | 'busy'
  notify?: boolean
  clickable?: boolean
  size?: 'sm' | 'md' | 'lg' | 'xl'
  class?: string

}>(), {
  clickable: false,
  notify: false,
  size: 'md'
})

const emit = defineEmits<{ click: [] }>()

const initials = computed(() =>
  (props.name ?? 'U').split(' ').map(w => w[0]).join('').toUpperCase().slice(0, 2)
)
</script>

<template>
  <div :class="cn(
    avatarWrapper({ clickable: props.clickable }),
    props.class
  )" @click="emit('click')">
    <Avatar :class="cn(avatarRoot({ size: props.size }))">
      <AvatarImage v-if="props.src" :src="props.src" alt="User avatar" class="object-cover w-full h-full" />
      <AvatarFallback>
        <UserIcon v-if="!props.name" class="size-5" />
        <span v-else class="font-medium">{{ initials }}</span>
      </AvatarFallback>
    </Avatar>
    <div v-if="props.notify" :class="cn(notifyDot({}))" />
  </div>
</template>
