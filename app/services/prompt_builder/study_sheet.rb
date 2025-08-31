# frozen_string_literal: true
require "json"

module PromptBuilder
  class StudySheet
    SYSTEM_PROMPT = <<~PROMPT
      Tu es un expert en création de fiches de révision pédagogiques.
      Tes réponses doivent être prêtes à être parsées par un programme :
      — pas de texte d'introduction ou de conclusion
      — pas de Markdown dans le JSON, mais tu peux utiliser du HTML simple dans les contenus
      — un seul objet JSON strict (UTF-8) conforme au schéma demandé
    PROMPT

    JSON_SCHEMA = {
      "name"   => "study_sheet",
      "strict" => true,
      "schema" => {
        "type"                 => "object",
        "additionalProperties" => false,
        "required"             => ["title", "summary", "sections", "key_points"],
        "properties"           => {
          "title" => { "type" => "string", "minLength" => 1 },
          "summary" => { "type" => "string", "minLength" => 1 },
          "sections" => {
            "type"  => "array",
            "minItems" => 2,
            "maxItems" => 8,
            "items" => {
              "type"                 => "object",
              "additionalProperties" => false,
              "required"             => ["title", "content", "subsections"],
              "properties"           => {
                "title"   => { "type" => "string", "minLength" => 1 },
                "content" => { "type" => "string", "minLength" => 1 },
                "subsections" => {
                  "type"  => "array",
                  "items" => {
                    "type"                 => "object",
                    "additionalProperties" => false,
                    "required"             => ["subtitle", "points"],
                    "properties"           => {
                      "subtitle" => { "type" => "string", "minLength" => 1 },
                      "points"   => {
                        "type"      => "array",
                        "minItems"  => 1,
                        "items"     => { "type" => "string", "minLength" => 1 }
                      }
                    }
                  }
                }
              }
            }
          },
          "key_points" => {
            "type"      => "array",
            "minItems"  => 3,
            "maxItems"  => 10,
            "items"     => { "type" => "string", "minLength" => 1 }
          }
        }
      }
    }.freeze

    EXAMPLE_JSON = <<~JSON.chomp
      {
        "title": "La Révolution française (1789-1799)",
        "summary": "La Révolution française marque un tournant majeur dans l'histoire de France et du monde occidental, transformant radicalement les structures politiques et sociales.",
        "sections": [
          {
            "title": "Les causes de la Révolution",
            "content": "La Révolution française trouve ses origines dans une combinaison de crises économiques, sociales et politiques.",
            "subsections": [
              {
                "subtitle": "Causes économiques",
                "points": [
                  "Déficit budgétaire chronique de l'État",
                  "Système fiscal inégalitaire exemptant noblesse et clergé",
                  "Mauvaises récoltes et hausse du prix du pain"
                ]
              }
            ]
          }
        ],
        "key_points": [
          "La prise de la Bastille le 14 juillet 1789 symbolise le début de la Révolution",
          "La Déclaration des droits de l'homme et du citoyen pose les bases d'une société nouvelle",
          "L'abolition des privilèges met fin à l'Ancien Régime"
        ]
      }
    JSON

    DEFAULT_MODEL = ENV.fetch("OPENAI_STUDY_SHEETS_MODEL", "gpt-4o-2024-08-06")

    def initialize(raw_content:)
      @raw_content = raw_content
    end

    def request_payload(model: DEFAULT_MODEL,
                        temperature: 0.3,
                        max_output_tokens: 8_000)

      prompt_text = <<~CONTENT
        Génère une fiche de révision complète et structurée à partir du contenu fourni.

        Contraintes :
          • Structure obligatoire : title, summary, sections, key_points
          • Chaque section doit contenir des sous-sections avec des points clés
          • Le contenu doit être clair, concis et pédagogique
          • Utilise du HTML simple pour la mise en forme (p, br, strong, em, ul, li)

        Style de rédaction :
          • Langage clair et accessible aux étudiants
          • Hiérarchisation logique de l'information
          • Points essentiels mis en évidence
          • Résumé synthétique mais complet
      CONTENT

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
              { type: "input_text", text: "CONTENU à analyser et transformer en fiche de révision :" },
              { type: "input_text", text: @raw_content }
            ]
          }
        ],
        text: {
          format: {
            name: "study_sheet",
            type: "json_schema",
            schema: JSON_SCHEMA["schema"]
          }
        }
      }
    end
  end
end
