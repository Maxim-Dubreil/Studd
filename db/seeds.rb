# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Workspace.delete_all
User.delete_all

User.create!([
  { id: 1, email: "user@example.com", password: "password", password_confirmation: "password" },
  { id: 2, email: "user2@example.com", password: "password", password_confirmation: "password" }
])

Workspace.create!([
  { name: "Workspace 1", user_id: 1 },
  { name: "Workspace 2", user_id: 1 },
  { name: "Workspace 3", user_id: 1 }
])