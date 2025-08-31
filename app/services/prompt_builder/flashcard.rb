# frozen_string_literal: true
require "json"

module PromptBuilder
  class Flashcard
    SYSTEM_PROMPT = <<~PROMPT
      Tu es un expert en création de flash-cards pédagogiques.
      Tes réponses doivent être prêtes à être parsées par un programme :
      — pas de texte d’introduction ou de conclusion
      — pas de Markdown ni de balises
      — un seul objet JSON strict (UTF-8) conforme au schéma demandé
    PROMPT

    # Schéma strict de sortie pour les flashcards
    # - Racine: { "flashcards": [Flashcard, ...] }
    # - Flashcard: { question, answer, difficulty, tags[] }
    JSON_SCHEMA = {
      "name"   => "flashcards",
      "strict" => true,
      "schema" => {
        "type"                 => "object",
        "additionalProperties" => false,
        "required"             => ["flashcards"],
        "properties"           => {
          "flashcards" => {
            "type"  => "array",
            # minItems/maxItems seront fixés dynamiquement dans request_payload pour matcher @count
            "items" => {
              "type"                 => "object",
              "additionalProperties" => false,
              "required"             => ["question", "answer", "difficulty", "tags"],
              "properties"           => {
                "question"   => { "type" => "string", "minLength" => 1 },
                "answer"     => { "type" => "string", "minLength" => 1 },
                "difficulty" => { "type" => "string", "enum" => ["easy", "medium", "hard"] },
                "tags"       => {
                  "type"      => "array",
                  "minItems"  => 1,
                  "maxItems"  => 3,
                  "items"     => {
                    "type"      => "string",
                    "minLength" => 1,
                    "maxLength" => 32
                    # (on évite ici un pattern exotique qui peut casser selon l'engine JSON Schema)
                  }
                }
              }
            }
          }
        }
      }
    }.freeze

    EXAMPLE_JSON = <<~JSON.chomp
      {
        "flashcards": [
          {
            "question": "Quel événement déclenche la Révolution française ?",
            "answer": "La prise de la Bastille le 14 juillet 1789.",
            "difficulty": "easy",
            "tags": ["Révolution", "Dates"]
          }
        ]
      }
    JSON

    DEFAULT_MODEL = ENV.fetch("OPENAI_FLASHCARDS_MODEL", "gpt-4o-2024-08-06")

    def initialize(raw_content:, count: 10)
      @raw_content = raw_content
      @count       = count
    end

    # Même signature/structure que Mindmap#request_payload
    def request_payload(model: DEFAULT_MODEL,
                        temperature: 0.2,
                        max_output_tokens: 4_000)

      prompt_text = <<~CONTENT
        Génère **exactement #{@count}** flash-cards à partir du contenu fourni.

        Contraintes :
          • Clé racine obligatoire : "flashcards".
          • Chaque carte contient : "question", "answer", "difficulty", "tags".
          • "difficulty" ∈ { "easy", "medium", "hard" }.
          • "tags" : tableau de 1 à 3 éléments (mots/expressions courtes).
          • Aucune mention de sources, aucun préambule, pas de Markdown.

        Style de rédaction :
          • Questions claires et ciblées.
          • Réponses concises mais informatives (1–3 phrases).
          • Vocabulaire adapté à des étudiants.
      CONTENT

      # deep dup du schéma, puis injection du min/max items dynamiques
      dynamic_schema = JSON.parse(JSON.dump(JSON_SCHEMA["schema"]))
      dynamic_schema
        .dig("properties", "flashcards")
        .merge!({ "minItems" => @count, "maxItems" => @count })

      {
        model: model,
        temperature: temperature,
        max_output_tokens: max_output_tokens,
        instructions: SYSTEM_PROMPT,
        input: [
          {
            role: "user",
            content: [
              { type: "input_text", text: prompt_text },
              { type: "input_text", text: "Exemple (à titre indicatif) :" },
              { type: "input_text", text: EXAMPLE_JSON },
              { type: "input_text", text: "CONTENU à analyser et transformer en flashcards :" },
              { type: "input_text", text: @raw_content }
            ]
          }
        ],
        text: {
          format: {
            name: "flashcards",
            type: "json_schema",
            schema: dynamic_schema
          }
        }
      }
    end
  end
end
