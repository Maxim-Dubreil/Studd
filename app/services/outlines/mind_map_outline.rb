# frozen_string_literal: true

module Outlines
  class MindMapOutline
    SYSTEM_PROMPT = <<~SYS
      Tu structues un cours dense en chapitres, notions et (si utile) détails.
      Tu réponds EXCLUSIVEMENT en JSON valide (UTF-8), sans autre texte.
    SYS

    JSON_SCHEMA = {
      "name"   => "outline",
      "strict" => true,
      "schema" => {
        "type"                 => "object",
        "additionalProperties" => false,
        "required"             => ["chapters"],
        "properties"           => {
          "chapters" => {
            "type"      => "array",
            "minItems"  => 1,
            "items"     => {
              "type"                 => "object",
              "additionalProperties" => false,
              "required"             => ["title", "notions", "depth"],
              "properties"           => {
                "title"   => { "type" => "string", "minLength" => 1, "maxLength" => 120 },
                "depth"   => { "type" => "integer", "enum" => [2, 3] }, # 2 = notions ; 3 = notions + détails
                "notions" => {
                  "type"     => "array",
                  "minItems" => 2, # ≥ 2 notions par chapitre
                  "items"    => {
                    "type"                 => "object",
                    "additionalProperties" => false,
                    "required"             => ["topic"],
                    "properties"           => {
                      "topic"   => { "type" => "string", "minLength" => 1, "maxLength" => 300 }
                    },
                    "optionalProperties"    => {
                      "details" => {
                        "type"     => "array",
                        "minItems" => 2,         # si présents → 2 à 5 items
                        "maxItems" => 5,
                        "items"    => { "type" => "string", "minLength" => 1, "maxLength" => 300 }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }.freeze

    def initialize(content)
      @content = content
    end

    def request_payload(model: ENV.fetch("OPENAI_MINDMAP_MODEL", "gpt-4o-2024-08-06"),
                        temperature: 0.2,
                        max_output_tokens: 3000)
      {
        model: model,
        instructions: SYSTEM_PROMPT,
        input: [
          {
            role: "user",
            content: [
              { type: "input_text", text: user_prompt }
            ]
          }
        ],
        text: {
          format: {
            type: "json_schema",
            name: "outline",
            schema: JSON_SCHEMA["schema"]
          }
        },
        temperature: temperature,
        max_output_tokens: max_output_tokens
      }
    end

    private

    def user_prompt
      <<~TXT
        OBJECTIF
        Tu dois analyser un texte SOURCE potentiellement long et non balisé (sans titres explicites ni puces) et
        le DÉCOUPER toi-même en chapitres cohérents, chacun regroupant ses notions clés. Si certaines notions
        sont denses, tu peux ajouter un niveau "détails". L'objectif est d'obtenir un OUTLINE exhaustif, structuré
        et exploitable pour une mind-map.

        PRINCIPES DE DÉCOUPAGE (important)
        • Ne te fie pas au mot-clé "Chapitre" : déduis les chapitres par thèmes/segments logiques du texte.
        • Conserve l'ORDRE d'apparition des idées ; ne réarrange pas arbitrairement.
        • Couvre TOUTES les idées majeures (pas d'omission), évite les doublons.
        • Titre de chapitre : court, informatif, fidèle au contenu (tu peux reprendre un titre existant s'il est présent).
        • Chaque chapitre comporte AU MOINS 2 notions (phrases synthétiques).
        • Choix de la profondeur par chapitre :
          – depth=2 si le contenu est synthétique (notions uniquement) ;
          – depth=3 si le contenu est dense : alors ajoute des "details" (2–5 items pertinents) uniquement sous les notions qui le justifient.

        CONTRAINTES DE RÉDACTION
        • Une seule ligne par "topic"/"detail" ; pas de retour à la ligne.
        • Longueur maximale : topic ≤ 300 caractères ; detail ≤ 300 caractères.
        • Formulations factuelles, sans invention ; résumer sans perdre le sens.

        SORTIE ATTENDUE
        • Objet JSON conforme au schéma transmis (clé racine "chapters", etc.), sans texte hors JSON.

        SOURCE
        #{@content}
      TXT
    end
  end
end