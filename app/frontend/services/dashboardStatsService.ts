interface WorkspaceStats {
  id: number;
  name: string;
  total_sessions: number;
  average_accuracy: number;
  total_questions_answered: number;
  total_time_spent: number;
  current_streak: number;
  last_session_date: string | null;
  performance_level: 'excellent' | 'good' | 'average' | 'needs_improvement';
  quiz_count: number;
  has_content: boolean;
  has_flashcards: boolean;
  has_mindmaps: boolean;
  icon: { id: number; name: string; path: string } | null;
}

interface RecentSession {
  id: number;
  workspace_name: string;
  quiz_mode: string;
  accuracy: number;
  completed_at: string;
  performance_level: string;
  duration: string;
}

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
    recent_sessions: RecentSession[];
  };
  workspaces: WorkspaceStats[];
}

export class DashboardStatsService {
  private static formatTime(seconds: number): string {
    if (seconds < 3600) {
      const minutes = Math.floor(seconds / 60);
      return `${minutes}min`;
    }
    const hours = Math.floor(seconds / 3600);
    const remainingMinutes = Math.floor((seconds % 3600) / 60);
    return remainingMinutes > 0 ? `${hours}h ${remainingMinutes}min` : `${hours}h`;
  }

  private static getPerformanceLevel(
    accuracy: number
  ): 'excellent' | 'good' | 'average' | 'needs_improvement' {
    if (accuracy >= 90) return 'excellent';
    if (accuracy >= 75) return 'good';
    if (accuracy >= 60) return 'average';
    return 'needs_improvement';
  }

  static async fetchGlobalStats(): Promise<GlobalDashboardStats> {
    try {
      console.warn('Fallback API call - stats should come from server-side props');
      throw new Error('No API endpoint - using fallback data');
    } catch (error) {
      console.error('Erreur lors de la récupération des statistiques globales:', error);

      return {
        user: {
          total_workspaces: 3,
          total_quiz_sessions: 24,
          total_questions_answered: 156,
          total_study_time: 7200,
          global_average_accuracy: 78.5,
          current_streak: 5,
          longest_streak: 12,
        },
        performance: {
          weekly_sessions: 6,
          weekly_accuracy: 78.5,
          improvement_trend: 4.2,
          consistency_score: 72,
          performance_distribution: {
            excellent: 1,
            good: 1,
            average: 1,
            needs_improvement: 0,
          },
        },
        recent_activity: {
          last_session_date: new Date().toISOString(),
          recent_sessions: [
            {
              id: 1,
              workspace_name: 'JavaScript Fundamentals',
              quiz_mode: 'quiz',
              accuracy: 85,
              completed_at: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
              performance_level: 'good',
              duration: '15min',
            },
            {
              id: 2,
              workspace_name: 'React Advanced',
              quiz_mode: 'test',
              accuracy: 92,
              completed_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
              performance_level: 'excellent',
              duration: '22min',
            },
            {
              id: 3,
              workspace_name: 'Node.js Backend',
              quiz_mode: 'quiz',
              accuracy: 68,
              completed_at: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
              performance_level: 'average',
              duration: '18min',
            },
          ],
        },
        workspaces: [
          {
            id: 1,
            name: 'JavaScript Fundamentals',
            total_sessions: 8,
            average_accuracy: 85,
            total_questions_answered: 64,
            total_time_spent: 3600,
            current_streak: 3,
            last_session_date: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
            performance_level: 'good',
            quiz_count: 3,
            has_content: true,
            has_flashcards: true,
            has_mindmaps: false,
            icon: { id: 1, name: 'code', path: '/assets/icons/code.svg' },
          },
          {
            id: 2,
            name: 'React Advanced',
            total_sessions: 10,
            average_accuracy: 92,
            total_questions_answered: 72,
            total_time_spent: 2700,
            current_streak: 5,
            last_session_date: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
            performance_level: 'excellent',
            quiz_count: 5,
            has_content: true,
            has_flashcards: false,
            has_mindmaps: true,
            icon: { id: 2, name: 'react', path: '/assets/icons/react.svg' },
          },
          {
            id: 3,
            name: 'Node.js Backend',
            total_sessions: 6,
            average_accuracy: 68,
            total_questions_answered: 20,
            total_time_spent: 900,
            current_streak: 1,
            last_session_date: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
            performance_level: 'average',
            quiz_count: 2,
            has_content: true,
            has_flashcards: true,
            has_mindmaps: true,
            icon: { id: 3, name: 'server', path: '/assets/icons/server.svg' },
          },
        ],
      };
    }
  }

  static formatStudyTime(seconds: number): string {
    return this.formatTime(seconds);
  }

  static getPerformanceColor(level: string): string {
    switch (level) {
      case 'excellent':
        return 'text-green-600 dark:text-green-400';
      case 'good':
        return 'text-blue-600 dark:text-blue-400';
      case 'average':
        return 'text-orange-600 dark:text-orange-400';
      case 'needs_improvement':
        return 'text-red-600 dark:text-red-400';
      default:
        return 'text-gray-600 dark:text-gray-400';
    }
  }

  static getAccuracyColor(accuracy: number): string {
    if (accuracy >= 90) return 'text-green-600 dark:text-green-400';
    if (accuracy >= 75) return 'text-blue-600 dark:text-blue-400';
    if (accuracy >= 60) return 'text-orange-600 dark:text-orange-400';
    return 'text-red-600 dark:text-red-400';
  }
}
