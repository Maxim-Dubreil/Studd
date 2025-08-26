class RawContentsController < ApplicationController
  before_action :authenticate_user!

  def show
    @raw_content = RawContent.find(params[:id])
    authorize_user_for_workspace(@raw_content.workspace)
    if @raw_content.file.attached?
      redirect_to @raw_content.file.url, allow_other_host: true
    else
      render json: { content: @raw_content.content, content_type: @raw_content.content_type }
    end
  end

  def create
    @workspace = current_user.workspaces.find(params[:workspace_id])
    @raw_content = @workspace.raw_content || @workspace.build_raw_content
    handle_content_type_change
    if @raw_content.update(raw_content_params)
      render json: @raw_content.to_json(methods: [:content_type, :file_name, :file_url]), status: :ok
    else
      render json: @raw_content.errors, status: :unprocessable_entity
    end
  end

  def update
    @raw_content = RawContent.find(params[:id])
    authorize_user_for_workspace(@raw_content.workspace)

    handle_content_type_change

    if @raw_content.update(raw_content_params)
      render json: @raw_content.to_json(methods: [:content_type, :file_name, :file_url]), status: :ok
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

  def handle_content_type_change
    file_param = params[:raw_content][:file] if params[:raw_content]
    content_param = params[:raw_content][:content] if params[:raw_content]

    if content_param.present? && file_param.blank? && @raw_content.file.attached?
      @raw_content.file.purge
    end
  end

  def raw_content_params
    params.require(:raw_content).permit(:content, :file).tap do |whitelisted|
      if whitelisted[:file].present?
        whitelisted[:content] = nil
      end
    end
  end
end
