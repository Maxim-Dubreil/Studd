module Workspaces
  class MindmapsController < ApplicationController
    before_action :set_workspace
    before_action :set_mindmap, only: [:show, :destroy]
    before_action :set_content, only: [:create]

    def show
      @hide_navbar = true
      @hide_sidebar = true
    end

    def create

      if @raw_content_text.blank?
        return render json: { error: "Aucun contenu trouvé pour ce workspace" }, status: :unprocessable_entity
      end

      mindmap_data = Generators::MindMapGenerator.new(@raw_content_text).call

      # Création de l'enregistrement en base de données
      @mindmapContent = @workspace.mindmaps.create!(
        name: @workspace.name,
        content: mindmap_data
      )

      if @mindmapContent.save
        render json: { mindmap: @mindmapContent }, status: :created
      else
        render json: { errors: @mindmapContent.errors.full_messages },
              status: :unprocessable_entity
      end
    end

    def destroy
      # 1. Récupère la dernière mind-map du workspace
      last_map = @workspace.mindmaps.order(id: :desc).first

      if last_map
        last_map.destroy
        respond_to do |format|
          format.html { redirect_to workspace_path(@workspace), notice: 'Dernière mind-map supprimée.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to workspace_path(@workspace), alert: 'Aucune mind-map à supprimer.' }
          format.json { render json: { error: 'Mindmap introuvable' }, status: :not_found }
        end
      end
    end

    private

    def set_workspace
      @workspace = Workspace.find(params[:workspace_id])
    end

    def set_mindmap
      @mindmap = @workspace.mindmaps.order(id: :desc).first
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