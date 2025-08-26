module ContentExtractable
  extend ActiveSupport::Concern

  private

  def extract_workspace_content
    content_text = ContentExtractorService.new(@workspace).extract_content

    if content_text.blank?
      render json: { error: "Aucun contenu trouvé pour ce workspace" }, status: :unprocessable_entity
      return nil
    end

    content_text
  end
end
