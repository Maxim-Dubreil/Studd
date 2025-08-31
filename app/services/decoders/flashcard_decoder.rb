# frozen_string_literal: true

module Decoders
  class FlashcardDecoder
    class DecodeError < StandardError; end

    VALID_DIFFICULTIES = %w[easy medium hard].freeze

    # Attend un Clients::AiClientResponses::Response
    def self.decode!(ai_response)
      unless ai_response.is_a?(Clients::AiClientResponses::Response)
        raise DecodeError, "Type de réponse inattendu (#{ai_response.class})."
      end

      # 1) Vérifs de surface (statut / texte vide)
      if ai_response.text.nil? || ai_response.text.strip.empty?
        msg = "Texte de sortie vide."
        msg << " Statut=#{ai_response.status}" if ai_response.status
        msg << " (incomplete_reason=#{ai_response.incomplete_reason})" if ai_response.incomplete_reason
        raise DecodeError, msg
      end

      # 2) Parse JSON
      data = JSON.parse(ai_response.text)
      flashcards = data["flashcards"]
      unless flashcards.is_a?(Array) && !flashcards.empty?
        raise DecodeError, 'Clé "flashcards" absente ou vide.'
      end

      # 3) Validation de chaque carte
      flashcards.each_with_index do |card, i|
        unless card.is_a?(Hash)
          raise DecodeError, "Carte ##{i + 1} n'est pas un objet."
        end

        q = card["question"]
        a = card["answer"]
        d = card["difficulty"]
        t = card["tags"]

        raise DecodeError, "Carte ##{i + 1} : 'question' manquante ou vide." unless q.is_a?(String) && !q.strip.empty?
        raise DecodeError, "Carte ##{i + 1} : 'answer' manquante ou vide."   unless a.is_a?(String) && !a.strip.empty?
        raise DecodeError, "Carte ##{i + 1} : 'difficulty' invalide (#{d.inspect})." unless VALID_DIFFICULTIES.include?(d)
        raise DecodeError, "Carte ##{i + 1} : 'tags' doit être un tableau (1..3)." unless t.is_a?(Array) && t.size.between?(1, 3)
        unless t.all? { |s| s.is_a?(String) && !s.strip.empty? }
          raise DecodeError, "Carte ##{i + 1} : 'tags' contient des éléments invalides."
        end
      end

      flashcards # renvoie le tableau brut validé, le mapping UI se fait dans le generator
    rescue JSON::ParserError => e
      excerpt = ai_response.text.to_s[0, 600]
      raise DecodeError, "JSON invalide: #{e.message}\n--- extrait ---\n#{excerpt}"
    end
  end
end
