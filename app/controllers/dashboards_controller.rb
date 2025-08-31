class DashboardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = current_user
    
    begin
      stats_service = GlobalDashboardStatsService.new(@user)
      @dashboard_stats = stats_service.call
      Rails.logger.info "Dashboard stats calculated: #{@dashboard_stats.keys}"
      Rails.logger.info "User sessions count: #{@user.quiz_sessions.count}"
      Rails.logger.info "User workspaces count: #{@user.workspaces.count}"
    rescue => e
      Rails.logger.error "Error calculating dashboard stats: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      @dashboard_stats = {
        user: {
          total_workspaces: @user.workspaces.count,
          total_quiz_sessions: 0,
          total_questions_answered: 0,
          total_study_time: 0,
          global_average_accuracy: 0.0,
          current_streak: 0,
          longest_streak: 0
        },
        performance: {
          weekly_sessions: 0,
          weekly_accuracy: 0.0,
          improvement_trend: 0.0,
          consistency_score: 0.0,
          performance_distribution: {
            excellent: 0,
            good: 0,
            average: 0,
            needs_improvement: 0
          }
        },
        recent_activity: {
          last_session_date: nil,
          recent_sessions: []
        },
        workspaces: @user.workspaces.limit(4).map do |workspace|
          {
            id: workspace.id,
            name: workspace.name,
            total_sessions: 0,
            average_accuracy: 0.0,
            total_questions_answered: 0,
            total_time_spent: 0,
            current_streak: 0,
            last_session_date: nil,
            performance_level: 'needs_improvement',
            quiz_count: workspace.quizzes.count,
            has_content: workspace.raw_content.present?,
            has_flashcards: workspace.flash_cards_sets.exists?,
            has_mindmaps: workspace.mindmaps.exists?,
            icon: workspace.icon ? { id: workspace.icon.id, name: workspace.icon.name, path: workspace.icon.path } : nil
          }
        end
      }
    end
  end
end