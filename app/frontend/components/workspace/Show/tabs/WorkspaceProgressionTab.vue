<template>
  <div class="p-4 max-w-7xl mx-auto">
    <div class="rounded-xl border bg-card p-6 shadow-sm">
      <h2 class="text-2xl font-semibold mb-12 text-foreground text-center">Quiz Progress</h2>
      
      <div v-if="isLoading" class="flex items-center justify-center py-12">
        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        <span class="ml-3 text-muted-foreground">Loading statistics...</span>
      </div>

      <div v-else-if="!stats || stats.overview.total_sessions === 0" class="text-center py-12">
        <Icon name="chart-bar" class="h-16 w-16 mx-auto text-muted-foreground/50 mb-4" />
        <h3 class="text-lg font-medium text-foreground mb-2">No quiz sessions</h3>
        <p class="text-muted-foreground">Start your first quiz to see your statistics here.</p>
      </div>

      <div v-else class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 max-w-4xl mx-auto">
          <div class="bg-muted rounded-lg p-4">
            <div class="flex items-center gap-3">
              <Icon name="play-circle" class="h-8 w-8 text-primary" />
              <div>
                <p class="text-sm text-muted-foreground">Total Sessions</p>
                <p class="text-2xl font-bold text-foreground">{{ stats.overview.total_sessions }}</p>
              </div>
            </div>
          </div>

          <div class="bg-muted rounded-lg p-4">
            <div class="flex items-center gap-3">
              <Icon name="clock" class="h-8 w-8 text-primary" />
              <div>
                <p class="text-sm text-muted-foreground">Total Time</p>
                <p class="text-2xl font-bold text-foreground">{{ formatDuration(stats.overview.total_time_spent) }}</p>
              </div>
            </div>
          </div>

          <div class="bg-muted rounded-lg p-4">
            <div class="flex items-center gap-3">
              <Icon name="zap" class="h-8 w-8 text-primary" />
              <div>
                <p class="text-sm text-muted-foreground">Daily Streak</p>
                <p class="text-2xl font-bold text-foreground">{{ stats.performance.current_streak }}</p>
              </div>
            </div>
          </div>
        </div>

        <div class="bg-muted rounded-lg p-6 max-w-5xl mx-auto">
          <h3 class="text-lg font-semibold mb-6 text-foreground text-center">Performance Distribution</h3>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-3xl mx-auto">
            <div class="text-center">
              <div class="w-16 h-16 mx-auto bg-green-100 rounded-full flex items-center justify-center mb-3">
                <span class="text-2xl font-bold text-green-600">{{ stats.performance.performance_distribution.excellent }}</span>
              </div>
              <p class="text-sm font-medium text-foreground">Excellent</p>
              <p class="text-xs text-muted-foreground">≥ 90%</p>
            </div>
            
            <div class="text-center">
              <div class="w-16 h-16 mx-auto bg-blue-100 rounded-full flex items-center justify-center mb-3">
                <span class="text-2xl font-bold text-blue-600">{{ stats.performance.performance_distribution.good }}</span>
              </div>
              <p class="text-sm font-medium text-foreground">Good</p>
              <p class="text-xs text-muted-foreground">75-89%</p>
            </div>
            
            <div class="text-center">
              <div class="w-16 h-16 mx-auto bg-yellow-100 rounded-full flex items-center justify-center mb-3">
                <span class="text-2xl font-bold text-yellow-600">{{ stats.performance.performance_distribution.average }}</span>
              </div>
              <p class="text-sm font-medium text-foreground">Average</p>
              <p class="text-xs text-muted-foreground">60-74%</p>
            </div>
            
            <div class="text-center">
              <div class="w-16 h-16 mx-auto bg-red-100 rounded-full flex items-center justify-center mb-3">
                <span class="text-2xl font-bold text-red-600">{{ stats.performance.performance_distribution.needs_improvement }}</span>
              </div>
              <p class="text-sm font-medium text-foreground">Needs Improvement</p>
              <p class="text-xs text-muted-foreground">< 60%</p>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div class="bg-muted rounded-lg p-6">
            <div class="flex justify-between items-center mb-4">
              <div>
                <h3 class="text-lg font-semibold text-foreground">Recent Sessions</h3>
                <p class="text-sm text-muted-foreground">{{ stats.recent_sessions.length }} total sessions</p>
              </div>
              <div v-if="stats.recent_sessions.length > sessionsPerPage" class="flex items-center gap-2">
                <button 
                  @click="currentSessionPage > 1 && currentSessionPage--"
                  :disabled="currentSessionPage === 1"
                  class="p-1 rounded-md transition-colors"
                  :class="currentSessionPage === 1 ? 'text-muted-foreground cursor-not-allowed' : 'text-foreground hover:bg-card'"
                >
                  <Icon name="chevron-left" class="h-4 w-4" />
                </button>
                <span class="text-sm text-muted-foreground px-2">
                  {{ currentSessionPage }} / {{ totalSessionPages }}
                </span>
                <button 
                  @click="currentSessionPage < totalSessionPages && currentSessionPage++"
                  :disabled="currentSessionPage === totalSessionPages"
                  class="p-1 rounded-md transition-colors"
                  :class="currentSessionPage === totalSessionPages ? 'text-muted-foreground cursor-not-allowed' : 'text-foreground hover:bg-card'"
                >
                  <Icon name="chevron-right" class="h-4 w-4" />
                </button>
              </div>
            </div>
            <div class="space-y-3">
              <div v-for="session in paginatedSessions" :key="session.id" 
                   class="flex items-center justify-between p-4 bg-card rounded-lg border hover:border-primary/20 transition-colors">
                <div class="flex items-center gap-3">
                  <div class="w-3 h-3 rounded-full" 
                       :class="getPerformanceColor(session.performance_level)"></div>
                  <div>
                    <div class="flex items-center gap-2">
                      <p class="text-sm font-medium text-foreground">{{ session.quiz_mode === 'quiz' ? 'Learning' : 'Exam' }}</p>
                      <span class="text-xs bg-muted px-2 py-1 rounded-full text-muted-foreground">
                        {{ session.duration }}
                      </span>
                    </div>
                    <p class="text-xs text-muted-foreground">{{ formatDate(session.completed_at) }}</p>
                  </div>
                </div>
                <div class="text-right">
                  <p class="text-sm font-semibold text-foreground">{{ session.score }}/{{ session.total_questions }}</p>
                  <p class="text-xs font-medium" 
                     :class="session.accuracy >= 80 ? 'text-green-600' : session.accuracy >= 60 ? 'text-yellow-600' : 'text-red-600'">
                    {{ Math.round(session.accuracy) }}%
                  </p>
                </div>
              </div>
              <div v-if="stats.recent_sessions.length === 0" class="text-center py-6 text-muted-foreground">
                No sessions recorded
              </div>
            </div>
          </div>

          <div v-if="stats.detailed_stats.most_difficult_questions?.length > 0" class="bg-muted rounded-lg p-6">
            <h3 class="text-lg font-semibold mb-4 text-foreground">Most Difficult Questions</h3>
            <div class="space-y-3">
              <div v-for="question in stats.detailed_stats.most_difficult_questions" :key="question.question" 
                   class="p-4 bg-card rounded-lg">
                <div class="flex justify-between items-start">
                  <div class="flex-1 mr-4">
                    <p class="text-sm text-foreground line-clamp-2">{{ question.question }}</p>
                    <p class="text-xs text-muted-foreground mt-1">{{ formatQuestionType(question.type) }}</p>
                  </div>
                  <div class="text-right">
                    <p class="text-sm font-semibold text-foreground">{{ Math.round(question.success_rate) }}%</p>
                    <p class="text-xs text-muted-foreground">{{ question.attempts }} attempts</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import Icon from '@/components/ui/icon/Icon.vue';

interface Props {
  workspaceId: number;
}

const props = defineProps<Props>();

const isLoading = ref(true);
const stats = ref<any>(null);
const currentSessionPage = ref(1);
const sessionsPerPage = 8;

const formatDuration = (seconds: number): string => {
  if (!seconds) return '0s';
  
  const hours = Math.floor(seconds / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  const secs = seconds % 60;

  if (hours > 0) {
    return `${hours}h ${minutes}m`;
  } else if (minutes > 0) {
    return `${minutes}m ${secs}s`;
  } else {
    return `${secs}s`;
  }
};

const formatDate = (dateString: string): string => {
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', { 
    day: 'numeric', 
    month: 'short',
    hour: '2-digit',
    minute: '2-digit'
  });
};

const getPerformanceColor = (level: string): string => {
  switch (level) {
    case 'excellent': return 'bg-green-500';
    case 'good': return 'bg-blue-500';
    case 'average': return 'bg-yellow-500';
    case 'needs_improvement': return 'bg-red-500';
    default: return 'bg-gray-500';
  }
};

const totalSessionPages = computed((): number => {
  if (!stats.value?.recent_sessions) return 1;
  return Math.ceil(stats.value.recent_sessions.length / sessionsPerPage);
});

const paginatedSessions = computed(() => {
  if (!stats.value?.recent_sessions) return [];
  const start = (currentSessionPage.value - 1) * sessionsPerPage;
  const end = start + sessionsPerPage;
  return stats.value.recent_sessions.slice(start, end);
});

const formatQuestionType = (type: string): string => {
  const typeMap: Record<string, string> = {
    'true_false': 'True/False',
    'multiple_choice': 'Multiple Choice',
    'single_choice': 'Single Choice',
    'open_question': 'Open Question',
    'fill_blank': 'Fill in the Blank',
    'matching': 'Matching',
    'ordering': 'Ordering'
  };
  
  return typeMap[type] || type.charAt(0).toUpperCase() + type.slice(1).replace('_', ' ');
};

const getCsrfToken = (): string => {
  const meta = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]');
  if (!meta) throw new Error('<meta name="csrf-token"> tag not found');
  return meta.content;
};


const loadStats = async (): Promise<void> => {
  try {
    const response = await fetch(`/workspaces/${props.workspaceId}/stats.json`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
      }
    });

    if (!response.ok) {
      throw new Error(`HTTP Error ${response.status}`);
    }

    const data = await response.json();
    stats.value = data.stats;
  } catch (error) {
    console.error('Error loading statistics:', error);
    stats.value = {
      overview: { total_sessions: 0 },
      performance: {
        performance_distribution: { excellent: 0, good: 0, average: 0, needs_improvement: 0 },
        current_streak: 0,
        best_accuracy: 0,
        average_session_time: 0,
        improvement_trend: 0
      },
      detailed_stats: {
        consistency_score: 0,
        most_difficult_questions: []
      },
      recent_sessions: []
    };
  } finally {
    isLoading.value = false;
  }
};

onMounted(() => {
  loadStats();
});
</script>