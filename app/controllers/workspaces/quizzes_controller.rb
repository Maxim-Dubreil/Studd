module Workspaces
  class QuizzesController < ApplicationController
    before_action :set_workspace
    before_action :set_quiz, only: %i[show destroy]
    before_action :set_content, only: %i[create]

    def show
    end

    def create
      if @raw_content_text.blank?
        return render json: { error: "Aucun contenu trouvé pour ce workspace" }, status: :unprocessable_entity
      end

      # Suppression des anciens quiz
      @workspace.quizzes.destroy_all

      # Génération du contenu du quiz sans titre spécifié (l'IA va générer un titre pertinent)
      quiz_content = Generators::QuizGenerator.new(@raw_content_text).call

      # Utilisation du titre et de la description générés par l'IA
      @quiz = @workspace.quizzes.build(
        title: quiz_content["title"],
        description: quiz_content["description"],
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
          format.html { redirect_to workspace_path(@workspace), notice: 'Quiz supprimé avec succès.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to workspace_path(@workspace), alert: 'Erreur lors de la suppression.' }
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

    def set_quiz
      @quiz = @workspace.quizzes.order(created_at: :desc).first

      unless @quiz
        respond_to do |format|
          format.html
          format.json do
            render json: { error: "Aucun quiz disponible" },
                  status: :not_found
          end
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
