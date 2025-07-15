<script setup lang="ts">
import { Alert, AlertDescription } from '@/components/ui/alert';

interface Props {
    errors?: string[];
}

withDefaults(defineProps<Props>(), {
    errors: () => [],
});
</script>

<template>
    <Alert v-if="errors && errors.length > 0" variant="destructive" class="mb-4">
        <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd"
                d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"
                clip-rule="evenodd" />
        </svg>
        <AlertDescription>
            <ul class="space-y-1">
                <li v-for="error in errors" :key="error">{{ error }}</li>
            </ul>
        </AlertDescription>
    </Alert>
</template>
