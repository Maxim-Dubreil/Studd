# frozen_string_literal: true

module PromptBuilder
  class Mindmap
    COL_GAP = 280
    ROW_GAP = 90

    DEFAULT_PALETTE = %w[#8ab6f9 #ffb3ba #baffc9 #bae1ff #ffd966 #ffdfba]

    # --- System message kept minimal and assertive
    SYSTEM_PROMPT = <<~PROMPT
      Tu génères des mind-maps pédagogiques prêtes pour Vue Flow. Ces minds-map do
      Tu réponds EXCLUSIVEMENT par UN objet JSON valide (UTF-8), sans autre texte.
    PROMPT

    # --- Strict JSON Schema for Structured Outputs (no extra keys allowed)
    JSON_SCHEMA = {
      "name"   => "mindmap",
      "strict" => true,
      "schema" => {
        "type"                 => "object",
        "additionalProperties" => false,
        "required"             => ["nodes", "edges"],
        "properties"           => {
          "nodes" => {
            "type"  => "array",
            "items" => {
              "type"                 => "object",
              "additionalProperties" => false,
              "required"             => ["id", "position", "data"],
              "properties"           => {
                "id" => { "type" => "string", "minLength" => 1 },
                "position" => {
                  "type"                 => "object",
                  "additionalProperties" => false,
                  "required"             => ["x", "y"],
                  "properties"           => {
                    "x" => { "type" => "number" },
                    "y" => { "type" => "number" }
                  }
                },
                "data" => {
                  "type"                 => "object",
                  "additionalProperties" => false,
                  "required"             => ["label"],
                  "properties"           => {
                    "label" => { "type" => "string", "minLength" => 1 }
                  }
                },
                "style" => {
                  "type"                 => "object",
                  "additionalProperties" => false,
                  "properties"           => {
                    "backgroundColor" => { "type" => "string" },
                    "color"           => { "type" => "string" },
                    "borderRadius"    => { "type" => "number" }
                  }
                }
              }
            }
          },
          "edges" => {
            "type"  => "array",
            "items" => {
              "type"                 => "object",
              "additionalProperties" => false,
              "required"             => ["id", "source", "target"],
              "properties"           => {
                "id"     => { "type" => "string", "pattern" => "^e.+-.+$" },
                "source" => { "type" => "string", "minLength" => 1 },
                "target" => { "type" => "string", "minLength" => 1 }
              }
            }
          }
        }
      }
    }.freeze

    def initialize(content, root_title: "Mind-map", palette: nil)
      @content    = content
      @root_title = root_title
      @palette    = palette || DEFAULT_PALETTE
    end

    # --- Backward-compatible: returns messages array like before
    def build
      [
        { role: "system", content: SYSTEM_PROMPT },
        { role: "user",   content: user_prompt }
      ]
    end

    # --- New: payload ready for the Responses API with strict JSON schema
    # Example usage (ruby-openai >= latest that supports Responses API):
    #   client = OpenAI::Client.new
    #   payload = prompt_builder.request_payload(model: "gpt-4.1-mini")
    #   resp = client.responses.create(payload)
    #   json = JSON.parse(resp.output_text)
    def request_payload(model: ENV.fetch("OPENAI_MINDMAP_MODEL", "gpt-4.1-mini"),
                        temperature: 0.2,
                        max_output_tokens: 8000)
      {
        model: model,
        response_format: { type: "json_schema", json_schema: JSON_SCHEMA, strict: true },
        input: build,
        temperature: temperature,
        max_output_tokens: max_output_tokens
      }
    end

    private

    def user_prompt
      <<~TXT
        OBJECTIF
        Génère une mind-map Vue Flow sous forme d'UNIQUE objet JSON qui VALIDE le schéma fourni (nodes[], edges[]). AUCUNE autre propriété.

        RÈGLES DE MODÉLISATION
        • Racine (level 0)
          – id = "1" ; data.label = "#{@root_title}" ; position.x = 0 ; style.backgroundColor = #{@palette[0]}; style.color = "#fff" ; style.borderRadius = 16
        • Chapitres (level 1)
          – Chaque titre commençant par « Chapitre N : » devient un enfant DIRECT de la racine, dans l'ordre d'apparition ; style.backgroundColor = #{@palette[1]}; style.borderRadius = 12
        • Détails (level 2)
          – À l'intérieur de chaque chapitre, CHAQUE ligne commençant par « - » devient un enfant du chapitre, en respectant strictement l'ordre.
          – Si un chapitre n'a PAS de puces, EXTRAIS 3 à 5 idées clés du paragraphe pour créer ses enfants.
          – Conserve les dates présentes dans les labels telles quelles (ex. « 26 août 1789 : … »).
        • Un nœud (hors racine) a EXACTEMENT UN parent. Les arêtes relient UNIQUEMENT parent → enfant immédiat.

        CONTRAINTES DE SORTIE (VUE FLOW)
        • Objet JSON avec uniquement : "nodes":[], "edges":[]. Rien d'autre.
        • Chaque node : { id:string, position:{x:number,y:number}, data:{label:string}, style?:{backgroundColor?:string,color?:string,borderRadius?:number} }
          – data.label : une SEULE ligne, sans retour ; espaces normalisés ; ≤ 140 caractères (résume si besoin sans perdre le sens).
          – Palette par profondeur : level 0 → #{@palette[0]} ; level 1 → #{@palette[1]} ; level 2 → #{@palette[2]}
            borderRadius : 16 (niv 0) → 12 (niv 1) → 8 (niv 2).
        • Grille SANS CHEVAUCHEMENT (Vue Flow)
          – level = profondeur (0: racine, 1: chapitre, 2: détail)
          – x = level * #{COL_GAP}. Répartis les CHAPITRES moitié à x = -#{COL_GAP}, moitié à x = #{COL_GAP} (équilibre visuel).
          – y = rang * #{ROW_GAP} (rang = index vertical parmi les frères, en gardant l'ordre du texte, y croissants).
        • Chaque edge : { id:"e<source>-<target>", source:string, target:string }.

        CHECKLIST SILENCIEUSE (NE RIEN AFFICHER)
        • Chaque chapitre a ≥ 1 enfant.
        • Nombre de puces par chapitre = nombre de nœuds de niveau 2 (ou 3–5 si sans puces).
        • Aucun label vide. Aucun doublon strict parmi les enfants d'un même parent.
        • Aucun nœud (hors racine) avec plusieurs parents.
        • Sortie JSON conforme au schéma strict (pas de clés supplémentaires, pas de `type`).

        CONTENU SOURCE À TRANSFORMER EN MIND-MAP :
        #{@content}
      TXT
    end
  end
end
