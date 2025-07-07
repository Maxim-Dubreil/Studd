# app/controllers/pages_controller.rb
class PagesController < ApplicationController

  def landing_page
    # Landing page avec layout spécial (sans shared components)
  end

  def about
    @page_title = 'À propos'
  end
end