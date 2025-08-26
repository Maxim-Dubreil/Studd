module PromptBuilder
  class Quiz
    SYSTEM_PROMPT = <<~PROMPT
      Tu es un expert en création de quiz pédagogiques pour étudiants.
      Tes réponses doivent être prêtes à être parsées par un programme :
      — Pas de texte d'introduction ni de conclusion
      — Pas de Markdown ni de balises ni de backticks
      — Un seul objet JSON strict (UTF-8), sans commentaires, sans virgules finales
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
                  - "id" (string, format "qX" où X est un nombre, croissant et sans trous)
                  - "type" (string, l'un des suivants : "multiple_choice", "true_false")
                  - "question" (string, claire et autonome)
                  - "correctAnswers" (array de strings)
                  - "explanation" (string, claire et concise)
              • Champ obligatoire uniquement pour les questions de type "multiple_choice" :
                  - "options" (array d'objets { "id": "a|b|c|d", "text": "..." }) avec 3 à 4 options dont UNE SEULE correcte

            ▸ Objectif principal : couverture complète du sujet
              1) Identifie tous les concepts clés, sous-concepts importants, bonnes pratiques et erreurs fréquentes à partir du contenu donné.
              2) Crée **autant de questions que nécessaire** pour couvrir l'ensemble de ces éléments (aucune limite fixe).
              3) Répartis les questions de façon proportionnée :
                 - Concepts majeurs : au moins 1 question chacun (plus si le concept est central ou complexe).
                 - Sous-concepts/variantes : inclure si cela améliore la couverture sans redondance.
              4) Si le contenu est volumineux et hétérogène, assure une couverture équilibrée de chaque grande section thématique (sans ajouter de métadonnées de section dans la sortie).

            ▸ Consignes de qualité et de cohérence :
              5) Pas de texte en dehors de l'objet JSON. Pas de Markdown, pas de backticks, pas de balises HTML.
              6) Les identifiants de questions sont continus ("q1" à "qN") et uniques.
              7) Les options de "multiple_choice" ont des IDs parmi "a", "b", "c", "d" (sans doublon), avec exactement une bonne réponse listée dans "correctAnswers".
              8) Pour "true_false", "correctAnswers" est soit ["true"] soit ["false"] (en minuscules).
              9) Évite les redites : chaque question doit tester un angle ou un niveau différent.
             10) Les explications doivent mentionner le **pourquoi** de la bonne réponse et, si utile, pourquoi les mauvaises sont incorrectes.
             11) Utilise un langage simple, précis et sans jargon inutile. Pas de références au présent prompt dans la sortie.
             12) Le titre et la description doivent être pertinents et refléter fidèlement le contenu et l'étendue de la couverture.

            ▸ Contenu source à transformer en quiz :
            #{@content}

            ▸ Rappel important :
            — La sortie doit être **uniquement** l'objet JSON final, strictement valide.
          CONTENT
        }
      ]
    end
  end
end
