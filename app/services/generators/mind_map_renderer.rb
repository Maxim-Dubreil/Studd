# frozen_string_literal: true

module Generators
  class MindMapRenderer
    PALETTE = %w[#8ab6f9 #ffb3ba #baffc9 #bae1ff #ffd966 #ffdfba].freeze
    RADIUS  = { 0 => "16px", 1 => "12px", 2 => "8px", 3 => "8px" }.freeze

    def initialize(outline, root_title: "Mind-map")
      @outline    = outline
      @root_title = root_title
      @idx        = 0
    end

    def call
      root = node(@root_title, depth: 0, color: PALETTE[0], color_text: "#fff")
      root[:children] = build_chapters
      { nodeData: root }
    end

    private

    def node(topic, depth:, color:, color_text: nil)
      style = { "background" => color, "border-radius" => RADIUS[depth] }
      style["color"] = color_text if color_text
      {
        id:       next_id,
        topic:    topic,
        style:    style,
        children: []
      }
    end

    def next_id
      (@idx += 1).to_s
    end

    def build_chapters
      Array(@outline["chapters"]).map do |ch|
        chap = node(ch["title"].to_s, depth: 1, color: PALETTE[1])
        chap[:children] = build_notions(ch)
        chap
      end
    end

    def build_notions(chapter)
      notions = Array(chapter["notions"])
      depth   = chapter["depth"].to_i # 2 ou 3
      notions.map do |n|
        notion = node(n["topic"].to_s, depth: 2, color: PALETTE[2])
        if depth == 3
          details = Array(n["details"]).presence || []
          notion[:children] = details.map { |d| node(d.to_s, depth: 3, color: PALETTE[3]) }
        end
        notion
      end
    end
  end
end
