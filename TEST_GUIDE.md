# Guide des Tests RSpec

## Vue d'ensemble

Ce projet utilise RSpec comme framework de test principal avec plusieurs gems de support .

## Configuration des Tests

### Gems de Test Installées

- `rspec-rails` - Framework de test principal pour Rails
- `factory_bot_rails` - Génération de données de test (factories)
- `faker` - Génération de données aléatoires réalistes
- `shoulda-matchers` - Matchers pour tester les associations et validations
- `database_cleaner-active_record` - Nettoyage de la base de données entre tests
- `rails-controller-testing` - Support pour tester les contrôleurs Rails

### Fichiers de Configuration

- `.rspec` - Configuration générale RSpec
- `spec/spec_helper.rb` - Configuration de base RSpec
- `spec/rails_helper.rb` - Configuration spécifique à Rails avec Devise et FactoryBot

## Structure des Tests

```
spec/
├── controllers/        # Tests des contrôleurs
├── factories/         # Factories FactoryBot
├── helpers/           # Tests des helpers
├── models/            # Tests des modèles (partiellement configurés)
└── services/          # Tests des services
    └── prompt_builder/ # Tests des constructeurs de prompts
```

## Tests Actuellement Fonctionnels

### Tests des Helpers
- `ApplicationHelper` - Méthodes d'aide pour l'authentification Devise
- `IconsHelper` - Helper pour les icônes
- `VueComponentHelper` - Génération de composants Vue.js

### Tests des Services
- `PromptBuilder::Quiz` - Constructeur de prompts pour quiz
- `PromptBuilder::Flashcard` - Constructeur de prompts pour flashcards

### Tests des Contrôleurs
- `PagesController` - Actions publiques (landing_page, about)

### Tests des Modèles (Partiels)
- `User` - Tests basiques sans base de données

## Lancement des Tests

### Script Principal
```bash
./run_tests.sh
```

### Tests Spécifiques
```bash
# Tests des helpers
bundle exec rspec spec/helpers/ --format documentation

# Tests des services
bundle exec rspec spec/services/prompt_builder/ --format documentation

# Tests des contrôleurs
bundle exec rspec spec/controllers/ --format documentation

# Tests d'un fichier spécifique
bundle exec rspec spec/helpers/vue_component_helper_spec.rb --format documentation
```

## Résultats Actuels

**53 exemples, 0 échecs, 1 en attente**

Tous les tests passent avec succès! Le seul test en attente concerne `RawContentsHelper` qui est vide.


### Pour Réactiver les Tests avec Base de Données

1. Vérifier que PostgreSQL est démarré:
   ```bash
   cd docker && docker-compose up -d db
   ```

2. Réactiver dans `spec/rails_helper.rb`:
   ```ruby
   # Décommenter ces lignes:
   begin
     ActiveRecord::Migration.maintain_test_schema!
   rescue ActiveRecord::PendingMigrationError => e
     abort e.to_s.strip
   end
   ```

3. Créer et migrer la base de test:
   ```bash
   RAILS_ENV=test bundle exec rails db:create db:migrate
   ```

## Factories Disponibles

- `:user` - Utilisateur avec email et mot de passe valides
- `:workspace` - Espace de travail avec utilisateur et icône
- `:icon` - Icône avec nom et chemin
- `:raw_content` - Contenu brut avec texte ou fichier attaché
- `:quiz` - Quiz avec questions et réponses


## Commandes Utiles

```bash
# Lancer tous les tests avec couverture détaillée
bundle exec rspec --format documentation

# Lancer les tests en mode verbose
bundle exec rspec --format progress

# Lancer un test spécifique avec trace détaillée
bundle exec rspec spec/path/to/test_spec.rb:42 --format documentation

# Vérifier la syntaxe RSpec
bundle exec rspec --dry-run
```


## Dépannage

### Erreur Devise
Les helpers Devise sont configurés dans `rails_helper.rb` pour les tests de contrôleurs.

### Erreur Factory
Vérifiez que les factories sont bien définies dans `spec/factories/` et que FactoryBot est inclus.
