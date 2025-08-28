module Generators
  class QuizGenerator
    def initialize(content, title: "Quiz")
      @content = content
      @title = title
    end

    def call
      prompt = PromptBuilder::Quiz.new(@content, title: @title).build
      raw_response = Clients::AiClient.new(prompt: prompt).call
      parse_response(raw_response)
    end

    private

    def parse_response(raw)
      JSON.parse(raw)
    rescue JSON::ParserError => e
      raise "Réponse OpenAI invalide : #{e.message}\n--- Contenu reçu ---\n#{raw}"
    end
  end
end