# app/decoders/quiz.rb
# frozen_string_literal: true

require "json"

module Decoders
  class QuizDecoder
    class DecodeError < StandardError; end

    # response : Clients::AiClientResponses::Response
    #   - response.text contient l'objet JSON (agrégé) attendu
    def self.decode(response)
      text = response&.text
      raise DecodeError, "Texte manquant dans la réponse" if text.nil? || text.strip.empty?

      data = JSON.parse(text)

      # Validations racine
      %w[quizId title description questions].each do |k|
        raise DecodeError, "Clé racine manquante : '#{k}'" unless data.key?(k)
      end

      questions = data["questions"]
      unless questions.is_a?(Array) && questions.any?
        raise DecodeError, "'questions' doit être un tableau non vide"
      end

      # Validations questions
      questions.each_with_index do |q, i|
        human = "Question #{i + 1}"

        %w[id type question correctAnswers explanation].each do |k|
          raise DecodeError, "#{human} : clé manquante '#{k}'" unless q.key?(k)
        end

        type = q["type"]
        unless %w[multiple_choice true_false].include?(type)
          raise DecodeError, "#{human} : type invalide '#{type}'"
        end

        ca = q["correctAnswers"]
        unless ca.is_a?(Array) && ca.size == 1
          raise DecodeError, "#{human} : 'correctAnswers' doit contenir exactement 1 élément"
        end

        if type == "multiple_choice"
          opts = q["options"]
          unless opts.is_a?(Array) && opts.size.between?(3, 4)
            raise DecodeError, "#{human} : 'options' doit contenir 3 à 4 choix"
          end

          letters = %w[a b c d]
          ids = opts.map { |o| o["id"] }
          unless ids.all? { |id| letters.include?(id) } && ids.uniq.size == ids.size
            raise DecodeError, "#{human} : IDs d'options invalides ou dupliqués (attendus : a,b,c,d)"
          end

          unless letters.include?(ca.first)
            raise DecodeError, "#{human} : 'correctAnswers' doit être une lettre parmi a–d"
          end
        else # true_false
          unless %w[true false].include?(ca.first)
            raise DecodeError, "#{human} : 'correctAnswers' doit être 'true' ou 'false'"
          end
          if q.key?("options") && !q["options"].nil? && !Array(q["options"]).empty?
            raise DecodeError, "#{human} : 'options' ne doit pas être présent pour 'true_false'"
          end
        end
      end

      data
    rescue JSON::ParserError => e
      raise DecodeError, "JSON invalide : #{e.message}\n--- output_text ---\n#{response&.text}"
    end
  end
end
