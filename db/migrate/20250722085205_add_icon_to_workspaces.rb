class AddIconToWorkspaces < ActiveRecord::Migration[8.0]
  def change
    add_reference :workspaces, :icon, null: true, foreign_key: true
  end
end
