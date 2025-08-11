module PromptBuilder
  class Mindmap
    SYSTEM_PROMPT = <<~PROMPT
      Tu es un expert en création de mind-maps pédagogiques pour étudiants.
      Tes réponses doivent être prêtes à être parsées par un programme :
      — Pas de texte d'introduction ni de conclusion
      — Pas de Markdown ni de balises
      — Un seul objet JSON strict (UTF-8)
    PROMPT

    # Exemple mis à jour avec une clé "style"
    EXAMPLE_JSON = <<~JSON.chomp
      {
        "mindmap": {
          "topic": "Titre principal",
          "style": { "background": "#8ab6f9", "border-radius": "16px", "color": "#fff" },
          "children": [
            {
              "topic": "Chapitre 1",
              "style": { "background": "#ffb3ba", "border-radius": "12px" },
              "children": [
                {
                  "topic": "Sous-chapitre 1.1",
                  "style": { "background": "#ffd966" },
                  "children": []
                }
              ]
            }
          ]
        }
      }
    JSON

    def initialize(content, root_title: "Mind-map", palette: nil)
      @content     = content
      @root_title  = root_title
      # palette par défaut : couleurs pastel
      @palette     = palette || %w[#8ab6f9 #ffb3ba #baffc9 #bae1ff #ffd966 #ffdfba]
    end

    def build
      [
        { role: "system", content: SYSTEM_PROMPT },
        {
          role: "user",
          content: <<~CONTENT
            Génère **exactement** une structure de mind-map au format JSON strict correspondant à l'exemple :

            #{EXAMPLE_JSON}

            ▸ Schéma à respecter :
              • Clé racine obligatoire : "mindmap"
              • Champs obligatoires par nœud :
                  - "topic"   (string)
                  - "children" (array, peut être vide)
              • Champ optionnel : "style" (objet CSS inline ; ex. {"background":"#ffb3ba","border-radius":"12px"})

            ▸ Contraintes impératives :
              1. Aucune ligne avant/après l'objet JSON.
              2. Pas de retour à la ligne dans les valeurs de "topic".
              3. Le nœud racine doit avoir pour topic « #{@root_title} ».
              4. Limite la profondeur à 3 niveaux maximum (« Chapitre », « Sous-chapitre », « Détail »).
              5. Utilise la palette suivante pour colorer les nœuds (cycle sur la profondeur) :
                 #{@palette.join(', ')}
                 * Niveau 0 → couleur[0], niveau 1 → couleur[1], niveau 2 → couleur[2]…
              6. Applique un "border-radius" plus faible lorsque la profondeur augmente :
                 * 16px (niveau 0) → 12px (niveau 1) → 8px (niveau 2).

            ▸ Contenu source à transformer en mind-map :
            #{@content}
          CONTENT
        }
      ]
    end
  end
end