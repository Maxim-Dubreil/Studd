<script setup lang="ts">
import { computed, withDefaults } from 'vue';
import Icon from '@/components/ui/icon/Icon.vue';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import StatCard from '@/components/ui/StatCard.vue';
import { useStatsFormatting } from '@/composables/useStatsFormatting';

interface Props {
  weeklyAccuracy: number | string;
  improvementTrend: number | string;
  consistencyScore: number | string;
  weeklySessionsCount: number;
}

const props = withDefaults(defineProps<Props>(), {
  weeklyAccuracy: 0,
  improvementTrend: 0,
  consistencyScore: 0,
  weeklySessionsCount: 0,
});

const { getPerformanceColor } = useStatsFormatting();

const weeklyAccuracyNum = computed(() => Number(props.weeklyAccuracy));
const improvementTrendNum = computed(() => Number(props.improvementTrend));
const consistencyScoreNum = computed(() => Number(props.consistencyScore));

const trendColor = computed(() => {
  if (improvementTrendNum.value > 0) return 'text-green-600 dark:text-green-400';
  if (improvementTrendNum.value < 0) return 'text-red-600 dark:text-red-400';
  return 'text-gray-600 dark:text-gray-400';
});

const trendIcon = computed(() => {
  if (improvementTrendNum.value > 0) return 'trending-up';
  if (improvementTrendNum.value < 0) return 'trending-down';
  return 'minus';
});

const consistencyLevel = computed(() => {
  if (consistencyScoreNum.value >= 80) return { level: 'Excellent', color: 'text-green-600 dark:text-green-400' };
  if (consistencyScoreNum.value >= 60) return { level: 'Good', color: 'text-blue-600 dark:text-blue-400' };
  if (consistencyScoreNum.value >= 40) return { level: 'Average', color: 'text-orange-600 dark:text-orange-400' };
  return { level: 'Needs Work', color: 'text-red-600 dark:text-red-400' };
});

const weeklyActivityLevel = computed(() => {
  if (props.weeklySessionsCount >= 5) return { level: 'Very Active', color: 'text-green-600 dark:text-green-400', icon: 'zap' };
  if (props.weeklySessionsCount >= 3) return { level: 'Active', color: 'text-blue-600 dark:text-blue-400', icon: 'activity' };
  if (props.weeklySessionsCount >= 1) return { level: 'Moderate', color: 'text-orange-600 dark:text-orange-400', icon: 'play' };
  return { level: 'Inactive', color: 'text-red-600 dark:text-red-400', icon: 'pause' };
});

const weeklyData = computed(() => {
  const totalSessions = props.weeklySessionsCount;
  
  const today = new Date();
  const dayOfWeek = today.getDay();
  const currentDayIndex = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
  
  return Array.from({ length: 7 }, (_, i) => {
    let sessions = 0;
    
    if (totalSessions > 0 && i === currentDayIndex) {
      sessions = totalSessions;
    }

    return {
      dayShort: ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
      sessions: sessions,
      isToday: i === currentDayIndex,
    };
  });
});


</script>

<template>
  <div class="space-y-6">
    <div class="grid grid-cols-1 gap-4 md:grid-cols-3">
      <StatCard
        icon="trending-up"
        label="Trend"
        :value="`${improvementTrendNum > 0 ? '+' : ''}${improvementTrendNum.toFixed(1)}%`"
        :subtitle="improvementTrendNum > 0 ? 'Improving' : 'Declining'"
      />
      
      <StatCard
        icon="target"
        label="Consistency"
        :value="`${Math.round(consistencyScoreNum)}%`"
        :subtitle="consistencyLevel.level"
      />
      
      <StatCard
        :icon="weeklyActivityLevel.icon"
        label="Activity"
        :value="weeklySessionsCount"
        :subtitle="weeklyActivityLevel.level"
      />
    </div>
    <Card>
      <CardHeader class="pb-4 px-6 pt-6">
        <CardTitle class="flex items-center text-lg">
          <Icon name="calendar-days" class="mr-3 h-5 w-5 text-violet-500 dark:text-violet-400" />
          Week Activity
        </CardTitle>
      </CardHeader>
      <CardContent class="pt-2">
        <div class="space-y-4">
          <div class="grid grid-cols-7 gap-x-2 text-center">
            <div v-for="(data, index) in weeklyData" :key="index" class="space-y-2">
              <div class="text-xs font-medium text-gray-500 dark:text-gray-400">
                {{ data.dayShort }}
              </div>
              <div 
                class="relative w-10 h-10 mx-auto rounded-lg flex items-center justify-center transition-all duration-200"
                :class="[
                  data.sessions > 0 ? 'bg-blue-500' : 'bg-gray-200 dark:bg-gray-700',
                  data.isToday ? 'ring-2 ring-offset-2 ring-blue-500 dark:ring-offset-gray-900' : ''
                ]"
                :title="data.sessions > 0 ? `${data.sessions} session(s)` : 'No sessions'"
              >
                <span v-if="data.sessions > 0" class="text-sm font-bold text-white">
                  {{ data.sessions }}
                </span>
                <Icon v-else name="minus" class="h-4 w-4 text-gray-400 dark:text-gray-500" />
              </div>
            </div>
          </div>
          
          <div class="grid grid-cols-2 gap-4 pt-4 border-t">
            <div class="text-center">
              <div class="text-sm font-medium text-gray-600 dark:text-gray-400">Total Sessions</div>
              <div class="text-lg font-bold text-gray-800 dark:text-gray-100">{{ weeklySessionsCount }}</div>
            </div>
            <div class="text-center">
              <div class="text-sm font-medium text-gray-600 dark:text-gray-400">Activity Level</div>
              <div class="text-lg font-bold" :class="weeklyActivityLevel.color">
                {{ weeklyActivityLevel.level }}
              </div>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  </div>
</template>
