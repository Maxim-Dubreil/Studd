module Generators
  class MindMapGenerator

    def initialize(content)
      @content = content
    end

    def call
      prompt       = PromptBuilder::Mindmap.new(@content).build
      raw_response = AiClient.new(prompt: prompt).call
      parse_response(raw_response)
    end

    private

    def parse_response(raw)
      obj = JSON.parse(raw)

      nodes = Array(obj["nodes"]).map do |n|
        {
          id: n.fetch("id").to_s,
          position: {
            x: Float(n.dig("position", "x")),
            y: Float(n.dig("position", "y")),
          },
          data: { label: n.dig("data", "label").to_s },
          style: (n["style"].is_a?(Hash) ? n["style"] : nil)
        }.compact
      end

      edges = Array(obj["edges"]).map do |e|
        {
          id: e.fetch("id").to_s,
          source: e.fetch("source").to_s,
          target: e.fetch("target").to_s,
          type: (e["type"] || "bezier")
        }
      end

      { nodes: nodes, edges: edges }
    rescue JSON::ParserError => e
      raise "Réponse IA invalide : #{e.message}\n--- Contenu reçu ---\n#{raw}"
    rescue KeyError, TypeError, ArgumentError => e
      raise "JSON manquant ou mal formé : #{e.message}\n--- Contenu reçu ---\n#{raw}"
    end


    # ------------------------------------------------------------------
    # Helpers spécifiques au parseur mindmap
    # ------------------------------------------------------------------

    # Nettoie et met sur une seule ligne le contenu textuel d'un topic.
    def normalize_topic(html)
      # plain_text() utilise déjà sanitize() → on retire le HTML, on trim,
      # puis on compacte les espaces et on force une seule ligne.
      topic = plain_text(html).gsub(/\s+/, ' ').strip
      # (Optionnel) Limiter la longueur pour éviter les nœuds "romans"
      # topic = topic[0, 500]
      topic
    end

  end
end