# frozen_string_literal: true
require "json"

module PromptBuilder
  class Mindmap
    SYSTEM_PROMPT = <<~PROMPT
      Tu es un expert en création de mind-maps pédagogiques pour étudiants.
      Ta mission : CRÉER une mind-map JSON à partir du contenu fourni.
      Règles de sortie :
      — Pas de texte d'introduction ni de conclusion
      — Pas de Markdown ni de balises
      — Un seul objet JSON strict (UTF-8)
    PROMPT

    # Schéma strict de sortie pour la mind-map
    # - Racine: { "mindmap": Node }
    # - Node: { topic, children[], style }
    # - style est "nullable" pour rester optionnel, tout en respectant l'exigence de champs requis dans l'objet
    JSON_SCHEMA = {
      "name"   => "mindmap",
      "strict" => true,
      "schema" => {
        "type"                 => "object",
        "additionalProperties" => false,
        "required"             => ["mindmap"],
        "properties"           => {
          "mindmap" => { "$ref" => "#/$defs/node" }
        },
        "$defs" => {
          "style" => {
            "type"                 => "object",
            "additionalProperties" => false,
            "required"             => ["background", "border-radius", "color"],
            "properties"           => {
              "background"    => { "type" => "string" },
              "border-radius" => { "type" => "string" },
              "color"         => { "type" => "string" }
            }
          },
          "node" => {
            "type"                 => "object",
            "additionalProperties" => false,
            "required"             => ["topic", "children", "style"],
            "properties"           => {
              "topic"   => { "type" => "string" },
              "children"=> {
                "type"  => "array",
                "items" => { "$ref" => "#/$defs/node" }
              },
              # style optionnel via null, sinon objet strict
              "style"   => {
                "anyOf" => [
                  { "type" => "null" },
                  { "$ref" => "#/$defs/style" }
                ]
              }
            }
          }
        }
      }
    }.freeze

    EXAMPLE_JSON = <<~JSON.chomp
      {
        "mindmap": {
          "topic": "Programmation Web",
          "style": { "background": "#8ab6f9", "border-radius": "16px", "color": "#fff" },
          "children": [
            {
              "topic": "Frontend",
              "style": { "background": "#ffb3ba", "border-radius": "12px", "color": "#000" },
              "children": [
                {
                  "topic": "HTML/CSS",
                  "style": { "background": "#ffd966", "border-radius": "8px", "color": "#000" },
                  "children": [
                    {
                      "topic": "Sémantique HTML5",
                      "style": { "background": "#ffd966", "border-radius": "8px", "color": "#000" },
                      "children": [
                        {
                          "topic": "Utilisation de balises qui décrivent leur contenu (header, nav, section)",
                          "style": { "background": "#e6f2ff", "border-radius": "6px", "color": "#333" },
                          "children": []
                        },
                        {
                          "topic": "Améliore l'accessibilité et le référencement naturel (SEO)",
                          "style": { "background": "#e6f2ff", "border-radius": "6px", "color": "#333" },
                          "children": []
                        },
                        {
                          "topic": "Facilite la maintenance et la compréhension du code",
                          "style": { "background": "#e6f2ff", "border-radius": "6px", "color": "#333" },
                          "children": []
                        }
                      ]
                    },
                    {
                      "topic": "Flexbox & Grid",
                      "style": { "background": "#ffd966", "border-radius": "8px", "color": "#000" },
                      "children": [
                        {
                          "topic": "Flexbox: système de mise en page unidimensionnel pour organiser les éléments en ligne ou en colonne",
                          "style": { "background": "#e6f2ff", "border-radius": "6px", "color": "#333" },
                          "children": []
                        },
                        {
                          "topic": "Grid: système bidimensionnel permettant de créer des mises en page complexes avec lignes et colonnes",
                          "style": { "background": "#e6f2ff", "border-radius": "6px", "color": "#333" },
                          "children": []
                        },
                        {
                          "topic": "Remplacent les anciennes techniques comme les tableaux et les flottants pour la mise en page",
                          "style": { "background": "#e6f2ff", "border-radius": "6px", "color": "#333" },
                          "children": []
                        }
                      ]
                    },
                    {
                      "topic": "Responsive Design",
                      "style": { "background": "#ffd966", "border-radius": "8px", "color": "#000" },
                      "children": [
                        {
                          "topic": "Approche de conception qui adapte l'affichage à la taille de l'écran de l'utilisateur",
                          "style": { "background": "#e6f2ff", "border-radius": "6px", "color": "#333" },
                          "children": []
                        },
                        {
                          "topic": "Utilise les media queries CSS pour appliquer différents styles selon les caractéristiques de l'appareil",
                          "style": { "background": "#e6f2ff", "border-radius": "6px", "color": "#333" },
                          "children": []
                        },
                        {
                          "topic": "Essentiel pour offrir une expérience utilisateur optimale sur mobile, tablette et desktop",
                          "style": { "background": "#e6f2ff", "border-radius": "6px", "color": "#333" },
                          "children": []
                        }
                      ]
                    }
                  ]
                },
                {
          ]
        }
      }
    JSON

    def initialize(raw_content:, root_title: "Mind-map", palette: nil)
      @raw_content = raw_content
      @root_title  = root_title
      @palette     = palette || %w[#8ab6f9 #ffb3ba #baffc9 #bae1ff #ffd966 #ffdfba]
    end


    def request_payload(model: ENV.fetch("OPENAI_MINDMAP_MODEL", "gpt-4o-2024-08-06"),
                        temperature: 0.2,
                        max_output_tokens: 12_000)
      prompt_text = <<~CONTENT
        Génère exactement une structure de mind-map au format JSON correspondant à l'exemple.
        Tu dois ANALYSER le CONTENU fourni et le transformer en une hiérarchie de nœuds.

        ▸ Schéma fonctionnel à respecter (guidelines) :
          • Clé racine obligatoire : "mindmap"
          • Pour chaque nœud :
              - "topic"    (string, une seule ligne, sans retour à la ligne)
              - "children" (array, peut être vide)
              - "style"    (objet optionnel; si absent → null). Le schéma exige la clé "style", mais elle peut être null.

        ▸ Contraintes de présentation :
          1) Le nœud racine doit avoir pour topic "#{@root_title}".
          2) Profondeur EXACTE : 3 niveaux (Chapitre → Sous-chapitre/Notion → Détail).
             IMPORTANT : Chaque sous-chapitre/notion DOIT avoir au moins deux nœuds de détail. Ces détails doivent être des phrases courtes (et non une suite de mots)
          3) Palette par profondeur (cycle) : #{@palette.join(', ')}.
             - Niveau 0 → couleur[0], niveau 1 → couleur[1], niveau 2 → couleur[2].
          4) Border radius décroissant : 16px (niveau 0), 12px (niveau 1), 8px (niveau 2).
          5) IMPORTANT : tous les enfants héritent du "background" de leur parent (même couleur de fond).
      CONTENT

      example_json_text = EXAMPLE_JSON
      raw_content_text = @raw_content

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
              { type: "input_text", text: example_json_text },
              { type: "input_text", text: "CONTENU à analyser et transformer en mindmap :" },
              { type: "input_text", text: raw_content_text }
            ]
          }
        ],
        text: {
          format: {
            name: "mindmap",
            type: "json_schema",
            schema: JSON_SCHEMA["schema"]
          }
        }
      }
    end
  end
end

def validate_schema(json_response)
  begin
    # Vérifier si la réponse est un JSON valide
    data = JSON.parse(json_response) rescue nil
    return { valid: false, error: "La réponse n'est pas un JSON valide" } unless data

    # Vérifier si la structure de base est correcte
    return { valid: false, error: "La clé 'mindmap' est manquante" } unless data.key?("mindmap")

    # Vérifier si le nœud racine est conforme
    mindmap = data["mindmap"]
    return { valid: false, error: "Le nœud racine doit être un objet" } unless mindmap.is_a?(Hash)

    # Vérifier les propriétés requises du nœud racine
    required_props = ["topic", "children", "style"]
    missing_props = required_props.select { |prop| !mindmap.key?(prop) }
    return { valid: false, error: "Propriétés manquantes dans le nœud racine: #{missing_props.join(', ')}" } if missing_props.any?

    # Vérifier le type des propriétés
    return { valid: false, error: "'topic' doit être une chaîne de caractères" } unless mindmap["topic"].is_a?(String)
    return { valid: false, error: "'children' doit être un tableau" } unless mindmap["children"].is_a?(Array)

    # Vérifier le style
    if mindmap["style"] && mindmap["style"] != nil
      style = mindmap["style"]
      return { valid: false, error: "'style' doit être un objet ou null" } unless style.is_a?(Hash)

      # Vérifier les propriétés requises du style
      style_props = ["background", "border-radius", "color"]
      missing_style_props = style_props.select { |prop| !style.key?(prop) }
      return { valid: false, error: "Propriétés manquantes dans le style: #{missing_style_props.join(', ')}" } if missing_style_props.any?

      # Vérifier le type des propriétés du style
      style_props.each do |prop|
        return { valid: false, error: "La propriété '#{prop}' du style doit être une chaîne de caractères" } unless style[prop].is_a?(String)
      end
    end

    # Vérifier récursivement tous les nœuds enfants
    errors = validate_nodes(mindmap["children"])
    return { valid: false, error: errors } if errors

    # Si tout est valide
    return { valid: true }
  rescue => e
    return { valid: false, error: "Erreur lors de la validation: #{e.message}" }
  end
end

private

def validate_nodes(nodes)
  return nil unless nodes.is_a?(Array)

  nodes.each_with_index do |node, index|
    # Vérifier si le nœud est un objet
    return "Le nœud à l'index #{index} doit être un objet" unless node.is_a?(Hash)

    # Vérifier les propriétés requises
    required_props = ["topic", "children", "style"]
    missing_props = required_props.select { |prop| !node.key?(prop) }
    return "Propriétés manquantes dans le nœud à l'index #{index}: #{missing_props.join(', ')}" if missing_props.any?

    # Vérifier le type des propriétés
    return "'topic' doit être une chaîne de caractères dans le nœud à l'index #{index}" unless node["topic"].is_a?(String)
    return "'children' doit être un tableau dans le nœud à l'index #{index}" unless node["children"].is_a?(Array)

    # Vérifier le style
    if node["style"] && node["style"] != nil
      style = node["style"]
      return "'style' doit être un objet ou null dans le nœud à l'index #{index}" unless style.is_a?(Hash)

      # Vérifier les propriétés requises du style
      style_props = ["background", "border-radius", "color"]
      missing_style_props = style_props.select { |prop| !style.key?(prop) }
      return "Propriétés manquantes dans le style du nœud à l'index #{index}: #{missing_style_props.join(', ')}" if missing_style_props.any?

      # Vérifier le type des propriétés du style
      style_props.each do |prop|
        return "La propriété '#{prop}' du style doit être une chaîne de caractères dans le nœud à l'index #{index}" unless style[prop].is_a?(String)
      end
    end

    # Vérifier récursivement les enfants de ce nœud
    child_error = validate_nodes(node["children"])
    return child_error if child_error
  end

  nil # Pas d'erreur
end
