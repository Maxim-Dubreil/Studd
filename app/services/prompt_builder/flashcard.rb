
module Ai::PromptBuilder
  class Flashcard
    SYSTEM_PROMPT = <<~PROMPT
      Tu es un expert en création de flashcards pédagogiques.
      Les flashcards doivent être claires, précises et adaptées à la mémorisation active.
    PROMPT

    def initialize(content)
      @content = content
    end

    def build
      [
        { role: "system", content: SYSTEM_PROMPT },
        {
          role: "user",
          content: <<~CONTENT
            Crée 10 flashcards à partir de ce contenu :
            Format JSON strict avec :
            - question (string)
            - answer (string)
            - difficulty (easy/medium/hard)
            - tags (array)

            Contenu :
            #{@content.truncate(1500)}
          CONTENT
        }
      ]
    end
  end
end