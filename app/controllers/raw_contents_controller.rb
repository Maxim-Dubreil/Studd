class RawContentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @workspace = current_user.workspaces.find(params[:workspace_id])
    @raw_content = @workspace.build_raw_content(raw_content_params)

    if @raw_content.save
      render json: @raw_content.to_json(methods: [:content_type, :file_name]), status: :created
    else
      render json: @raw_content.errors, status: :unprocessable_entity
    end
  end

  def update
    @raw_content = RawContent.find(params[:id])
    authorize_user_for_workspace(@raw_content.workspace)

    if @raw_content.update(raw_content_params)
      render json: @raw_content.to_json(methods: [:content_type, :file_name]), status: :ok
    else
      render json: @raw_content.errors, status: :unprocessable_entity
    end
  end

  private

  def authorize_user_for_workspace(workspace)
    unless workspace.user == current_user
      render json: { error: "Not Authorized" }, status: :unauthorized
    end
  end
  
  def raw_content_params
    params.require(:raw_content).permit(:content, :file)
  end
end
