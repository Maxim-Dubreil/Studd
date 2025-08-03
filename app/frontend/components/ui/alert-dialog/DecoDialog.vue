<script setup lang="ts">
  import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogTrigger,
  } from '@/components/ui/alert-dialog';
  import { Button } from '@/components/ui/button';
  import { Icon } from '@/components/ui/icon';

  interface Props {
    onConfirm?: () => void;
  }

  const props = withDefaults(defineProps<Props>(), {
    onConfirm: () => {},
  });

  // Fonction pour gérer la confirmation
  const handleConfirm = () => {
    if (props.onConfirm) {
      props.onConfirm();
    }
  };
</script>

<template>
  <AlertDialog>
    <AlertDialogTrigger as-child>
      <Button
        variant="outline"
        size="default"
        radius="xl"
        title="Se déconnecter"
        class="shadow-lg backdrop-blur-sm"
      >
        <Icon
          name="log-out"
          class="text-red-600 transition-all duration-300 group-hover:text-red-700 dark:text-red-400 dark:group-hover:text-red-300"
        />
      </Button>
    </AlertDialogTrigger>
    <AlertDialogContent>
      <AlertDialogHeader>
        <AlertDialogTitle>Êtes-vous sûr de vouloir vous déconnecter ?</AlertDialogTitle>
      </AlertDialogHeader>
      <AlertDialogFooter>
        <AlertDialogCancel>Annuler</AlertDialogCancel>
        <AlertDialogAction @click="handleConfirm">Continuer</AlertDialogAction>
      </AlertDialogFooter>
    </AlertDialogContent>
  </AlertDialog>
</template>
