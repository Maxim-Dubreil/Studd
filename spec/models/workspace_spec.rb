# == Schema Information
#
# Table name: workspaces
#
#  id         :integer          not null, primary key
#  name       :string
#  icon       :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  icon_id    :integer
#
# Indexes
#
#  index_workspaces_on_icon_id  (icon_id)
#  index_workspaces_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Workspace, type: :model do
  describe 'model definition' do
    it 'has the correct class name' do
      expect(Workspace.name).to eq('Workspace')
    end

    it 'inherits from ApplicationRecord' do
      expect(Workspace.superclass.name).to eq('ApplicationRecord')
    end
  end

  describe 'constants and methods' do
    it 'responds to name attribute' do
      expect(Workspace.new).to respond_to(:name)
    end

    it 'responds to user_id attribute' do
      expect(Workspace.new).to respond_to(:user_id)
    end

    it 'responds to icon_id attribute' do
      expect(Workspace.new).to respond_to(:icon_id)
    end
  end
end
