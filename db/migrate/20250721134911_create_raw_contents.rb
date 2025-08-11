class CreateRawContents < ActiveRecord::Migration[8.0]
  def change
    create_table :raw_contents do |t|
      t.references :workspace, null: false, foreign_key: true

      t.timestamps
    end
  end
end
