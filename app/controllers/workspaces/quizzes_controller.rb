module Workspaces
  class QuizzesController < ApplicationController
    before_action :set_workspace

    def index
    end

    def show
    end

    private

    def set_workspace
      @workspace = Workspace.find(params[:workspace_id])
    end
  end
end
