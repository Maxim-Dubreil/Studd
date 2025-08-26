module Workspaces
  class FlashcardsController < ::ApplicationController
    include ContentExtractable
    
    before_action :set_workspace
    before_action :set_flash_cards_set, only: %i[show destroy]
    before_action :get_flash_card_sets, only: %i[new]

    def index

      @flash_cards_sets = @workspace.flash_cards_sets.order(created_at: :desc)
    end

    def new

    end

    def show

    end

      def create
    content_text = extract_workspace_content
    return unless content_text

    flashcards = Generators::FlashcardGenerator.new(content_text).call

      @flash_cards_set = @workspace.flash_cards_sets.build(
        name: params[:name].presence || 'Nouveau set',
        content: flashcards
      )

      if @flash_cards_set.save
        render json: { flash_cards_set: @flash_cards_set }, status: :created
      else
        render json: { errors: @flash_cards_set.errors.full_messages },
              status: :unprocessable_entity
      end
    end

    def destroy
      if @flash_cards_set.destroy
        respond_to do |format|
          format.html { redirect_to workspace_flashcards_path(@workspace), notice: 'Collection supprimée avec succès.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to workspace_flashcards_path(@workspace), alert: 'Erreur lors de la suppression.' }
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

    def get_flash_card_sets
      @flash_cards_sets = @workspace.flash_cards_sets.order(created_at: :desc)
    end

    def set_flash_cards_set
      @flash_cards_set = @workspace.flash_cards_sets.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      respond_to do |format|
        format.html do
          redirect_to tools_workspace_flashcards_path(@workspace),
                      alert: 'Jeu de cartes introuvable.'
        end
        format.json do
          render json: { error: "Flashcards introuvables : #{e.message}" },
                status: :not_found
        end
      end
    end
  end
end