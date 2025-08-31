require 'rails_helper'

RSpec.describe IconsHelper, type: :helper do
  describe 'module definition' do
    it 'is defined as a module' do
      expect(IconsHelper).to be_a(Module)
    end

    it 'can be included in a class' do
      test_class = Class.new do
        include IconsHelper
      end
      expect(test_class.new).to be_a_kind_of(IconsHelper)
    end
  end
end
