<script setup lang="ts">
  import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogTrigger,
  } from '@/components/ui/alert-dialog';

  interface Props {
    title?: string;
    description?: string;
    actionLabel?: string;
    cancelLabel?: string;
    destructive?: boolean;
    onConfirm?: () => void;
  }

  const props = withDefaults(defineProps<Props>(), {
    title: 'Confirm',
    description: 'Are you sure?',
    actionLabel: 'Confirm',
    cancelLabel: 'Cancel',
    destructive: false,
    onConfirm: () => {},
  });

  const handleConfirm = () => props.onConfirm?.();
</script>

<template>
  <AlertDialog>
    <AlertDialogTrigger as-child>
      <slot name="trigger">
        <button
          type="button"
          class="flex h-10 w-full cursor-pointer items-center gap-2 rounded-md px-2 hover:bg-violet-50 dark:hover:bg-violet-950/30"
        >
          <slot name="icon" />
          <span class="text-sm">
            <slot name="label">Open</slot>
          </span>
        </button>
      </slot>
    </AlertDialogTrigger>

    <AlertDialogContent>
      <AlertDialogHeader>
        <AlertDialogTitle>{{ props.title }}</AlertDialogTitle>
        <AlertDialogDescription>{{ props.description }}</AlertDialogDescription>
      </AlertDialogHeader>
      <AlertDialogFooter>
        <AlertDialogCancel class="cursor-pointer">{{ props.cancelLabel }}</AlertDialogCancel>
        <AlertDialogAction
          :class="
            (props.destructive ? 'bg-red-600 text-white hover:bg-red-700 dark:bg-red-600/90' : '') +
            ' cursor-pointer'
          "
          @click="handleConfirm"
        >
          {{ props.actionLabel }}
        </AlertDialogAction>
      </AlertDialogFooter>
    </AlertDialogContent>
  </AlertDialog>
</template>
