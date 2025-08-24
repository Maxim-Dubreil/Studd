class CreateQuizzes < ActiveRecord::Migration[8.0]
  def change
    create_table :quizzes do |t|
      t.references :workspace, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.jsonb :content

      t.timestamps
    end
  end
end
