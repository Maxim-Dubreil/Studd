<script setup lang="ts">
import Icon from '../Icon.vue';
import { Button } from "@/components/ui/button";
import UserAvatar from '../UserAvatar.vue';
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
    // Utiliser Turbo pour la déconnexion (plus propre)
    const link = document.createElement('a');
    link.href = '/logout';
    link.setAttribute('data-turbo-method', 'delete');
    link.setAttribute('data-turbo-confirm', 'false'); // Pas de double confirmation

    // Déclencher le clic programmatiquement
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
};
</script>

<template>
  <div class="flex items-center justify-end space-x-4 p-6">
    <!-- Bouton Get Pro -->
    <Button variant="destructive" size="default" radius='xl' class="shadow-lg backdrop-blur-sm"
      @click="() => console.log('Get Pro clicked')">
      Get Pro
    </Button>

    <!-- Toggle Dark/Light” -->
    <Button @click="toggleTheme" variant="outline" radius="xl" size="icon"
      class="group p-3 rounded-full bg-white/50 dark:bg-slate-800/50 hover:bg-white/70 dark:hover:bg-slate-700/70 backdrop-blur-sm border border-white/20 dark:border-slate-600/50 shadow-lg dark:shadow-xl hover:scale-105 transition-all">
      <Icon :name="theme === 'dark' ? 'sun' : 'moon'" :class="[
        'w-5 h-5 transition-all duration-300',
        theme === 'dark'
          ? 'text-yellow-500 group-hover:text-yellow-400 group-hover:rotate-12'
          : 'text-indigo-600 dark:text-indigo-400 group-hover:text-indigo-500 group-hover:-rotate-12'
      ]" />
    </Button>

    <!-- Bouton Paramètres -->
    <Button @click="openSettings" variant="outline" size="default" radius="xl">
      <Icon name="settings"
        class="text-gray-600 dark:text-gray-300 group-hover:text-gray-800 dark:group-hover:text-gray-100 transition-all duration-300 group-hover:rotate-90" />
    </Button>

    <!-- Bouton Déconnexion -->
    <Button @click="logout" variant="outline" size="default" radius="xl" title="Se déconnecter">
      <Icon name="logout"
        class="text-red-600 dark:text-red-400 group-hover:text-red-700 dark:group-hover:text-red-300 transition-all duration-300" />
    </Button>

    <!-- Avatar Utilisateur -->
    <div @click="openUserMenu" class="cursor-pointer transform hover:scale-105 transition-all duration-300">
      <div class="relative">
        <UserAvatar :name="props.user.name" :src="props.user.avatar" status="online"
          class="w-10 h-10 hover:ring-4 hover:ring-violet-200 dark:hover:ring-violet-500/30 transition-all duration-300 shadow-lg dark:shadow-xl border-2 border-white/50 dark:border-slate-600/50" />
        <!-- Indicateur de statut -->
        <div
          class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-400 dark:bg-green-500 border-2 border-white dark:border-slate-800 rounded-full animate-pulse">
        </div>
      </div>
    </div>
  </div>
</template>
