<template>
  <div class="p-4">
    <div class="rounded-xl border bg-card p-6 shadow-sm">
      <h2 class="text-2xl font-semibold mb-6">Progression</h2>
    </div>
  </div>
</template>

<script setup lang="ts">
  import Icon from '@/components/ui/icon/Icon.vue';

  defineProps<{
    workspaceId: number;
  }>();
</script>