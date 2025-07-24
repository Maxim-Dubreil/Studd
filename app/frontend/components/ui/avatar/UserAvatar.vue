<script setup lang="ts">
import { Icon } from '@/components/ui/icon'
import { Button } from '@/components/ui/button'

</script>

<template>
  <Button @click="$emit('')" variant="gradient" size="default" radius="xl" title="Se déconnecter"
    class="shadow-lg backdrop-blur-sm">
    <Icon name="user" />
  </Button>
</template>