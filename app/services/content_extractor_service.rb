require 'pdf-reader'

class ContentExtractorService
  attr_reader :workspace

  def initialize(workspace)
    @workspace = workspace
  end

  def extract_content
    raw_content = workspace.raw_content
    return "" unless raw_content

    if raw_content.content.present?
      raw_content.content
    elsif raw_content.file&.attached? && pdf_file?(raw_content.file)
      extract_pdf_content(raw_content.file)
    else
      ""
    end
  rescue => e
    Rails.logger.error "Failed to extract content from workspace #{workspace.id}: #{e.message}"
    ""
  end

  private

  def pdf_file?(file)
    file.content_type == 'application/pdf'
  end

  def extract_pdf_content(file)
    file.open do |tempfile|
      reader = PDF::Reader.new(tempfile)
      reader.pages.map(&:text).join("\n")
    end
  end
end
