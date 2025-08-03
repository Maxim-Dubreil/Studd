require 'rails_helper'

RSpec.describe "RawContents", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/raw_contents/create"
      expect(response).to have_http_status(:success)
    end
  end

end
