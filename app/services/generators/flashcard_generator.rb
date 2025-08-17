module Generators
  class FlashcardGenerator
    PASTEL_PALETTE = %w[
      #FFFACD #FFDCF4 #FFEBCF #D4EBF2 #CDEFD9 #D9C4FF
      #AEDFF7 #E6F7E6 #F6D6FF #FFEDB8 #F9B4AC
    ].freeze

    def initialize(content)
      @content = content
      @shuffled_colors = PASTEL_PALETTE.shuffle
    end

    def call
      prompt       = PromptBuilder::Flashcard.new(@content).build
      raw_response = Clients::AiClient.new(prompt: prompt).call
      parse_response(raw_response)
    end

    private

    def parse_response(raw)
      flashcards = JSON.parse(raw).fetch('flashcards')

      idx = 0
      flashcards.map do |card|
        {
          id:         (idx += 1),                     # 1, 2, 3 …
          term:       plain_text(card['question']),   # libellé court
          definition: sanitize(card['answer']),       # HTML safe
          color:      @shuffled_colors[(idx - 1) % @shuffled_colors.size]
        }
      end
    rescue JSON::ParserError => e
      raise "Réponse OpenAI invalide : #{e.message}\n--- Contenu reçu ---\n#{raw}"
    end

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------
    def sanitize(html)
      ActionController::Base.helpers.sanitize(
        html.to_s,
        tags: %w[p br ul ol li strong em]
      )
    end

    def plain_text(html)
      # On enlève toutes les balises pour n'avoir qu'une ligne « term »
      ActionView::Base.full_sanitizer.sanitize(sanitize(html)).strip
    end
  end
end
