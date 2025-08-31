module Workspaces
  class StudySheetsController < ::ApplicationController
    include ContentExtractable
    
    before_action :set_workspace
    before_action :set_study_sheets_set, only: %i[show destroy]
    before_action :get_study_sheets_sets, only: %i[new]

    def index
      @study_sheets_sets = @workspace.study_sheets_sets.order(created_at: :desc)
    end

    def new
    end

    def show
    end

    def create
      content_text = extract_workspace_content
      return unless content_text

      @study_sheets_set = @workspace.study_sheets_sets.build(
        name: params[:name].presence || 'Nouvelle fiche de révision',
        content: []
      )

      if @study_sheets_set.save
        study_sheet_content = Generators::StudySheetGenerator.new(content_text).call
        @study_sheets_set.update(content: study_sheet_content)
        
        render json: { study_sheet: @study_sheets_set.content }, status: :created
      else
        render json: { errors: @study_sheets_set.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    def destroy
      if @study_sheets_set.destroy
        respond_to do |format|
          format.html { redirect_to workspace_study_sheets_path(@workspace), notice: 'Fiche de révision supprimée avec succès.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to workspace_study_sheets_path(@workspace), alert: 'Erreur lors de la suppression.' }
          format.json { render json: { error: 'Erreur lors de la suppression' }, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_workspace
      @workspace = Workspace.find(params[:workspace_id])
    end

    def get_study_sheets_sets
      @study_sheets_sets = @workspace.study_sheets_sets.order(created_at: :desc)
    end

    def set_study_sheets_set
      @study_sheets_set = @workspace.study_sheets_sets.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      respond_to do |format|
        format.html do
          redirect_to workspace_study_sheets_path(@workspace),
                      alert: 'Fiche de révision introuvable.'
        end
        format.json do
          render json: { error: "Fiche de révision introuvable : #{e.message}" },
                status: :not_found
        end
      end
    end
  end
end
