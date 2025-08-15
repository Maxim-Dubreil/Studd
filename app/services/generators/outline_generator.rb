# frozen_string_literal: true

module Generators
  class OutlineGenerator
    def initialize(content)
      @content = content
    end

    def call
      payload = PromptBuilder::Outline.new(@content).request_payload
      raw     = Clients::AiClientResponses.new(payload: payload).call

      outline = raw.is_a?(Hash) ? raw : JSON.parse(raw.to_s)
      validate_outline!(outline)
      outline
    end

    private

    def validate_outline!(outline)
      chapters = Array(outline["chapters"])
      raise "Outline invalide: chapters manquant" if chapters.empty?

      chapters.each do |ch|
        title   = ch["title"].to_s.strip
        notions = Array(ch["notions"])
        raise "Chapitre sans titre" if title.empty?
        raise "Moins de 2 notions dans #{title}" if notions.size < 2
      end
    end
  end
end
