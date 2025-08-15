# frozen_string_literal: true

module Generators
  class MindMapOrchestrator
    def initialize(content)
      @content = content
    end

    def call
      outline = Generators::OutlineGenerator.new(@content).call
      Generators::MindMapRenderer.new(outline, root_title: "Mind-map").call
    end
  end
end
