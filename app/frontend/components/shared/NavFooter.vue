<!-- app/frontend/components/shared/NavUser.vue -->
<script setup lang="ts">
import { ref } from 'vue'
import { Edit, LogOut } from 'lucide-vue-next'

import UserMenuModal from './UserMenuModal.vue'
import DecoDialog from '../ui/alert-dialog/DecoDialog.vue'

import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import {
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from '@/components/ui/sidebar'

interface Props {
  user?: {
    name?: string
    email?: string
    avatar?: string
  }
}
const props = defineProps<Props>()

const userMenuModalRef = ref<InstanceType<typeof UserMenuModal> | null>(null)
const openEditProfile = () => userMenuModalRef.value?.openModal?.()

const logout = () => {
  const link = document.createElement('a')
  link.href = '/logout'
  link.setAttribute('data-turbo-method', 'delete')
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}
</script>

<template>
  <SidebarMenu>


    <!-- Log out (rouge) avec confirmation via le même DecoDialog -->
    <SidebarMenuItem>
      <DecoDialog :on-confirm="logout" asChild>
        <template #trigger>
          <SidebarMenuButton asChild class="justify-start">
            <button type="button" class="w-full h-10 px-2 flex items-center gap-2 rounded-md
                     group focus:bg-red-50 hover:bg-red-50
                     dark:focus:bg-red-950/40 dark:hover:bg-red-950/40">
              <LogOut class="h-4 w-4 text-red-600 group-hover:text-red-700
                       dark:text-red-500 dark:group-hover:text-red-400" />
              <span class="text-sm text-red-700 dark:text-red-400
                       group-data-[collapsible=icon]:hidden">
                Log out
              </span>
            </button>
          </SidebarMenuButton>
        </template>
      </DecoDialog>
    </SidebarMenuItem>

    <!-- Edit Profile (violet) -->
    <SidebarMenuItem>
      <SidebarMenuButton asChild class="justify-start">
        <button type="button" class="w-full h-10 px-2 flex items-center gap-2 rounded-md
                 hover:bg-violet-50 dark:hover:bg-violet-950/30" @click="openEditProfile">
          <Edit class="h-4 w-4 text-violet-600 dark:text-violet-400" />
          <span class="text-sm group-data-[collapsible=icon]:hidden">Edit Profile</span>
        </button>
      </SidebarMenuButton>
    </SidebarMenuItem>
    
    <!-- Bloc avatar + infos -->
    <SidebarMenuItem>
      <div class="flex items-center gap-3 px-2 py-2">
        <Avatar class="h-8 w-8 rounded-lg">
          <AvatarImage :src="props.user?.avatar || 'https://github.com/unovue.png'"
            :alt="props.user?.name || 'User avatar'" />
          <AvatarFallback class="rounded-lg">U</AvatarFallback>
        </Avatar>

        <!-- Masquer le texte quand la sidebar est en mode icône -->
        <div class="min-w-0 group-data-[collapsible=icon]:hidden">
          <p class="truncate text-sm font-semibold">
            {{ props.user?.name || 'John Doe' }}
          </p>
          <p class="truncate text-xs opacity-80">
            {{ props.user?.email || 'john@example.com' }}
          </p>
        </div>
      </div>
    </SidebarMenuItem>


    <!-- Modal d’édition monté dans le DOM -->
    <UserMenuModal ref="userMenuModalRef" />
  </SidebarMenu>
</template>
