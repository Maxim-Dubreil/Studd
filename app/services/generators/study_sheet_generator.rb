# frozen_string_literal: true

module Generators
  class StudySheetGenerator
    def initialize(content)
      @content = content
    end

    def call
      payload = PromptBuilder::StudySheet
        .new(raw_content: @content)
        .request_payload

      ai_response = Clients::AiClientResponses.new(payload: payload).call

      study_sheet_data = Decoders::StudySheetDecoder.decode!(ai_response)

      study_sheet_data
    rescue Decoders::StudySheetDecoder::DecodeError => e
      raise "Erreur de décodage de la fiche de révision : #{e.message}"
    rescue Clients::AiClientResponses::OpenAIError => e
      raise "Erreur API : #{e.message}"
    end
  end
end
