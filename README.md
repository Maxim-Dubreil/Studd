# T-YEP-600-REN_13

Projet de fin d'année - Application Rails avec Vite et Tailwind CSS

> 🐳 **Démarrage rapide avec Docker** : Consultez la [documentation Docker complète](docker/README.md) pour un environnement de développement conteneurisé.

## Technologies utilisées

- **Ruby on Rails 8.0.2** - Framework web backend
- **PostgreSQL** - Base de données
- **Vite** - Build tool et serveur de développement frontend
- **Vue.js 3** - Framework JavaScript frontend
- **Tailwind CSS** - Framework CSS utilitaire
- **Devise** - Authentification utilisateur
- **OpenAI API** - Génération de mind-maps, quiz et flashcards

## Prérequis

### Option A : Environnement Docker (recommandé)

- **Docker** et **Docker Compose v2**
- **Git**

### Option B : Installation locale

- **Ruby** (version 3.2.2 recommandée)
- **Node.js** (version 20.19.0+ ou 22.12.0+)
- **PostgreSQL**
- **Git**

## ⚠️ Configuration de l'API OpenAI

**IMPORTANT** : Cette application nécessite une clé API OpenAI pour fonctionner correctement. Sans cette configuration, les fonctionnalités de génération de mind-maps, quiz et flashcards ne seront pas disponibles.

### Étapes de configuration

1. Créez un fichier `.env` à la racine du projet (au même niveau que le fichier README.md)

2. Ajoutez votre clé API OpenAI et les modèles à utiliser dans ce fichier au format suivant :

OPENAI_API_KEY=votre_cle_api

3. **Obtention de la clé API** : Pour obtenir une clé API valide, veuillez contacter l'équipe du projet. Dans le contexte de l'évaluation de ce projet, les frais d'utilisation de l'API sont pris en charge par l'équipe, c'est pourquoi vous ne devez pas utiliser votre propre clé personnelle.

### Remarques importantes

- Le fichier `.env` est déjà configuré pour être ignoré par Git (via `.gitignore`), ce qui garantit que votre clé API ne sera pas partagée accidentellement dans le dépôt.
- En cas de problème d'accès à l'API, vérifiez d'abord que votre fichier `.env` est correctement configuré et que la clé API est valide.
- Les modèles spécifiés (gpt-4o-2024-08-06) sont recommandés pour des performances optimales, mais peuvent être modifiés si nécessaire.
- **Note importante** : Cette approche de gestion des clés API est spécifique au contexte de projet scolaire. Dans un environnement de production réel, les clés API et autres secrets seraient gérés différemment, généralement via des services de gestion de secrets sécurisés (comme AWS Secrets Manager, HashiCorp Vault, etc.) ou des variables d'environnement configurées au niveau de l'infrastructure, et jamais partagées directement entre utilisateurs.

## Installation et Setup

### 🐳 Option A : Avec Docker (recommandé)

> 📖 **Documentation complète** : [Docker README](docker/README.md)

#### Démarrage rapide

```bash
# 1. Cloner le projet
git clone <url-du-repo>
cd T-YEP-600-REN_13

# 2. Construire et démarrer les conteneurs
docker compose -f docker/docker-compose.yml up --build
```

L'application sera accessible sur :

- **Application Rails** : [http://localhost:3000](http://localhost:3000)
- **Serveur Vite (HMR)** : [http://localhost:3036/vite-dev/](http://localhost:3036/vite-dev/)

#### Commandes Docker essentielles

```bash
# Démarrer en arrière-plan
docker compose -f docker/docker-compose.yml up -d

# Arrêter les conteneurs
docker compose -f docker/docker-compose.yml down

# Console Rails dans le conteneur
docker compose -f docker/docker-compose.yml exec web rails c

# Shell dans le conteneur
docker compose -f docker/docker-compose.yml exec web bash
```

### 🛠️ Option B : Installation locale

### 1. Cloner le projet

```bash
git clone <url-du-repo>
cd T-YEP-600-REN_13
```

### 2. Installation des dépendances Ruby

```bash
bundle install
```

### 3. Installation des dépendances Node.js

```bash
npm install
```

### 4. Configuration de la base de données

```bash
# Créer la base de données
rails db:create

# Exécuter les migrations
bin/rails db:migrate

# (Optionnel) Charger les données de test
rails db:seed
```

### 5. Résolution des problèmes courants

Si vous rencontrez des erreurs avec Rollup/Vite :

```bash
# Supprimer les fichiers problématiques
rm -rf node_modules package-lock.json

# Réinstaller les dépendances
npm install
```

Si vous avez des warnings avec les gems :

```bash
gem cleanup stringio
```

Accès :

- **Application** : [http://localhost:3000](http://localhost:3000)
- **Vite HMR** : [http://localhost:3036/vite-dev/](http://localhost:3036/vite-dev/)

### 🛠️ Installation locale - Démarrage complet (recommandé)

```bash
bin/dev
```

Cette commande lance simultanément :

- 🌐 **Serveur Rails** sur `http://localhost:3000`
- ⚡ **Serveur Vite** (assets frontend)

### Commandes alternatives (installation locale)

```bash
# Serveur Rails uniquement
rails server
# ou
rails s

# Serveur sur un port spécifique
rails s -p 4000
```

## Commandes de développement

### 🐳 Commandes Docker

```bash
# Console Rails
docker compose -f docker/docker-compose.yml exec web rails c

# Générer un modèle, contrôleur, etc.
docker compose -f docker/docker-compose.yml exec web rails generate MODEL/CONTROLLER

# Exécuter les migrations
docker compose -f docker/docker-compose.yml exec web rails db:migrate

# Console base de données
docker compose -f docker/docker-compose.yml exec web rails db

# Shell dans le conteneur
docker compose -f docker/docker-compose.yml exec web bash

# Voir les logs
docker compose -f docker/docker-compose.yml logs web

# Redémarrer les services
docker compose -f docker/docker-compose.yml restart
```

### 🛠️ Installation locale

#### Base de données

```bash
# Créer une nouvelle migration
rails generate migration NomDeLaMigration

# Exécuter les migrations
rails db:migrate

# Rollback de la dernière migration
rails db:rollback

# Reset complet de la DB
rails db:reset

# Console Rails
rails console
# ou
rails c
```

### Génération de code

```bash
# Générer un modèle
rails generate model User name:string email:string

# Générer un contrôleur
rails generate controller Users index show

# Générer un contrôleur avec vues
rails generate controller Pages home about --skip-routes

# Générer une migration standalone
rails generate migration AddAgeToUsers age:integer
```

### Tests

```bash
# Lancer tous les tests
bundle exec rspec

# Lancer un fichier de test spécifique
bundle exec rspec spec/models/user_spec.rb

# Lancer les tests avec coverage
COVERAGE=true bundle exec rspec
```

### Assets et Frontend

```bash
# Compiler les assets pour la production
rails assets:precompile

# Nettoyer les assets
rails assets:clean

# Watcher Tailwind CSS uniquement
rails tailwindcss:watch

# Build Vite pour la production
npm run build
```

### Outils de qualité de code

```bash
# Rubocop (linter Ruby)
bundle exec rubocop

# Rubocop avec auto-correction
bundle exec rubocop -a
```

## Structure du projet

```

├── app/
│ ├── controllers/ # Contrôleurs Rails
│ ├── helpers/
│ ├── models/ # Modèles ActiveRecord
│ ├── views/ # Vues ERB
│ ├── frontend/ # Code frontend (TS/Vue)
│ ├── Service/
│ └── assets/ # _Vide assets présent /frontend/images/ _
├── config/ # Configuration Rails
├── db/ # Migrations et schéma DB
├── spec/ # Tests RSpec
├── bin/ # Scripts exécutables
├── Gemfile # Dépendances Ruby
├── package.json # Dépendances Node.js
└── Procfile.dev # Configuration des processus de dev

```

## Notes

- L'application utilise Vue Tailwind CSS, ainsi que la lib Shad/Cn pour un frontend moderne
- Devise est configuré pour l'authentification
- PostgreSQL est utilisé en développement et production
