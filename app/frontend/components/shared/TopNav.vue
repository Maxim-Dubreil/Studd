<script setup lang="ts">
import { Icon } from '@/components/ui/icon';
import { Button } from '@/components/ui/button';
import UserAvatar from '../ui/avatar/UserAvatar.vue';
import { useTheme } from '../../composables/useTheme';

interface Props {
  user?: {
    name: string;
    email: string;
    avatar?: string;
  };
}

const props = withDefaults(defineProps<Props>(), {
  user: () => ({
    name: 'Étudiant Demo',
    email: 'demo@studyapp.com',
    avatar: undefined,
  }),
});

const { theme, toggleTheme } = useTheme();

const openSettings = () => {
  console.log('Ouverture des paramètres');
  // Logique pour ouvrir le panneau de paramètres
};

const openUserMenu = () => {
  console.log('Ouverture du menu utilisateur');
  // Logique pour ouvrir le menu utilisateur
};

const logout = () => {
  if (confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) {
    const link = document.createElement('a');
    link.href = '/logout';
    link.setAttribute('data-turbo-method', 'delete');
    link.setAttribute('data-turbo-confirm', 'false');

    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
};
</script>

<template>
  <div class="flex items-center justify-end space-x-4 p-6">
    <!-- Bouton Get Pro -->
    <Button
      variant="destructive"
      size="default"
      radius="xl"
      class="shadow-lg backdrop-blur-sm"
      @click="() => console.log('Get Pro clicked')"
    >
      Get Pro
    </Button>

    <!-- Toggle Dark/Light” -->
    <Button
      @click="toggleTheme"
      variant="outline"
      size="default"
      class="shadow-lg backdrop-blur-sm"
    >
      <Icon
        :name="theme === 'dark' ? 'sun' : 'moon'"
        size="md"
        :class="[
          'transition-all duration-300',
          theme === 'dark'
            ? 'text-yellow-500 group-hover:text-yellow-400 group-hover:rotate-12'
            : 'text-indigo-600 dark:text-indigo-400 group-hover:text-indigo-500 group-hover:-rotate-12',
        ]"
      />
    </Button>

    <!-- Bouton Paramètres -->
    <Button
      @click="openSettings"
      variant="outline"
      size="default"
      radius="xl"
      class="shadow-lg backdrop-blur-sm"
    >
      <Icon
        name="settings"
        class="text-gray-600 dark:text-gray-300 group-hover:text-gray-800 dark:group-hover:text-gray-100 transition-all duration-300 group-hover:rotate-90"
      />
    </Button>

    <!-- Bouton Déconnexion -->
    <Button
      @click="logout"
      variant="outline"
      size="default"
      radius="xl"
      title="Se déconnecter"
      class="shadow-lg backdrop-blur-sm"
    >
      <Icon
        name="log-out"
        class="text-red-600 dark:text-red-400 group-hover:text-red-700 dark:group-hover:text-red-300 transition-all duration-300"
      />
    </Button>

    <UserAvatar />
  </div>
</template>
