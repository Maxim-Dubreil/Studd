<template>
  <Card>
    <CardHeader class="px-6 pt-6">
      <CardTitle class="flex items-center text-lg">
        <Icon name="bar-chart-3" class="mr-3 h-5 w-5 text-violet-500 dark:text-violet-400" />
        {{ title }}
      </CardTitle>
    </CardHeader>
    <CardContent class="pt-2 flex items-center justify-around min-h-[100px]">
      <div class="grid grid-cols-2 gap-4 md:grid-cols-4 w-full">
        <div v-for="item in items" :key="item.label" class="text-center">
          <div class="mb-2 text-2xl font-bold" :class="item.textColor">
            {{ item.value }}
          </div>
          <div class="text-sm text-gray-600 dark:text-gray-400">{{ item.label }} ({{ item.range }})</div>
        </div>
      </div>
    </CardContent>
  </Card>
</template>

<script setup lang="ts">
import Icon from '@/components/ui/icon/Icon.vue';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

interface PerformanceDistributionItem {
  label: string;
  value: number;
  range: string;
  bgColor: string;
  textColor: string;
}

interface Props {
  title: string;
  items: PerformanceDistributionItem[];
}

defineProps<Props>();
</script>
