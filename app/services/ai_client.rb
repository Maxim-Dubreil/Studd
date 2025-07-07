class AiClient
  include HTTParty
  base_uri 'https://api.openai.com/v1'

  def initialize(prompt:)
    @api_key = ENV.fetch('OPENAI_API_KEY')
    @prompt  = prompt
  end

  def call      # (renomme run → call, idiomatique)
    resp = self.class.post(
      '/chat/completions',
      headers: {
        'Authorization' => "Bearer #{@api_key}",
        'Content-Type'  => 'application/json'
      },
      body: {
        model:       'gpt-4',
        messages:    @prompt,
        temperature: 0.7
      }.to_json
    )

    if resp.success?
      return resp.dig('choices', 0, 'message', 'content')
    end

    # ↓ Partie erreur -------------
    err  = resp.parsed_response['error'] rescue nil
    msg  = err ? "#{err['code']} – #{err['message']}" : "HTTP #{resp.code}"
    raise OpenAIError, msg      # -> Exception personnalisée
  rescue HTTParty::Error, SocketError => e
    raise OpenAIError, e.message
  end

  class OpenAIError < StandardError; end
end
