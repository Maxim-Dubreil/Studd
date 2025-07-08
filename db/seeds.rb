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
  { email: "user@example.com", password: "password", password_confirmation: "password" },
  { email: "user2@example.com", password: "password", password_confirmation: "password" }
])

Workspace.create!([
  { name: "Workspace 1", owner_id: 1 },
  { name: "Workspace 2", owner_id: 1 },
  { name: "Workspace 3", owner_id: 1 }
])