<script setup lang="ts">
import { onMounted, ref, computed } from 'vue';
import Icon from '@/components/ui/icon/Icon.vue';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import StatCard from '@/components/ui/StatCard.vue';
import PerformanceDistributionCard from '@/components/ui/PerformanceDistributionCard.vue';
import PerformanceChart from './PerformanceChart.vue';
import { DashboardStatsService } from '@/services/dashboardStatsService';
import { useIconResolver } from '@/composables/useIconResolver';
import { useStatsFormatting } from '@/composables/useStatsFormatting';

interface GlobalDashboardStats {
  user: {
    total_workspaces: number;
    total_quiz_sessions: number;
    total_questions_answered: number;
    total_study_time: number;
    global_average_accuracy: number;
    current_streak: number;
    longest_streak: number;
  };
  performance: {
    weekly_sessions: number;
    weekly_accuracy: number;
    improvement_trend: number;
    consistency_score: number;
    performance_distribution: {
      excellent: number;
      good: number;
      average: number;
      needs_improvement: number;
    };
  };
  recent_activity: {
    last_session_date: string | null;
    recent_sessions: Array<{
      id: number;
      workspace_name: string;
      quiz_mode: string;
      accuracy: number;
      completed_at: string;
      performance_level: string;
    }>;
  };
  workspaces: Array<{
    id: number;
    name: string;
    total_sessions: number;
    average_accuracy: number;
    total_questions_answered: number;
    total_time_spent: number;
    current_streak: number;
    last_session_date: string | null;
    performance_level: string;
    quiz_count: number;
    has_content: boolean;
    has_flashcards: boolean;
    has_mindmaps: boolean;
    icon: { id: number; name: string; path: string } | null;
  }>;
}

interface Props {
  dashboardStats?: GlobalDashboardStats | null;
}

const props = withDefaults(defineProps<Props>(), {
  dashboardStats: null,
});

const stats = ref<GlobalDashboardStats | null>(null);
const isLoading = ref(true);
const error = ref<string | null>(null);

const { getIconUrl } = useIconResolver();
const { 
  formatStudyTime, 
  formatDate, 
  getPerformanceColor, 
  getAccuracyColor, 
  getPerformanceIcon,
  getPerformanceDistributionData 
} = useStatsFormatting();

const formattedStats = computed(() => {
  if (!stats.value) return null;
  
  return {
    totalStudyTime: formatStudyTime(stats.value.user.total_study_time),
    accuracyPercentage: Math.round(stats.value.user.global_average_accuracy),
    improvementTrend: stats.value.performance.improvement_trend > 0 ? 'positive' : 'negative',
    lastActivity: stats.value.recent_activity.last_session_date 
      ? formatDate(stats.value.recent_activity.last_session_date)
      : 'No recent activity',
    performanceLevel: stats.value.user.global_average_accuracy >= 90 ? 'excellent' :
                     stats.value.user.global_average_accuracy >= 75 ? 'good' :
                     stats.value.user.global_average_accuracy >= 60 ? 'average' : 'needs_improvement'
  };
});

const performanceDistributionItems = computed(() => {
  if (!stats.value) return [];
  return getPerformanceDistributionData(stats.value.performance.performance_distribution);
});

const loadDashboardStats = async () => {
  try {
    isLoading.value = true;
    error.value = null;
    
    console.log('Props received:', props.dashboardStats);
    
    if (props.dashboardStats) {
      stats.value = props.dashboardStats;
      console.log('Using server-side stats:', props.dashboardStats);
    } else {
      console.log('No props data, falling back to API');
      stats.value = await DashboardStatsService.fetchGlobalStats();
      console.log('Fetched stats from API');
    }
    
    console.log('Final stats:', stats.value);
  } catch (err) {
    error.value = 'Error loading dashboard statistics';
    console.error('Dashboard error:', err);
  } finally {
    isLoading.value = false;
  }
};

onMounted(() => {
  loadDashboardStats();
});
</script>

<template>
  <div class="flex-1 p-8">
    <div class="mb-8">
      <h1 class="text-3xl font-semibold text-gray-700 transition-colors duration-300 dark:text-gray-200">
        Dashboard
      </h1>
      <p class="mt-2 text-gray-500 dark:text-gray-400">
        Welcome to your learning space
      </p>
    </div>

    <div v-if="isLoading" class="flex items-center justify-center py-12">
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      <span class="ml-3 text-muted-foreground">Loading statistics...</span>
    </div>

    <div v-else-if="error" class="rounded-lg border bg-card p-4 shadow-sm">
      <div class="flex items-center">
        <Icon name="alert-circle" class="mr-3 h-5 w-5 text-red-500" />
        <p class="text-foreground">{{ error }}</p>
        <button 
          @click="loadDashboardStats"
          class="ml-auto rounded bg-muted px-3 py-1 text-sm text-foreground hover:bg-muted/80"
        >
          Retry
        </button>
      </div>
    </div>

    <div v-else-if="stats && formattedStats" class="space-y-8">
      <Card class="overflow-hidden border-0 bg-gradient-to-r from-violet-500 to-blue-600 text-white shadow-lg transition-all duration-300 hover:scale-[1.02] hover:shadow-xl dark:from-violet-600 dark:to-blue-700">
        <CardContent class="p-8">
          <div class="flex items-center justify-between">
            <div class="flex-1">
              <h2 class="mb-3 text-2xl font-bold">Continue your learning journey!</h2>
              <p class="text-lg text-violet-100 dark:text-violet-200">
                You have an average accuracy of {{ formattedStats.accuracyPercentage }}% on your quizzes
              </p>
              <div class="mt-4">
                <div class="flex items-center space-x-4 text-sm">
                  <span class="rounded-full bg-white/20 px-3 py-1">
                    {{ stats.user.current_streak }} day streak
                  </span>
                  <span class="rounded-full bg-white/20 px-3 py-1">
                    {{ formattedStats.totalStudyTime }} studied
                  </span>
                </div>
              </div>
            </div>
            <div class="flex items-center space-x-6">
              <div class="text-center">
                <div class="text-3xl font-bold">{{ formattedStats.accuracyPercentage }}%</div>
                <div class="text-sm text-violet-200">Accuracy</div>
              </div>
              <Icon :name="getPerformanceIcon(formattedStats.performanceLevel)" class="h-16 w-16 text-white opacity-80" />
            </div>
          </div>
        </CardContent>
      </Card>

      <div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-4">
        <StatCard
          icon="brain"
          label="Quizzes Completed"
          :value="stats.user.total_quiz_sessions"
          :subtitle="`${stats.user.total_questions_answered} questions answered`"
        />
        
        <StatCard
          icon="target"
          label="Accuracy"
          :value="`${formattedStats.accuracyPercentage}%`"
          :subtitle="`${stats.performance.weekly_sessions} sessions/week`"
        />
        
        <StatCard
          icon="clock"
          label="Study Time"
          :value="formattedStats.totalStudyTime"
          :subtitle="`${stats.performance.weekly_sessions} sessions/week`"
        />
        
        <StatCard
          icon="flame"
          label="Current Streak"
          :value="stats.user.current_streak"
          :subtitle="`Best: ${stats.user.longest_streak} days`"
        />
      </div>

      <div class="grid grid-cols-1 gap-8 lg:grid-cols-2">
        <Card>
          <CardHeader class="pb-4 px-6 pt-6">
            <CardTitle class="flex items-center text-lg">
              <Icon name="folder" class="mr-3 h-5 w-5 text-violet-500 dark:text-violet-400" />
              Recent Workspaces
            </CardTitle>
          </CardHeader>
          <CardContent class="pt-2">
            <div v-if="stats.workspaces.length === 0" class="text-center py-8 text-gray-500 dark:text-gray-400">
              <Icon name="folder-plus" class="mx-auto mb-3 h-12 w-12 opacity-50" />
              <p>No workspaces created</p>
              <p class="text-sm">Create your first workspace to get started!</p>
            </div>
            <div v-else class="space-y-4">
              <a 
                v-for="workspace in stats.workspaces"
                :key="workspace.id"
                :href="`/workspaces/${workspace.id}`"
                class="flex items-center justify-between rounded-lg border p-4 transition-colors hover:bg-gray-50 dark:hover:bg-slate-800 mb-4 cursor-pointer block"
              >
                <div class="flex items-center flex-1">
                  <div class="mr-4 flex-shrink-0">
                    <img 
                      v-if="workspace.icon && workspace.icon.path" 
                      :src="getIconUrl(workspace.icon.path)" 
                      class="h-10 w-10 rounded-lg object-contain dark:invert" 
                    />
                    <div v-else class="w-10 h-10 rounded-lg bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
                      <Icon 
                        name="folder" 
                        class="h-5 w-5 text-gray-500 dark:text-gray-500"
                      />
                    </div>
                  </div>
                  <div class="flex-1">
                    <h4 class="font-medium text-gray-900 dark:text-gray-100">{{ workspace.name }}</h4>
                    <div class="mt-1 flex items-center space-x-4 text-sm text-gray-500 dark:text-gray-400">
                      <span>{{ workspace.total_sessions }} quiz{{ workspace.total_sessions !== 1 ? 'zes' : '' }}</span>
                      <span class="font-medium" :class="getAccuracyColor(workspace.average_accuracy)">
                        {{ Math.round(workspace.average_accuracy) }}% accuracy
                      </span>
                    </div>
                    <div class="mt-1 flex items-center space-x-3 text-xs text-gray-400 dark:text-gray-500">
                      <span v-if="workspace.quiz_count > 0" class="flex items-center">
                        <Icon name="brain" class="mr-1 h-3 w-3" />
                        {{ workspace.quiz_count }} quiz{{ workspace.quiz_count !== 1 ? 'zes' : '' }}
                      </span>
                      <span v-if="workspace.has_content" class="flex items-center">
                        <Icon name="file-text" class="mr-1 h-3 w-3" />
                        Content
                      </span>
                      <span v-if="workspace.has_flashcards" class="flex items-center">
                        <Icon name="layers" class="mr-1 h-3 w-3" />
                        Flashcards
                      </span>
                      <span v-if="workspace.has_mindmaps" class="flex items-center">
                        <Icon name="share-2" class="mr-1 h-3 w-3" />
                        Mind Map
                      </span>
                    </div>
                  </div>
                </div>
                <div class="flex items-center space-x-3">
                  <div class="text-center">
                    <Icon 
                      :name="getPerformanceIcon(workspace.performance_level)" 
                      class="h-5 w-5"
                      :class="getPerformanceColor(workspace.performance_level)"
                    />
                  </div>
                </div>
              </a>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader class="pb-4 px-6 pt-6">
            <CardTitle class="flex items-center text-lg">
              <Icon name="activity" class="mr-3 h-5 w-5 text-violet-500 dark:text-violet-400" />
              Recent Activity
            </CardTitle>
          </CardHeader>
          <CardContent class="pt-2 pb-5">
            <div v-if="stats.recent_activity.recent_sessions.length === 0" class="text-center py-8 text-gray-500 dark:text-gray-400">
              <Icon name="calendar-x" class="mx-auto mb-3 h-12 w-12 opacity-50" />
              <p>No recent activity</p>
              <p class="text-sm">Start a quiz to see your progress!</p>
            </div>
            <div v-else class="space-y-4">
              <div 
                v-for="session in stats.recent_activity.recent_sessions.slice(0, 5)"
                :key="session.id"
                class="flex items-center justify-between rounded-lg border p-4 transition-colors hover:bg-gray-50 dark:hover:bg-slate-800"
              >
                <div class="flex-1">
                  <h4 class="font-medium text-gray-900 dark:text-gray-100">{{ session.workspace_name }}</h4>
                  <div class="mt-1 flex items-center space-x-4 text-sm text-gray-500 dark:text-gray-400">
                    <span class="capitalize">{{ session.quiz_mode }}</span>
                    <span>{{ formatDate(session.completed_at) }}</span>
                    <span v-if="session.duration">{{ session.duration }}</span>
                  </div>
                </div>
                <div class="text-right">
                  <div class="font-medium" :class="getAccuracyColor(session.accuracy)">
                    {{ Math.round(session.accuracy) }}%
                  </div>
                  <Icon 
                    :name="getPerformanceIcon(session.performance_level)" 
                    class="ml-auto mt-1 h-4 w-4"
                    :class="getPerformanceColor(session.performance_level)"
                  />
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <PerformanceDistributionCard 
        title="Performance Distribution" 
        :items="performanceDistributionItems"
      />

      <PerformanceChart 
        :weekly-accuracy="stats.performance.weekly_accuracy"
        :improvement-trend="stats.performance.improvement_trend"
        :consistency-score="stats.performance.consistency_score"
        :weekly-sessions-count="stats.performance.weekly_sessions"
      />
    </div>
  </div>
</template>
