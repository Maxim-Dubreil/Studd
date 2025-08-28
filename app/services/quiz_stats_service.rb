class QuizStatsService
  attr_reader :workspace, :user

  def initialize(workspace, user = nil)
    @workspace = workspace
    @user = user
  end

  def call
    {
      overview: overview_stats,
      performance: performance_stats,
      progress: progress_stats,
      detailed_stats: detailed_stats,
      recent_sessions: recent_sessions_data
    }
  end

  private

  def base_sessions
    sessions = workspace.quiz_sessions.completed.includes(:quiz_session_answers)
    sessions = sessions.where(user: user) if user
    sessions
  end

  def overview_stats
    sessions = base_sessions
    
    {
      total_sessions: sessions.count,
      total_questions_answered: sessions.sum(:total_questions),
      total_time_spent: sessions.sum(:duration_seconds),
      average_accuracy: sessions.average(:accuracy_percentage)&.round(1) || 0,
      quiz_mode_breakdown: sessions.group(:quiz_mode).count,
      last_session_date: sessions.maximum(:completed_at)
    }
  end

  def performance_stats
    sessions = base_sessions
    return default_performance_stats if sessions.empty?

    recent_sessions = sessions.order('quiz_sessions.created_at DESC').limit(10)
    
    {
      current_streak: calculate_streak(sessions),
      best_accuracy: sessions.maximum(:accuracy_percentage) || 0,
      average_session_time: sessions.average(:duration_seconds)&.round(0) || 0,
      improvement_trend: calculate_improvement_trend(recent_sessions),
      performance_distribution: calculate_performance_distribution(sessions),
      question_type_performance: calculate_question_type_performance(sessions)
    }
  end

  def progress_stats
    sessions = base_sessions
    return default_progress_stats if sessions.empty?

    sessions_no_order = base_sessions.reorder('')
    
    monthly_data = sessions_no_order
      .where('quiz_sessions.created_at': 3.months.ago..Time.current)
      .group("DATE_TRUNC('month', quiz_sessions.created_at)")
      .group(:quiz_mode)
      .average(:accuracy_percentage)

    weekly_data = sessions_no_order
      .where('quiz_sessions.created_at': 8.weeks.ago..Time.current)
      .group("DATE_TRUNC('week', quiz_sessions.created_at)")
      .average(:accuracy_percentage)

    {
      monthly_accuracy: monthly_data,
      weekly_accuracy: weekly_data,
      sessions_per_week: sessions_no_order
        .where('quiz_sessions.created_at': 8.weeks.ago..Time.current)
        .group("DATE_TRUNC('week', quiz_sessions.created_at)")
        .count,
      learning_velocity: calculate_learning_velocity(sessions.order('quiz_sessions.created_at'))
    }
  end

  def detailed_stats
    sessions = base_sessions
    answers = QuizSessionAnswer.joins(:quiz_session)
                              .where(quiz_session: sessions)

    {
      most_difficult_questions: find_most_difficult_questions(answers),
      strongest_topics: find_strongest_topics(answers),
      time_patterns: analyze_time_patterns(sessions),
      consistency_score: calculate_consistency_score(sessions)
    }
  end

  def recent_sessions_data
    base_sessions
      .order('quiz_sessions.created_at DESC')
      .limit(50)
      .map do |session|
        {
          id: session.id,
          completed_at: session.completed_at,
          quiz_mode: session.quiz_mode,
          score: session.score,
          total_questions: session.total_questions,
          accuracy: session.accuracy,
          duration: session.duration_formatted,
          performance_level: session.performance_level,
          improvement: session.improvement_from_previous
        }
      end
  end

  def calculate_streak(sessions)
    return 0 if sessions.empty?
    
    sessions_by_date = sessions
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

  def calculate_improvement_trend(sessions)
    return 0 if sessions.count < 2
    
    first_half = sessions.first(sessions.count / 2)
    second_half = sessions.last(sessions.count / 2)
    
    first_avg = first_half.sum(&:accuracy) / first_half.count.to_f
    second_avg = second_half.sum(&:accuracy) / second_half.count.to_f
    
    ((second_avg - first_avg) / first_avg * 100).round(1)
  end

  def calculate_performance_distribution(sessions)
    {
      excellent: sessions.where('accuracy_percentage >= ?', 90).count,
      good: sessions.where('accuracy_percentage >= ? AND accuracy_percentage < ?', 75, 90).count,
      average: sessions.where('accuracy_percentage >= ? AND accuracy_percentage < ?', 60, 75).count,
      needs_improvement: sessions.where('accuracy_percentage < ?', 60).count
    }
  end

  def calculate_question_type_performance(sessions)
    answers = QuizSessionAnswer.joins(:quiz_session).where(quiz_session: sessions)
    
    answers.group(:question_type).group(:is_correct).count.transform_keys do |key|
      { question_type: key[0], is_correct: key[1] }
    end
  end

  def find_most_difficult_questions(answers)
    answers
      .group(:question_text)
      .group(:question_type)
      .average('CASE WHEN is_correct THEN 1.0 ELSE 0.0 END')
      .sort_by { |_, avg| avg }
      .first(8)
      .map do |(question_info, success_rate)|
        {
          question: question_info[0],
          type: question_info[1],
          success_rate: (success_rate * 100).round(1),
          attempts: answers.where(question_text: question_info[0]).count
        }
      end
  end

  def find_strongest_topics(answers)
    answers
      .where(is_correct: true)
      .group(:question_type)
      .average('CASE WHEN is_correct THEN 1.0 ELSE 0.0 END')
      .sort_by { |_, avg| -avg }
      .map do |type, success_rate|
        {
          topic: type.humanize,
          success_rate: (success_rate * 100).round(1),
          questions_count: answers.where(question_type: type).count
        }
      end
  end

  def analyze_time_patterns(sessions)
    sessions_no_order = sessions.reorder('')
    
    by_hour = sessions_no_order.group("EXTRACT(hour FROM quiz_sessions.created_at)").average(:accuracy_percentage)
    by_day = sessions_no_order.group("EXTRACT(dow FROM quiz_sessions.created_at)").average(:accuracy_percentage)
    
    {
      best_hour: by_hour.max_by { |_, accuracy| accuracy }&.first,
      best_day: by_day.max_by { |_, accuracy| accuracy }&.first,
      hour_performance: by_hour,
      day_performance: by_day
    }
  end

  def calculate_consistency_score(sessions)
    return 0 if sessions.count < 3
    
    accuracies = sessions.pluck(:accuracy_percentage)
    mean = accuracies.sum / accuracies.count.to_f
    variance = accuracies.sum { |x| (x - mean) ** 2 } / accuracies.count.to_f
    std_dev = Math.sqrt(variance)
    
    [100 - std_dev, 0].max.round(1)
  end

  def calculate_learning_velocity(sessions)
    return 0 if sessions.count < 5
    
    improvements = sessions.each_cons(2).map do |prev, curr|
      curr.accuracy - prev.accuracy
    end
    
    improvements.sum / improvements.count.to_f
  end

  def default_performance_stats
    {
      current_streak: 0,
      best_accuracy: 0,
      average_session_time: 0,
      improvement_trend: 0,
      performance_distribution: { excellent: 0, good: 0, average: 0, needs_improvement: 0 },
      question_type_performance: {}
    }
  end

  def default_progress_stats
    {
      monthly_accuracy: {},
      weekly_accuracy: {},
      sessions_per_week: {},
      learning_velocity: 0
    }
  end
end
