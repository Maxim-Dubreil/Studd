class CreateQuizSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :quiz_sessions do |t|
      t.references :workspace, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      
      t.datetime :started_at, null: false
      t.datetime :completed_at
      t.integer :duration_seconds, default: 0
      
      t.integer :score, default: 0
      t.integer :total_questions, null: false
      t.decimal :accuracy_percentage, precision: 5, scale: 2
      
      t.string :quiz_mode, null: false
      t.string :session_type, default: 'standard'
      t.json :metadata

      t.timestamps
    end

    add_index :quiz_sessions, [:workspace_id, :created_at]
    add_index :quiz_sessions, [:user_id, :quiz_mode]
    add_index :quiz_sessions, :completed_at
  end
end
