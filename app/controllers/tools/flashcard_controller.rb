module Api::V1
  class FlashcardsController < ApplicationController
    def create
      # 1. Validation
      workspace = Workspace.find(params[:workspace_id])

      # 2. Appel du service
      flashcards = FlashcardGenerator.new(workspace.content).call

      # 3. Réponse
      render json: { flashcards: flashcards }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Workspace introuvable" }, status: :not_found
    rescue => e
      render json: { error: "Échec de génération : #{e.message}" }, status: :unprocessable_entity
    end
  end
end