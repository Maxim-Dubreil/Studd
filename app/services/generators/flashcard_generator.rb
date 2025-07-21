module Generators
    class FlashcardGenerator
        def initialize(content)
            @content = content
        end

        def call
            prompt = PromptBuilder::Flashcard.new(@content).build
            raw_response = AiClient.new(prompt: prompt).call
            parse_response(raw_response)
        end

        private

        def parse_response(raw)
            flashcards = JSON.parse(raw)["flashcards"]

            flashcards.map do |card|
                {
                id:         "fc_#{SecureRandom.hex(4)}",
                question:   sanitize(card["question"]),
                answer:     sanitize(card["answer"]),
                difficulty: card["difficulty"] || "medium",
                tags:       Array(card["tags"]).first(3)
                }
            end
        rescue JSON::ParserError => e
            raise "Réponse OpenAI invalide : #{e.message}\n--- Contenu reçu ---\n#{raw}"
        end

        def sanitize(text)
            ActionController::Base.helpers.sanitize(text.to_s, tags: %w(p br ul ol li strong em))
        end
    end
end