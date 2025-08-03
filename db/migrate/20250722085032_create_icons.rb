class CreateIcons < ActiveRecord::Migration[8.0]
  def change
    create_table :icons do |t|
      t.string :name
      t.string :path

      t.timestamps
    end
  end
end
