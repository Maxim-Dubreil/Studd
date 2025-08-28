class GlobalDashboardStatsService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    {
      user: user_overview_stats,
      performance: global_performance_stats,
      recent_activity: recent_activity_stats,
      workspaces: workspace_stats
    }
  end

  private

  def user_workspaces
    @user_workspaces ||= user.workspaces.includes(:quiz_sessions, :quizzes, :icon, :raw_content, :flash_cards_sets, :mindmaps)
  end

  def all_user_sessions
    @all_user_sessions ||= user.quiz_sessions
                              .completed
                              .includes(:quiz_session_answers, :workspace)
  end

  def user_overview_stats
    sessions = all_user_sessions
    
    {
      total_workspaces: user_workspaces.count,
      total_quiz_sessions: sessions.count,
      total_questions_answered: sessions.sum(:total_questions),
      total_study_time: sessions.sum(:duration_seconds),
      global_average_accuracy: (sessions.average(:accuracy_percentage) || 0).to_f.round(1),
      current_streak: calculate_global_streak,
      longest_streak: calculate_longest_streak
    }
  end

  def global_performance_stats
    sessions = all_user_sessions
    recent_sessions = sessions.order('quiz_sessions.created_at DESC').limit(20)
    
    weekly_sessions = sessions.where('quiz_sessions.created_at >= ?', 1.week.ago)
    
    {
      weekly_sessions: weekly_sessions.count,
      weekly_accuracy: (weekly_sessions.average(:accuracy_percentage) || 0).to_f.round(1),
      improvement_trend: calculate_global_improvement_trend(recent_sessions),
      consistency_score: calculate_global_consistency_score(sessions),
      performance_distribution: calculate_global_performance_distribution(sessions)
    }
  end

  def recent_activity_stats
    recent_sessions = all_user_sessions
                        .order('quiz_sessions.completed_at DESC')
                        .limit(5)
                        .includes(:workspace)

    {
      last_session_date: recent_sessions.first&.completed_at,
      recent_sessions: recent_sessions.map do |session|
        {
          id: session.id,
          workspace_name: session.workspace.name,
          quiz_mode: session.quiz_mode,
          accuracy: session.accuracy_percentage,
          completed_at: session.completed_at,
          performance_level: session.performance_level,
          duration: session.duration_formatted
        }
      end
    }
  end

  def workspace_stats
    workspace_data = user_workspaces.map do |workspace|
      workspace_sessions = workspace.quiz_sessions.completed.where(user: user)
      
      {
        id: workspace.id,
        name: workspace.name,
        total_sessions: workspace_sessions.count,
        average_accuracy: (workspace_sessions.average(:accuracy_percentage) || 0).to_f.round(1),
        total_questions_answered: workspace_sessions.sum(:total_questions),
        total_time_spent: workspace_sessions.sum(:duration_seconds),
        current_streak: calculate_workspace_streak(workspace),
        last_session_date: workspace_sessions.maximum(:completed_at),
        performance_level: get_performance_level(workspace_sessions.average(:accuracy_percentage) || 0),
        quiz_count: workspace.quizzes.count,
        has_content: workspace.raw_content.present?,
        has_flashcards: workspace.flash_cards_sets.exists?,
        has_mindmaps: workspace.mindmaps.exists?,
        icon: workspace.icon ? { id: workspace.icon.id, name: workspace.icon.name, path: workspace.icon.path } : nil
      }
    end
    
    workspace_data
      .sort_by { |ws| ws[:last_session_date] || Time.at(0) }
      .reverse
      .first(4)
  end

  def calculate_global_streak
    return 0 if all_user_sessions.empty?
    
    sessions_by_date = all_user_sessions
      .order('quiz_sessions.created_at DESC')
      .group_by { |session| session.created_at.to_date }
      .sort_by(&:first)
      .reverse
    
    return 0 if sessions_by_date.empty?
    
    streak = 0
    current_date = Date.current
    
    sessions_by_date.each do |date, _sessions_for_date|
      if date == current_date || date == current_date - 1.day
        streak += 1 if date == current_date
        current_date = date - 1.day
      else
        break
      end
    end
    
    streak
  end

  def calculate_longest_streak
    return 0 if all_user_sessions.empty?
    
    sessions_by_date = all_user_sessions
      .order('quiz_sessions.created_at ASC')
      .group_by { |session| session.created_at.to_date }
      .keys
      .sort
    
    return 0 if sessions_by_date.empty?
    
    max_streak = 0
    current_streak = 1
    
    sessions_by_date.each_cons(2) do |date1, date2|
      if date2 == date1 + 1.day
        current_streak += 1
      else
        max_streak = [max_streak, current_streak].max
        current_streak = 1
      end
    end
    
    [max_streak, current_streak].max
  end

  def calculate_workspace_streak(workspace)
    workspace_sessions = workspace.quiz_sessions.completed.where(user: user)
    return 0 if workspace_sessions.empty?
    
    sessions_by_date = workspace_sessions
      .order('quiz_sessions.created_at DESC')
      .group_by { |session| session.created_at.to_date }
      .sort_by(&:first)
      .reverse
    
    return 0 if sessions_by_date.empty?
    
    streak = 0
    current_date = Date.current
    
    sessions_by_date.each do |date, _sessions_for_date|
      if date == current_date
        streak += 1
        current_date = current_date - 1.day
      else
        break
      end
    end
    
    streak
  end

  def calculate_global_improvement_trend(recent_sessions)
    return 0.0 if recent_sessions.count < 4
    
    quarter_size = recent_sessions.count / 4
    return 0.0 if quarter_size == 0
    
    recent_quarter = recent_sessions.first(quarter_size)
    older_quarter = recent_sessions.last(quarter_size)
    
    return 0.0 if recent_quarter.empty? || older_quarter.empty?
    
    recent_avg = (recent_quarter.sum(&:accuracy_percentage) || 0).to_f / recent_quarter.count.to_f
    older_avg = (older_quarter.sum(&:accuracy_percentage) || 0).to_f / older_quarter.count.to_f
    
    return 0.0 if older_avg.zero?
    
    ((recent_avg - older_avg) / older_avg * 100).round(1)
  end

  def calculate_global_consistency_score(sessions)
    return 0.0 if sessions.count < 3
    
    accuracies = sessions.pluck(:accuracy_percentage).compact
    return 0.0 if accuracies.empty?
    
    mean = accuracies.sum / accuracies.count.to_f
    variance = accuracies.sum { |x| (x - mean) ** 2 } / accuracies.count.to_f
    std_dev = Math.sqrt(variance)
    
    [100 - std_dev, 0].max.round(1)
  end

  def calculate_global_performance_distribution(sessions)
    {
      excellent: sessions.where('accuracy_percentage >= ?', 90).count,
      good: sessions.where('accuracy_percentage >= ? AND accuracy_percentage < ?', 75, 90).count,
      average: sessions.where('accuracy_percentage >= ? AND accuracy_percentage < ?', 60, 75).count,
      needs_improvement: sessions.where('accuracy_percentage < ?', 60).count
    }
  end

  def get_performance_level(accuracy)
    case accuracy
    when 90..100 then 'excellent'
    when 75..89 then 'good'
    when 60..74 then 'average'
    else 'needs_improvement'
    end
  end
end
