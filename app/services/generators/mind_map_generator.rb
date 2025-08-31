module Generators
  class MindMapGenerator
    def initialize(content, workspace_name = nil, allow_partials: false)
      @content = content
      @workspace_name = workspace_name || "Mind-map"
      @allow_partials = allow_partials
    end

    def call
      prompt = PromptBuilder::Mindmap
                 .new(raw_content: @content, root_title: @workspace_name)
                 .request_payload

      resp = Clients::AiClientResponses.new(payload: prompt).call

      if resp.status == 'incomplete' && !@allow_partials
        raise "Réponse incomplète (#{resp.incomplete_reason || 'unknown'}). Augmente `max_output_tokens` ou segmente."
      end

      mindmap = Decoders::MindMapDecoder.call(resp.text)

      # Ajuste le topic racine si nécessaire
      if %w[mindmap Mind-map].include?(mindmap['topic'])
        mindmap['topic'] = @workspace_name
      end

      # Map vers nodeData
      idx = 0
      build = nil
      build = ->(node) do
        {
          id:       (idx += 1).to_s,
          topic:    node['topic'],
          children: Array(node['children']).map { |c| build.call(c) }
        }.tap { |out| out[:style] = node['style'] if node.key?('style') }
      end

      { nodeData: build.call(mindmap) }
    end
  end
end
