require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'devise modules' do
    it 'includes database_authenticatable module' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable module' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable module' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable module' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable module' do
      expect(User.devise_modules).to include(:validatable)
    end
  end

  describe 'model definition' do
    it 'has the correct class name' do
      expect(User.name).to eq('User')
    end

    it 'inherits from ApplicationRecord' do
      expect(User.superclass.name).to eq('ApplicationRecord')
    end
  end
end
