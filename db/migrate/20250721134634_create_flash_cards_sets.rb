class CreateFlashCardsSets < ActiveRecord::Migration[8.0]
  def change
    create_table :flash_cards_sets do |t|
      t.references :workspace, null: false, foreign_key: true
      t.string     :name,    null: false
      t.jsonb      :content, null: false, default: []

      t.timestamps
    end

    add_index :flash_cards_sets, :name
    add_index :flash_cards_sets, :content, using: :gin
  end
end
