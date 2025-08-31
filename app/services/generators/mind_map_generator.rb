module Generators
  class MindMapGenerator

    def initialize(content, workspace_name = nil)
      @content = content
      @workspace_name = workspace_name || "Mind-map"
    end

    def call
        prompt = PromptBuilder::Mindmap.new(raw_content: @content, root_title: @workspace_name).request_payload
        raw_response = Clients::AiClientResponses.new(payload: prompt).call
        parse_response(raw_response)
    rescue Clients::AiClientResponses::OpenAIError => e
        raise "Erreur lors de la génération: #{e.message}"
    rescue StandardError => e
        raise "Erreur inattendue lors de la génération: #{e.message}"
    end

    private

    def parse_response(raw)
      if raw.nil?
        raise "Réponse OpenAI vide ou invalide"
      end

      # Parser la réponse JSON principale
      response_data = JSON.parse(raw) rescue {}

      # Extraire le texte contenant la mindmap depuis la structure de réponse
      mindmap_json = nil
      if response_data.key?("output") && response_data["output"].is_a?(Array) && !response_data["output"].empty?
        output = response_data["output"][0]
        if output.key?("content") && output["content"].is_a?(Array) && !output["content"].empty?
          content = output["content"][0]
          if content.key?("text")
            mindmap_json = content["text"]
          end
        end
      end

      # Si on n'a pas trouvé le JSON de la mindmap dans la structure attendue
      if mindmap_json.nil?
        raise "Format de réponse invalide: impossible de trouver le JSON de la mindmap"
      end

      # Parser le JSON de la mindmap
      data = JSON.parse(mindmap_json) rescue {}

      # Extraire la mindmap
      mindmap = data.fetch('mindmap')      # KeyError si la clé manque

      # Remplacer le topic du nœud racine par le nom du workspace
      mindmap['topic'] = @workspace_name if mindmap['topic'] == "mindmap" || mindmap['topic'] == "Mind-map"

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
    rescue NoMethodError, KeyError => e
      raise "Format de réponse invalide : #{e.message}\n--- Contenu reçu ---\n#{raw.inspect}"
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