# frozen_string_literal: true
require "json"

module PromptBuilder
  class Quiz
    SYSTEM_PROMPT = <<~PROMPT
      Tu es un expert en création de quiz pédagogiques pour étudiants.
      Tes réponses doivent être prêtes à être parsées par un programme :
      — Pas de texte d'introduction ni de conclusion
      — Pas de Markdown, de balises HTML, ni de backticks
      — Un seul objet JSON strict (UTF-8), sans commentaires ni virgules finales
    PROMPT

    EXAMPLE_JSON = <<~JSON.chomp
      {
        "quizId": "quiz_001",
        "title": "Révision sur les bases de Git",
        "description": "Un quiz pour tester tes connaissances sur Git.",
        "questions": [
          {
            "id": "q1",
            "type": "multiple_choice",
            "question": "Quelle commande permet de créer une nouvelle branche ?",
            "options": [
              { "id": "a", "text": "git branch nouvelle_branche" },
              { "id": "b", "text": "git checkout nouvelle_branche" },
              { "id": "c", "text": "git init nouvelle_branche" }
            ],
            "correctAnswers": ["a"],
            "explanation": "On crée une branche avec git branch <nom>. La commande git checkout sert à changer de branche."
          },
          {
            "id": "q2",
            "type": "true_false",
            "question": "La commande git clone sert à créer un nouveau commit.",
            "correctAnswers": ["false"],
            "explanation": "git clone sert à copier un dépôt existant, pas à créer un commit."
          }
        ]
      }
    JSON

    # Schéma strict compatible structured-output de /responses :
    # - pas de oneOf/allOf/if/then/else
    # - toutes les clés de properties doivent figurer dans required
    JSON_SCHEMA = {
      "name"   => "quiz",
      "strict" => true,
      "schema" => {
        "type"                 => "object",
        "additionalProperties" => false,
        "required"             => ["quizId", "title", "description", "questions"],
        "properties"           => {
          "quizId"      => { "type" => "string", "minLength" => 1 },
          "title"       => { "type" => "string", "minLength" => 1 },
          "description" => { "type" => "string", "minLength" => 1 },
          "questions"   => {
            "type"     => "array",
            "minItems" => 1,
            "items"    => {
              "type"                 => "object",
              "additionalProperties" => false,
              # IMPORTANT : toutes les clés de properties sont listées ici (incluant "options")
              "required"             => ["id", "type", "question", "correctAnswers", "explanation", "options"],
              "properties"           => {
                "id"           => { "type" => "string", "pattern" => "^q[1-9]\\d*$" },
                "type"         => { "type" => "string", "enum" => ["multiple_choice", "true_false"] },
                "question"     => { "type" => "string", "minLength" => 1 },
                "explanation"  => { "type" => "string", "minLength" => 1 },
                "correctAnswers"=> {
                  "type"     => "array",
                  "minItems" => 1,
                  "maxItems" => 1,
                  "items"    => { "type" => "string", "enum" => ["a","b","c","d","true","false"] }
                },
                # Requise mais nullable → satisfait la contrainte "required ⊇ properties"
                # et permet true_false (options = null) vs multiple_choice (options = array 3..4)
                "options"      => {
                  "anyOf" => [
                    { "type" => "null" },
                    {
                      "type"     => "array",
                      "minItems" => 3,
                      "maxItems" => 4,
                      "items"    => {
                        "type"                 => "object",
                        "additionalProperties" => false,
                        "required"             => ["id", "text"],
                        "properties"           => {
                          "id"   => { "type" => "string", "enum" => ["a","b","c","d"] },
                          "text" => { "type" => "string", "minLength" => 1 }
                        }
                      }
                    }
                  ]
                }
              }
            }
          }
        }
      }
    }.freeze

    DEFAULT_MODEL = ENV.fetch("OPENAI_QUIZ_MODEL", "gpt-4o-2024-08-06")

    def initialize(raw_content:, title: "Quiz")
      @raw_content = raw_content
      @title       = title
    end

    # Enveloppe harmonisée avec Mindmap/Flashcards
    def request_payload(model: DEFAULT_MODEL, temperature: 0.2, max_output_tokens: 8_000)
      prompt_text = <<~CONTENT
        Génère un **quiz JSON strict** qui couvre l'ensemble des concepts clés, sous-concepts, bonnes pratiques et erreurs fréquentes contenus dans la source.

        Exigences de couverture :
          • Crée autant de questions que nécessaire (pas de limite fixe) pour couvrir tout le contenu utile.
          • Répartis les questions proportionnellement à l'importance/complexité des notions.
          • Évite les redites ; chaque question doit tester un angle différent.

        Contraintes de structure :
          • Racine : { "quizId", "title", "description", "questions" }.
          • "quizId" : une chaîne (ex. "quiz_001").
          • "title" : "#{@title}" (ou plus précis si nécessaire).
          • "questions" : tableau de questions.
          • Chaque question : { "id", "type", "question", "correctAnswers", "explanation", "options" }.
              - "id" : "q1"…"qN" sans trous.
              - "type" : "multiple_choice" ou "true_false".
              - "correctAnswers" : exactement 1 élément.
                  · multiple_choice : une lettre "a"…"d".
                  · true_false      : "true" ou "false".
              - "options" :
                  · multiple_choice → tableau de 3 à 4 items { id: "a|b|c|d", text } (OBLIGATOIRE, non-null).
                  · true_false      → null (OBLIGATOIREMENT null).

        Règles de qualité :
          • Questions claires, autonomes et focalisées ; options plausibles.
          • Explication concise qui justifie la bonne réponse (et, si utile, pourquoi les autres sont fausses).
          • Sortie = uniquement l'objet JSON final, strictement valide (pas de Markdown, pas de backticks).
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
              { type: "input_text", text: "CONTENU à analyser et transformer en quiz :" },
              { type: "input_text", text: @raw_content }
            ]
          }
        ],
        text: {
          format: {
            name: "quiz",
            type: "json_schema",
            schema: JSON_SCHEMA["schema"]
          }
        }
      }
    end
  end
end
