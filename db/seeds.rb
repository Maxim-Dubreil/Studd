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

user_1_id = User.find_by(email: "user@example.com").id
user_2_id = User.find_by(email: "user2@example.com").id

Workspace.create!([
  { name: "Workspace 1", user_id: user_1_id },
  { name: "Workspace 2", user_id: user_2_id },
  { name: "Workspace 3", user_id: user_1_id},
])