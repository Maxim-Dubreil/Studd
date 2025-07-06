
class FlashcardGenerator
  def initialize(content)
    @content = content
  end

  def call
    prompt = Ai::PromptBuilder::Flashcard.new(@content).build
    raw_response = OpenaiClient.new(prompt).call
    parse_response(raw_response)
  end

  private

  def parse_response(raw)
    json_str = raw.match(/```json\n(.*?)\n```/m)&.captures&.first || raw
    json = JSON.parse(json_str)

    json["flashcards"].map.with_index do |card, i|
      {
        id: "fc_#{SecureRandom.hex(4)}",
        question: sanitize(card["question"]),
        answer: sanitize(card["answer"]),
        difficulty: card["difficulty"] || "medium",
        tags: Array(card["tags"]).first(3)
      }
    end
  rescue JSON::ParserError => e
    raise "Réponse OpenAI invalide : #{e.message}"
  end

  def sanitize(text)
    ActionController::Base.helpers.sanitize(text.to_s)
  end
end