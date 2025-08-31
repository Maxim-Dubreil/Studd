module Workspaces
  class QuizSessionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_workspace

    def create
      @quiz_session = @workspace.quiz_sessions.build(quiz_session_params)
      @quiz_session.user = current_user
      @quiz_session.started_at = Time.current

      if @quiz_session.save
        render json: { quiz_session: @quiz_session }, status: :created
      else
        render json: { errors: @quiz_session.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @quiz_session = @workspace.quiz_sessions.find(params[:id])
      
      unless @quiz_session.user == current_user
        return render json: { error: "Non autorisé" }, status: :forbidden
      end

      if @quiz_session.update(quiz_session_update_params)
        render json: { quiz_session: @quiz_session }
      else
        render json: { errors: @quiz_session.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_workspace
      @workspace = current_user.workspaces.find(params[:workspace_id])
    end

    def quiz_session_params
      params.require(:quiz_session).permit(
        :quiz_id,
        :quiz_mode,
        :session_type,
        :total_questions,
        { metadata: {} }
      )
    end

    def quiz_session_update_params
      params.require(:quiz_session).permit(
        :completed_at,
        :duration_seconds,
        :score,
        :accuracy_percentage,
        { metadata: {} },
        quiz_session_answers_attributes: [
          :question_id,
          :question_text,
          :question_type,
          :is_correct,
          :time_spent_seconds,
          :attempts_count,
          :explanation_shown,
          { user_answers: [] },
          { correct_answers: [] },
          { analytics_data: {} }
        ]
      )
    end
  end
end
