require 'httparty'

class OpenaiPromptRunner
  include HTTParty
  base_uri 'https://api.openai.com/v1'

  def initialize(focusTool:, contenu:)
    @focusTool = focusTool
    @contenu = contenu
    @api_key = ENV['OPENAI_API_KEY']
    @prompt = get_prompt
  end

  def run
    messages = build_messages

    response = self.class.post(
      '/chat/completions',
      headers: {
        "Authorization" => "Bearer #{@api_key}",
        "Content-Type" => "application/json"
      },
      body: {
        model: "gpt-4",
        messages: messages,
        temperature: 0.7
      }.to_json
    )

    output = response.parsed_response.dig("choices", 0, "message", "content")
    puts "\n--- ✅ OUTPUT ---\n\n#{output}\n\n--- 🔚 FIN ---"
    output
  rescue => e
    puts "[Erreur OpenAI] #{e.message}"
    nil
  end

  private

  def get_prompt
    file_path = Rails.root.join('app', 'prompt-mapping.json')
    mapping = JSON.parse(File.read(file_path))
    mapping.dig(@focusTool, "prompt") || raise("Aucun prompt trouvé pour : #{@focusTool}")
  end

  def build_messages
    [
      {
        role: "system",
        content: "Tu es un assistant éducatif. Tu aides à générer des fiches, quiz et flashcards à partir d’un contenu fourni. Structure les réponses avec des balises comme [SECTION], [QUESTION], etc., selon le besoin."
      },
      {
        role: "user",
        content: "Consigne : #{@prompt}"
      },
      {
        role: "user",
        content: "Voici le contenu à partir duquel tu dois travailler :\n\n#{@contenu}"
      }
    ]
  end
end