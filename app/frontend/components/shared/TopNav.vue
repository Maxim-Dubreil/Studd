<script setup lang="ts">
import { Button } from '@/components/ui/button';
import { Icon } from '@/components/ui/icon';
import { CalendarDays } from 'lucide-vue-next';
import { ref } from 'vue';

import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { useTheme } from '../../composables/useTheme';
import DecoDialog from '../ui/alert-dialog/DecoDialog.vue';
import UserAvatar from '../ui/avatar/UserAvatar.vue';
import UserMenuModal from './sidebar/UserMenuModal.vue';

import { HoverCard, HoverCardContent, HoverCardTrigger } from '@/components/ui/hover-card';

interface Props {
  user?: {
    name: string;
    email: string;
    avatar?: string;
  };
}

const { theme, toggleTheme } = useTheme();
const userMenuModalRef = ref();

const openSettings = () => {
  console.log('Ouverture des paramètres');
  // Logique pour ouvrir le panneau de paramètres
};

const openUserMenu = () => {
  console.log('Ouverture du menu utilisateur'); // Debug
  userMenuModalRef.value?.openModal();
};

const logout = () => {
  const link = document.createElement('a');
  link.href = '/logout';
  link.setAttribute('data-turbo-method', 'delete');
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

const handleProfileUpdated = (profile: any) => {
  console.log('Profile update:', profile);
  // Logique pour traiter la mise à jour du profil
};
</script>

<template>
  <div class="flex items-center justify-end space-x-4 p-6">
    <!-- Bouton Get Pro -->
    <Button variant="destructive" size="default" radius="xl" class="shadow-lg backdrop-blur-sm"
      @click="() => console.log('Get Pro clicked')">
      Get Pro
    </Button>

    <!-- Toggle Dark/Light” -->
    <Button @click="toggleTheme" variant="outline" size="default" class="shadow-lg backdrop-blur-sm">
      <Icon :name="theme === 'dark' ? 'sun' : 'moon'" size="md" :class="[
        'transition-all duration-300',
        theme === 'dark'
          ? 'text-yellow-500 group-hover:rotate-12 group-hover:text-yellow-400'
          : 'text-indigo-600 group-hover:-rotate-12 group-hover:text-indigo-500 dark:text-indigo-400',
      ]" />
    </Button>

    <!-- Bouton Paramètres -->
    <Button @click="openSettings" variant="outline" size="default" radius="xl" class="shadow-lg backdrop-blur-sm">
      <Icon name="settings"
        class="text-gray-600 transition-all duration-300 group-hover:rotate-90 group-hover:text-gray-800 dark:text-gray-300 dark:group-hover:text-gray-100" />
    </Button>

    <!-- Bouton Déconnexion -->
    <DecoDialog :on-confirm="logout" />

    <HoverCard>
      <HoverCardTrigger as-child>
        <UserAvatar />
      </HoverCardTrigger>
      <HoverCardContent class="w-64 p-4">
        <div class="flex flex-col space-y-4">
          <div class="flex items-center gap-3">
            <Avatar>
              <AvatarImage :src="user?.avatar || 'https://github.com/unovue.png'" alt="@unovue" />
              <AvatarFallback>Avatar</AvatarFallback>
            </Avatar>
            <div class="flex flex-col space-y-1">
              <Label class="text-sm font-semibold">{{ user?.name || 'John Doe' }}</Label>
              <Label class="text-muted-foreground text-xs">{{ user?.email || 'john.doe@example.com' }}</Label>
            </div>
          </div>
          <div class="bg-border h-px"></div>

          <!-- Section date -->
          <div class="flex items-center gap-2">
            <CalendarDays class="h-4 w-4 opacity-70" />
            <span class="text-muted-foreground text-xs">Joined January 2014</span>
          </div>
          <div class="text-14px flex justify-end pt-1">
            <Button variant="default" size="sm" @click="openUserMenu">
              <Icon name="edit" class="h-4 w-4" />
              Edit Profile
            </Button>
          </div>
        </div>
      </HoverCardContent>
    </HoverCard>

    <UserMenuModal ref="userMenuModalRef" @profile-updated="handleProfileUpdated" />
  </div>
</template>
