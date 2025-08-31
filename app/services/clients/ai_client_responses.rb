# frozen_string_literal: true
module Clients
  class AiClientResponses
    include HTTParty
    base_uri 'https://api.openai.com/v1'
    default_timeout 180

    class OpenAIError < StandardError; end

    Response = Struct.new(:raw, :text, :status, :incomplete_reason, keyword_init: true)

    def initialize(payload:)
      @api_key = ENV.fetch('OPENAI_API_KEY')
      @payload = payload
    end

    def call
      http = self.class.post(
        '/responses',
        headers: {
          'Authorization' => "Bearer #{ENV.fetch('OPENAI_API_KEY')}",
          'Content-Type'  => 'application/json'
        },
        body: @payload.to_json,
        timeout: 180
      )
      raise OpenAIError, "HTTP #{http.code} – #{http.body}" unless http.success?

      body = JSON.parse(http.body) rescue {}
      text = extract_full_text(body)

      Response.new(
        raw: body,
        text: text,
        status: body['status'],
        incomplete_reason: body.dig('incomplete_details', 'reason')
      )
    end

    private

    def extract_full_text(body)
      return body['output_text'] if body['output_text'].is_a?(String) && !body['output_text'].empty?

      pieces = Array(body['output'])
        .select { |m| m['type'] == 'message' }
        .flat_map { |m| Array(m['content']) }
        .select { |c| c['type'] == 'output_text' && c['text'].is_a?(String) }
        .map    { |c| c['text'] }

      pieces.any? ? pieces.join : nil
    end
  end
end
