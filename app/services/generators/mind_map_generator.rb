module Generators
  class MindMapGenerator

    def initialize(content)
      @content = content
    end

    def call
      prompt       = PromptBuilder::Mindmap.new(@content).build
      raw_response = Clients::AiClient.new(prompt: prompt).call
      parse_response(raw_response)
    end

    private

    def parse_response(raw)
      mindmap = JSON.parse(raw).fetch('mindmap')      # KeyError si la clé manque

      idx   = 0
      build = nil
      build = ->(node) do
        out = {
          id:       (idx += 1).to_s,                  # "1", "2", "3"…
          topic:    node['topic'],
          children: (node['children'] || []).map { |c| build.call(c) }
        }
        out[:style] = node['style'] if node.key?('style')   # ← NOUVEAU
        out
    end

      { nodeData: build.call(mindmap) }               # directement prêt pour mind.init
    rescue JSON::ParserError => e
      raise "Réponse OpenAI invalide : #{e.message}\n--- Contenu reçu ---\n#{raw}"
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