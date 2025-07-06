require 'httparty'

class OpenaiClient
  include HTTParty
  base_uri 'https://api.openai.com/v1'

  def initialize(prompt:)
    @api_key = ENV['OPENAI_API_KEY']
    @prompt = prompt
  end

  def run

    response = self.class.post(
      '/chat/completions',
      headers: {
        "Authorization" => "Bearer #{@api_key}",
        "Content-Type" => "application/json"
      },
      body: {
        model: "gpt-4",
        messages: prompt,
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

end