module PromptBuilder
  class Flashcard
    SYSTEM_PROMPT = <<~PROMPT
      Tu es un expert en création de flash-cards pédagogiques.
      Tes réponses doivent être prêtes à être parsées par un programme : pas de texte d’introduction, pas de mise en forme Markdown.
    PROMPT

    EXAMPLE_JSON = <<~JSON.chomp
      {
        "flashcards": [
          {
            "question": "Quel événement déclenche la Révolution française ?",
            "answer":   "La prise de la Bastille le 14 juillet 1789.",
            "difficulty": "easy",
            "tags": ["Révolution", "Dates"]
          }
        ]
      }
    JSON

    def initialize(content)
      @content = content
    end

    def build
      [
        { role: "system", content: SYSTEM_PROMPT },
        {
          role: "user",
          content: <<~CONTENT
            Génère **exactement** 10 flash-cards à partir du contenu ci-dessous.

            • Le résultat doit être **un objet JSON strict** (UTF-8), identique au format d’exemple ci-après :
            #{EXAMPLE_JSON}

            • Règles impératives :
              1. Aucun texte avant ou après l’objet JSON.
              2. Pas de ```json ni de ``` autour.
              3. Clé racine obligatoire : "flashcards".
              4. Chaque carte contient : "question", "answer", "difficulty", "tags".
              5. "difficulty" ∈ { "easy", "medium", "hard" }.
              6. "tags" : tableau de 1 à 3 mots maximum, pas de caractère spécial.

            Contenu source :
            #{@content}
          CONTENT
        }
      ]
    end
  end
end
