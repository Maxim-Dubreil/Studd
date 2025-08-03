# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Cleaning database..."
ActiveRecord::Base.transaction do
  RawContent.destroy_all
  Workspace.destroy_all
  User.destroy_all
  Icon.destroy_all
  RawContent.destroy_all
end

puts "Creating users..."
user1 = User.create!(email: "user@example.com", password: "password", password_confirmation: "password")
user2 = User.create!(email: "user2@example.com", password: "password", password_confirmation: "password")

puts "Creating icons..."
icons_data = [
  { name: 'mecha', path: 'mecha.png' },
  { name: 'medecine', path: 'medecine.png' },
  { name: 'eco', path: 'eco.png' },
  { name: 'Droit', path: 'Droit.png' },
  { name: 'Physique', path: 'Physique.png' },
  { name: 'adn', path: 'adn.png' },
  { name: 'atome', path: 'atome.png' },
  { name: 'math', path: 'math.png' },
  { name: 'electronique', path: 'electronique.png' },
  { name: 'justice', path: 'justice.png' },
  { name: 'geo', path: 'geo.png' },
]
Icon.create!(icons_data)

puts "Creating workspaces..."
Workspace.create!([
  { name: "Cours de Mecha", user: user1, icon: Icon.find_by(name: 'mecha') },
  { name: "Medecine", user: user2, icon: Icon.find_by(name: 'medecine') },
  { name: "Eco", user: user1, icon: Icon.find_by(name: 'eco') },
])

puts "Seeding complete!"