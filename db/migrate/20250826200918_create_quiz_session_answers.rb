class CreateQuizSessionAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :quiz_session_answers do |t|
      t.references :quiz_session, null: false, foreign_key: true
      
      t.string :question_id, null: false
      t.text :question_text, null: false
      t.string :question_type, null: false
      
      t.json :user_answers, null: false
      t.json :correct_answers, null: false
      t.boolean :is_correct, null: false
      
      t.integer :time_spent_seconds
      t.integer :attempts_count, default: 1
      t.text :explanation_shown
      
      t.json :analytics_data

      t.timestamps
    end

    add_index :quiz_session_answers, [:quiz_session_id, :question_id]
    add_index :quiz_session_answers, :is_correct
    add_index :quiz_session_answers, :question_type
  end
end
