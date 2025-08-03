class AddContentToRawContents < ActiveRecord::Migration[8.0]
  def change
    add_column :raw_contents, :content, :text
  end
end
