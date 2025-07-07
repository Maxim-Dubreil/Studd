# app/controllers/pages_controller.rb
class PagesController < ApplicationController

  def landing_page

    @hide_sidebar = true
    @hide_navbar = true
  end

  def about
    @page_title = 'À propos'
  end
end