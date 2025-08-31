# frozen_string_literal: true

module Clients
  class AiClientResponses
    include HTTParty
    base_uri 'https://api.openai.com/v1'
    default_timeout 180

    class OpenAIError < StandardError; end

    def initialize(payload:)
      @api_key = ENV.fetch('OPENAI_API_KEY')
      @payload = payload
    end

    def call
      resp = self.class.post(
        '/responses',
        headers: {
          'Authorization' => "Bearer #{@api_key}",
          'Content-Type'  => 'application/json'
        },
        body: @payload.to_json,
        timeout: 180
      )
      raise OpenAIError, "HTTP #{resp.code} – #{resp.body}" unless resp.success?

      body = JSON.parse(resp.body) rescue {}

      return body.to_json if body.is_a?(Hash) && !body.key?('output_text')

    end
  end
end
