# app/controllers/workspaces_controller.rb
class WorkspacesController < ApplicationController

    before_action :set_workspace, only: [:show, :edit, :update, :destroy]

    def index
        @workspaces = current_user.workspaces
    end

    def show
    end

    def new
        @workspace = current_user.workspaces.build
    end

    def create
        @workspace = current_user.workspaces.build(workspace_params)
        if @workspace.save
            redirect_to @workspace, notice: 'Workspace was successfully created.'
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @workspace.update(workspace_params)
            redirect_to @workspace, notice: 'Workspace was successfully updated.'
        else
            render :edit
        end
    end

    def destroy
        @workspace.destroy
        redirect_to workspaces_url, notice: 'Workspace was successfully destroyed.'
    end

    private

    def set_workspace
        @workspace = current_user.workspaces.find(params[:id])
    end

    def workspace_params
      params.require(:workspace).permit(:name, :icon)
    end
end