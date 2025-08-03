<script setup lang="ts">
  import { Button } from '@/components/ui/button';
  import { Icon } from '@/components/ui/icon';
  import { useTheme } from '../../composables/useTheme';
  import DecoDialog from '../ui/alert-dialog/DecoDialog.vue';
  import UserAvatar from '../ui/avatar/UserAvatar.vue';

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
    const link = document.createElement('a');
    link.href = '/logout';
    link.setAttribute('data-turbo-method', 'delete');
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
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
            ? 'text-yellow-500 group-hover:rotate-12 group-hover:text-yellow-400'
            : 'text-indigo-600 group-hover:-rotate-12 group-hover:text-indigo-500 dark:text-indigo-400',
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
        class="text-gray-600 transition-all duration-300 group-hover:rotate-90 group-hover:text-gray-800 dark:text-gray-300 dark:group-hover:text-gray-100"
      />
    </Button>

    <!-- Bouton Déconnexion -->
    <DecoDialog :on-confirm="logout" />

    <UserAvatar />
  </div>
</template>
