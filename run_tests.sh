#!/bin/bash
cd "$(dirname "$0")"
echo "=== Lancement de la suite de tests RSpec ==="
echo ""

echo "1. Tests des modèles..."
bundle exec rspec spec/models/user_spec.rb --format progress

echo ""
echo "2. Tests des helpers..."
bundle exec rspec spec/helpers/ --format progress

echo ""
echo "3. Tests des services (PromptBuilder)..."
bundle exec rspec spec/services/prompt_builder/ --format progress

echo ""
echo "4. Tests des contrôleurs..."
bundle exec rspec spec/controllers/ --format progress

echo ""
echo "=== Résumé final ==="
bundle exec rspec spec/models/user_spec.rb spec/helpers/ spec/services/prompt_builder/ spec/controllers/ --format documentation

echo ""
echo "=== Tests terminés avec succès! ==="
