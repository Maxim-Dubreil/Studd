# frozen_string_literal: true
module Decoders
  class MindMapDecoder
    class SchemaError < StandardError; end

    REQUIRED_NODE_KEYS = %w[topic children].freeze

    # text : String (JSON sous forme de texte)
    # returns: Hash (la valeur de "mindmap")
    def self.call(text)
      raise SchemaError, "Réponse vide" if text.nil? || text.strip.empty?

      json = parse_json(text)
      mindmap = json['mindmap'] || json[:mindmap]
      raise SchemaError, "Clé racine 'mindmap' absente" unless mindmap.is_a?(Hash)

      missing = REQUIRED_NODE_KEYS - mindmap.keys
      raise SchemaError, "Champs manquants dans 'mindmap': #{missing.join(', ')}" if missing.any?

      mindmap
    end

    def self.parse_json(text)
      cleaned = text.strip
      # retire d'éventuelles fences ```
      if cleaned.start_with?('```')
        cleaned = cleaned.gsub(/\A```[a-zA-Z]*\s*|\s*```\z/, '')
      end
      JSON.parse(cleaned)
    rescue JSON::ParserError
      # fallback: tente la portion { ... } balance
      if (i = cleaned.index('{')) && (j = cleaned.rindex('}')) && j > i
        candidate = cleaned[i..j]
        return JSON.parse(candidate)
      end
      raise SchemaError, "JSON invalide"
    end
  end
end
