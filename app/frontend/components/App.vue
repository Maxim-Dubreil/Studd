<script setup lang="ts">
import { Button } from "@/components/ui/button";
defineProps<{ msg?: string }>();
</script>

<template>
  <h1 class="text-3xl font-bold text-blue-600">
    {{ msg ?? "Hello from Vue 3 + Tailwind !" }}
  </h1>
  <Button>Valider</Button>
  <Button variant="outline">Annuler</Button>
</template>
