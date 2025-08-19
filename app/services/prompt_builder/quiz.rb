module PromptBuilder
  class Quiz
    SYSTEM_PROMPT = <<~PROMPT
      Tu es un expert en création de quiz pédagogiques pour étudiants.
      Tes réponses doivent être prêtes à être parsées par un programme :
      — Pas de texte d'introduction ni de conclusion
      — Pas de Markdown ni de balises
      — Un seul objet JSON strict (UTF-8)
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
            "explanation": "On crée une branche avec `git branch <nom>`. La commande `git checkout` sert à changer de branche."
          },
          {
            "id": "q2",
            "type": "true_false",
            "question": "La commande `git clone` sert à créer un nouveau commit.",
            "correctAnswers": ["false"],
            "explanation": "`git clone` sert à copier un dépôt existant, pas à créer un commit."
          },
          {
            "id": "q3",
            "type": "fill_in_blank",
            "question": "La commande pour voir l'historique des commits est `git _____`.",
            "correctAnswers": ["log"],
            "explanation": "`git log` permet d'afficher l'historique des commits."
          }
        ]
      }
    JSON

    def initialize(content, title: "Quiz")
      @content = content
      @title = title
    end

    def build
      [
        { role: "system", content: SYSTEM_PROMPT },
        {
          role: "user",
          content: <<~CONTENT
            Génère **exactement** un quiz au format JSON strict correspondant à l'exemple :

            #{EXAMPLE_JSON}

            ▸ Schéma à respecter :
              • Champs obligatoires au niveau racine :
                  - "quizId" (string, format "quiz_XXX")
                  - "title" (string)
                  - "description" (string)
                  - "questions" (array)
              • Champs obligatoires pour chaque question :
                  - "id" (string, format "qX" où X est un nombre)
                  - "type" (string, l'un des suivants : "multiple_choice", "true_false", "fill_in_blank")
                  - "question" (string)
                  - "correctAnswers" (array de strings)
                  - "explanation" (string)
              • Champ obligatoire uniquement pour les questions de type "multiple_choice" :
                  - "options" (array d'objets avec "id" et "text")

            ▸ Contraintes impératives :
              1. Aucune ligne avant/après l'objet JSON.
              2. Crée un quiz avec un titre pertinent basé sur le contenu fourni.
              3. Adapte automatiquement le nombre de questions pour couvrir l'ensemble des notions importantes du contenu.
              4. Identifie les concepts clés et crée des questions pertinentes pour chacun d'eux.
              5. Choisis le type de question le plus approprié en fonction de la notion à tester :
                 - "multiple_choice" pour les concepts avec plusieurs options possibles
                 - "true_false" pour vérifier la compréhension d'affirmations
                 - "fill_in_blank" pour tester la connaissance de termes spécifiques
              6. Pour les questions à choix multiples, fournis 3 à 4 options dont une seule est correcte.
              7. Pour les questions vrai/faux, les réponses correctes doivent être "true" ou "false".
              8. Pour les questions à trous, utilise le symbole "_____" pour indiquer l'emplacement du mot manquant.
              9. Chaque question doit avoir une explication claire et concise.

            ▸ Contenu source à transformer en quiz :
            #{@content}
          CONTENT
        }
      ]
    end
  end
end