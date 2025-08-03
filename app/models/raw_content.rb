# == Schema Information
#
# Table name: raw_contents
#
#  id           :integer          not null, primary key
#  workspace_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  content      :text
#
# Indexes
#
#  index_raw_contents_on_workspace_id  (workspace_id)
#
class RawContent < ApplicationRecord
  belongs_to :workspace, dependent: :destroy
  has_one_attached :file, dependent: :destroy

  validate :file_or_content_present
  validate :file_and_content_not_both_present

  def content_type
    if file.attached?
      file.content_type
    elsif content.present?
      'text/plain'
    else
      nil
    end
  end

  def file_name
    file.attached? ? file.filename.to_s : nil
  end

  private

  def file_or_content_present
    unless file.attached? || content.present?
      errors.add(:base, "Vous devez fournir un fichier ou du contenu texte.")
    end
  end

  def file_and_content_not_both_present
    if file.attached? && content.present?
      errors.add(:base, "Vous ne pouvez pas fournir à la fois un fichier et du contenu texte.")
    end
  end
end 