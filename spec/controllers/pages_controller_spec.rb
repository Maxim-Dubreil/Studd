require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #landing_page' do
    context 'when user is not logged in' do
      it 'returns http success' do
        get :landing_page
        expect(response).to have_http_status(:success)
      end

      it 'renders the landing_page template' do
        get :landing_page
        expect(response).to render_template(:landing_page)
      end
    end

    context 'when user is logged in' do
      before do
        user = double('User')
        allow(controller).to receive(:user_signed_in?).and_return(true)
        allow(controller).to receive(:dashboard_path).and_return('/dashboard')
      end

      it 'redirects to dashboard' do
        get :landing_page
        expect(response).to redirect_to('/dashboard')
      end
    end
  end

  describe 'GET #about' do
    it 'returns http success' do
      get :about
      expect(response).to have_http_status(:success)
    end

    it 'renders the about template' do
      get :about
      expect(response).to render_template(:about)
    end

    it 'sets the page title' do
      get :about
      expect(assigns(:page_title)).to eq('À propos')
    end
  end

  describe 'controller definition' do
    it 'inherits from ApplicationController' do
      expect(PagesController.superclass.name).to eq('ApplicationController')
    end

    it 'responds to landing_page action' do
      expect(controller).to respond_to(:landing_page)
    end

    it 'responds to about action' do
      expect(controller).to respond_to(:about)
    end
  end
end
