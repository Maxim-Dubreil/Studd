module Workspaces
  class QuizzesController < ApplicationController
    before_action :set_workspace
    before_action :set_quiz, only: %i[show destroy]
    before_action :get_quizzes, only: %i[new]
    before_action :set_content, only: %i[create]

    def index
      @quizzes = @workspace.quizzes.order(created_at: :desc)
    end

    def new
    end

    def show
    end

    def create
      if @raw_content_text.blank?
        return render json: { error: "Aucun contenu trouvé pour ce workspace" }, status: :unprocessable_entity
      end

      quiz_content = Generators::QuizGenerator.new(@raw_content_text, title: params[:title]).call

      @quiz = @workspace.quizzes.build(
        title: params[:title].presence || 'Nouveau quiz',
        description: params[:description].presence || 'Quiz généré automatiquement',
        content: quiz_content
      )

      if @quiz.save
        render json: { quiz: @quiz }, status: :created
      else
        render json: { errors: @quiz.errors.full_messages },
              status: :unprocessable_entity
      end
    end

    def destroy
      if @quiz.destroy
        respond_to do |format|
          format.html { redirect_to workspace_quizzes_path(@workspace), notice: 'Quiz supprimé avec succès.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to workspace_quizzes_path(@workspace), alert: 'Erreur lors de la suppression.' }
          format.json { render json: { error: 'Erreur lors de la suppression' }, status: :unprocessable_entity }
        end
      end
    end

    private

    def workspace_params
      params.permit(:workspace_id)
    end

    def set_workspace
      @workspace = Workspace.find(params[:workspace_id])
    end

    def get_quizzes
      @quizzes = @workspace.quizzes.order(created_at: :desc)
    end

    def set_quiz
      @quiz = @workspace.quizzes.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      respond_to do |format|
        format.html do
          redirect_to workspace_quizzes_path(@workspace),
                      alert: 'Quiz introuvable.'
        end
        format.json do
          render json: { error: "Quiz introuvable : #{e.message}" },
                status: :not_found
        end
      end
    end

    def set_content
      if @workspace.raw_content&.content.present?
        @raw_content_text = @workspace.raw_content.content
      else
        @raw_content_text = ""
      end
    end
  end
end
