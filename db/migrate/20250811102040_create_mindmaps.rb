class CreateMindmaps < ActiveRecord::Migration[8.0]
  def change
    create_table :mindmaps do |t|
      t.references :workspace, null: false, foreign_key: true
      t.string :name
      t.jsonb :content

      t.timestamps
    end
  end
end
