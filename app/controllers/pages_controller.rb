class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing_page, :contact, :docs]
  before_action :redirect_if_logged_in, only: [:landing_page]
  before_action :build_nav_props

  def landing_page; end

  def contact
    @page_title = 'Contact'
  end

  def docs
    @page_title = 'Documentation'
  end

  private

  def redirect_if_logged_in
    redirect_to dashboard_path if user_signed_in?
  end

  def build_nav_props
    left = [
      { label: 'Docs',     url: docs_path },
      { label: 'Contact',  url: contact_path }
    ]
    center = [
      { label: 'Dashboard', url: '#dashboard' },
      { label: 'Workspace', url: '#workspace' }
    ]
    right  =
      if user_signed_in?
        [
          { label: 'Dashboard',  url: dashboard_path, variant: 'gradient' },
          { label: 'Déconnexion', url: logout_path,    variant: 'outline',
            data: { 'data-turbo-method': :delete } }
        ]
      else
        [
          { label: 'Sign Up', url: signup_path, variant: 'gradient' },
          { label: 'Sign In', url: login_path,  variant: 'outline'  }
        ]
      end

    @nav_props = { left:, center:, right: }
  end
end
