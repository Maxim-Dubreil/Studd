require 'rails_helper'

RSpec.describe VueComponentHelper, type: :helper do
  describe '#vue_component' do
    it 'generates a div with vue component data attributes' do
      result = helper.vue_component('TestComponent', { name: 'test' })
      expect(result).to include('data-vue-component="TestComponent"')
      expect(result).to include('data-vue-props="{&quot;name&quot;:&quot;test&quot;}"')
    end

    it 'accepts additional HTML options' do
      result = helper.vue_component('TestComponent', {}, class: 'my-class', id: 'my-id')
      expect(result).to include('class="my-class"')
      expect(result).to include('id="my-id"')
    end

    it 'works with empty props' do
      result = helper.vue_component('TestComponent')
      expect(result).to include('data-vue-component="TestComponent"')
      expect(result).to include('data-vue-props="{}"')
    end

    it 'creates an empty div tag' do
      result = helper.vue_component('TestComponent')
      expect(result).to match(/<div[^>]*><\/div>/)
    end
  end
end
