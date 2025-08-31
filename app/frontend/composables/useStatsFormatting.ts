export function useStatsFormatting() {
  const formatStudyTime = (seconds: number): string => {
    if (!seconds || seconds === 0) return '0min';

    if (seconds < 3600) {
      const minutes = Math.floor(seconds / 60);
      return `${minutes}min`;
    }

    const hours = Math.floor(seconds / 3600);
    const remainingMinutes = Math.floor((seconds % 3600) / 60);
    return remainingMinutes > 0 ? `${hours}h ${remainingMinutes}min` : `${hours}h`;
  };

  const formatDate = (dateString: string): string => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      day: 'numeric',
      month: 'short',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  const getPerformanceColor = (level: string): string => {
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
        return 'text-muted-foreground';
    }
  };

  const getAccuracyColor = (accuracy: number): string => {
    if (accuracy >= 90) return 'text-green-600 dark:text-green-400';
    if (accuracy >= 75) return 'text-blue-600 dark:text-blue-400';
    if (accuracy >= 60) return 'text-orange-600 dark:text-orange-400';
    return 'text-red-600 dark:text-red-400';
  };

  const getPerformanceIcon = (level: string): string => {
    switch (level) {
      case 'excellent':
        return 'trophy';
      case 'good':
        return 'thumbs-up';
      case 'average':
        return 'trending-up';
      case 'needs_improvement':
        return 'alert-circle';
      default:
        return 'help-circle';
    }
  };

  const getPerformanceDistributionData = (distribution: {
    excellent: number;
    good: number;
    average: number;
    needs_improvement: number;
  }) => [
    {
      label: 'Excellent',
      value: distribution.excellent,
      range: '≥ 90%',
      bgColor: 'bg-green-100',
      textColor: 'text-green-600',
    },
    {
      label: 'Good',
      value: distribution.good,
      range: '75-89%',
      bgColor: 'bg-blue-100',
      textColor: 'text-blue-600',
    },
    {
      label: 'Average',
      value: distribution.average,
      range: '60-74%',
      bgColor: 'bg-yellow-100',
      textColor: 'text-yellow-600',
    },
    {
      label: 'Needs Work',
      value: distribution.needs_improvement,
      range: '< 60%',
      bgColor: 'bg-red-100',
      textColor: 'text-red-600',
    },
  ];

  return {
    formatStudyTime,
    formatDate,
    getPerformanceColor,
    getAccuracyColor,
    getPerformanceIcon,
    getPerformanceDistributionData,
  };
}
