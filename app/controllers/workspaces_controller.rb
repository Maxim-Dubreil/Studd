# app/controllers/workspaces_controller.rb
class WorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace, only: [:show, :update, :destroy]

  def index
    @workspaces = current_user.workspaces
    @user = current_user
  end

  def show
    @workspace = current_user.workspaces.find(params[:id])

  end

  def create
    @workspace = current_user.workspaces.build(workspace_params)
    if @workspace.save
            render json: @workspace.to_json(include: [:icon, { raw_content: { methods: [:content_type, :file_name, :file_url] } }]), status: :created
    else
      render json: @workspace.errors, status: :unprocessable_entity
    end
  end

  def update
    if @workspace.update(workspace_params)
      render json: @workspace.to_json(include: [:icon, { raw_content: { methods: [:content_type, :file_name, :file_url] } }])
    else
      render json: @workspace.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @workspace.destroy
    head :no_content
  end

  private

  def set_workspace
    @workspace = current_user.workspaces.find(params[:id])
  end

  def workspace_params
    params.require(:workspace).permit(:name, :icon_id)
  end
end