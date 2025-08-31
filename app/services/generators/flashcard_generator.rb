# frozen_string_literal: true

module Generators
  class FlashcardGenerator
    PASTEL_PALETTE = %w[
      #FFFACD #FFDCF4 #FFEBCF #D4EBF2 #CDEFD9 #D9C4FF
      #AEDFF7 #E6F7E6 #F6D6FF #FFEDB8 #F9B4AC
    ].freeze

    def initialize(content, count = 10)
      @content          = content
      @count            = count
      @shuffled_colors  = PASTEL_PALETTE.shuffle
    end

    def call
      payload = PromptBuilder::Flashcard
        .new(raw_content: @content, count: @count)
        .request_payload

      ai_response = Clients::AiClientResponses.new(payload: payload).call

      # Décodage + validation métier
      flashcards = Decoders::FlashcardDecoder.decode!(ai_response)

      # Mapping UI
      idx = 0
      flashcards.map do |card|
        {
          id:         (idx += 1),
          term:       plain_text(card["question"]),  # court et sans HTML
          definition: sanitize(card["answer"]),      # HTML autorisé (whitelist)
          color:      @shuffled_colors[(idx - 1) % @shuffled_colors.size]
        }
      end
    rescue Decoders::FlashcardDecoder::DecodeError => e
      # On ajoute du contexte utile si la réponse était incomplète
      raise "Erreur de décodage des flashcards : #{e.message}"
    rescue Clients::AiClientResponses::OpenAIError => e
      raise "Erreur API : #{e.message}"
    end

    private

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------
    def sanitize(html)
      ActionController::Base.helpers.sanitize(
        html.to_s,
        tags: %w[p br ul ol li strong em a code pre],
        attributes: %w[href title]
      )
    end

    def plain_text(html)
      ActionView::Base.full_sanitizer.sanitize(sanitize(html)).strip
    end
  end
end
