<script setup lang="ts">
  import { Button } from '@/components/ui/button';
  import { Icon } from '@/components/ui/icon';
</script>

<template>
  <Button
    @click=""
    variant="gradient"
    size="default"
    radius="xl"
    class="shadow-lg backdrop-blur-sm"
  >
    <Icon name="user" />
  </Button>
</template>
