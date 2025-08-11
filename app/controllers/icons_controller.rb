class IconsController < ApplicationController
  def index
    @icons = Icon.all
    render json: @icons
  end
end 