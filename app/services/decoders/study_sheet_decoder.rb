# frozen_string_literal: true

module Decoders
  class StudySheetDecoder
    class DecodeError < StandardError; end

    REQUIRED_ROOT_KEYS = %w[title summary sections key_points].freeze
    REQUIRED_SECTION_KEYS = %w[title content subsections].freeze
    REQUIRED_SUBSECTION_KEYS = %w[subtitle points].freeze

      def self.decode!(ai_response)
    new(ai_response).decode!
  end

  def initialize(ai_response)
    @ai_response = ai_response
  end

  def decode!
    unless @ai_response.is_a?(Clients::AiClientResponses::Response)
      raise DecodeError, "Type de réponse inattendu (#{@ai_response.class})."
    end

    if @ai_response.text.nil? || @ai_response.text.strip.empty?
      msg = "Texte de sortie vide."
      msg << " Statut=#{@ai_response.status}" if @ai_response.status
      msg << " (incomplete_reason=#{@ai_response.incomplete_reason})" if @ai_response.incomplete_reason
      raise DecodeError, msg
    end

    parsed_data = parse_json!
    validate_structure!(parsed_data)
    parsed_data
  rescue JSON::ParserError => e
    raise DecodeError, "JSON invalide : #{e.message}"
  rescue StandardError => e
    raise DecodeError, "Erreur de décodage : #{e.message}"
  end

  private

  def parse_json!
    JSON.parse(@ai_response.text)
  end

    def validate_structure!(data)
      missing_keys = REQUIRED_ROOT_KEYS - data.keys
      if missing_keys.any?
        raise DecodeError, "Clés manquantes dans la réponse : #{missing_keys.join(', ')}"
      end

      raise DecodeError, "Le titre ne peut pas être vide" if data["title"].to_s.strip.empty?
      raise DecodeError, "Le résumé ne peut pas être vide" if data["summary"].to_s.strip.empty?

      sections = data["sections"]
      raise DecodeError, "Les sections doivent être un tableau" unless sections.is_a?(Array)
      raise DecodeError, "Il doit y avoir au moins 2 sections" if sections.size < 2

      sections.each_with_index do |section, idx|
        validate_section!(section, idx)
      end

      key_points = data["key_points"]
      raise DecodeError, "Les points clés doivent être un tableau" unless key_points.is_a?(Array)
      raise DecodeError, "Il doit y avoir au moins 3 points clés" if key_points.size < 3
    end

    def validate_section!(section, index)
      unless section.is_a?(Hash)
        raise DecodeError, "La section #{index + 1} doit être un objet"
      end

      missing_keys = REQUIRED_SECTION_KEYS - section.keys
      if missing_keys.any?
        raise DecodeError, "Section #{index + 1} : clés manquantes #{missing_keys.join(', ')}"
      end

      if section["title"].to_s.strip.empty?
        raise DecodeError, "Section #{index + 1} : le titre ne peut pas être vide"
      end

      if section["content"].to_s.strip.empty?
        raise DecodeError, "Section #{index + 1} : le contenu ne peut pas être vide"
      end

      subsections = section["subsections"]
      unless subsections.is_a?(Array)
        raise DecodeError, "Section #{index + 1} : les sous-sections doivent être un tableau"
      end

      subsections.each_with_index do |subsection, sub_idx|
        validate_subsection!(subsection, index, sub_idx)
      end
    end

    def validate_subsection!(subsection, section_idx, subsection_idx)
      unless subsection.is_a?(Hash)
        raise DecodeError, "Section #{section_idx + 1}, sous-section #{subsection_idx + 1} doit être un objet"
      end

      missing_keys = REQUIRED_SUBSECTION_KEYS - subsection.keys
      if missing_keys.any?
        raise DecodeError, "Section #{section_idx + 1}, sous-section #{subsection_idx + 1} : clés manquantes #{missing_keys.join(', ')}"
      end

      points = subsection["points"]
      unless points.is_a?(Array) && points.size > 0
        raise DecodeError, "Section #{section_idx + 1}, sous-section #{subsection_idx + 1} : doit avoir au moins un point"
      end
    end
  end
end
