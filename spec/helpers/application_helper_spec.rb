require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#resource_name' do
    it 'returns :user' do
      expect(helper.resource_name).to eq(:user)
    end
  end

  describe 'helper methods' do
    it 'responds to resource method' do
      expect(helper).to respond_to(:resource)
    end

    it 'responds to devise_mapping method' do
      expect(helper).to respond_to(:devise_mapping)
    end
  end
end
