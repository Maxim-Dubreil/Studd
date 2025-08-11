require 'rails_helper'

RSpec.describe "Icons", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/icons/index"
      expect(response).to have_http_status(:success)
    end
  end

end
