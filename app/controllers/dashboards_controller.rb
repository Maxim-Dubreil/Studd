class DashboardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = current_user
    @hide_navbar = true
    @hide_sidebar = true
    @dashboard_fullscreen = true
  end
end
