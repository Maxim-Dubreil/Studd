# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing_page, :about, :profil_page]
  before_action :redirect_if_logged_in, only: [:landing_page]
  
  def landing_page
  end

  def about
    @page_title = 'À propos'
  end

  private

  def redirect_if_logged_in
    redirect_to dashboard_path if user_signed_in?
  end
end