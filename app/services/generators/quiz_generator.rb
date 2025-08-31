# app/generators/quiz_generator.rb
# frozen_string_literal: true

module Generators
  class QuizGenerator
    def initialize(raw_content, title: "Quiz")
      @raw_content = raw_content
      @title       = title
    end

    def call
      payload = PromptBuilder::Quiz
                  .new(raw_content: @raw_content, title: @title)
                  .request_payload

      response = Clients::AiClientResponses.new(payload: payload).call

      # Garde-fou utile : si l'API signale une réponse incomplète, on lève une erreur claire
      if response.status == "incomplete"
        reason = response.incomplete_reason || "raison inconnue"
        raise "Réponse IA incomplète (#{reason}). Augmente max_output_tokens ou re-tente."
      end

      Decoders::QuizDecoder.decode(response)
    rescue Clients::AiClientResponses::OpenAIError => e
      raise "Erreur lors de l'appel OpenAI : #{e.message}"
    rescue Decoders::QuizDecoder::DecodeError => e
      raise "Réponse IA invalide : #{e.message}"
    rescue StandardError => e
      raise "Erreur inattendue lors de la génération : #{e.message}"
    end
  end
end
