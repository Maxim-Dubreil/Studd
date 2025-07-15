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

## Prérequis

### Option 1 : Environnement Docker (recommandé)

- **Docker** et **Docker Compose v2**
- **Git**

### Option 2 : Installation locale

- **Ruby** (version 3.2.2 recommandée)
- **Node.js** (version 20.19.0+ ou 22.12.0+)
- **PostgreSQL**
- **Git**

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

## Lancement de l'application

### 🐳 Avec Docker

```bash
# Démarrer l'application (première fois ou après modifications)
docker compose -f docker/docker-compose.yml up --build

# Démarrer en arrière-plan
docker compose -f docker/docker-compose.yml up -d
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
│ ├── models/ # Modèles ActiveRecord
│ ├── views/ # Vues ERB
│ ├── frontend/ # Code frontend (TS/Vue)
│ └── assets/ # _A CHANGER LES CSS ET DANS STYLE FRONTEND ET AJOUTER LES ASSETS AUSSI DEDANS_
├── config/ # Configuration Rails
├── db/ # Migrations et schéma DB
├── spec/ # Tests RSpec
├── bin/ # Scripts exécutables
├── Gemfile # Dépendances Ruby
├── package.json # Dépendances Node.js
└── Procfile.dev # Configuration des processus de dev

```

## Notes

- L'application utilise Vite pour le frontend moderne
- Tailwind CSS est configuré avec un watcher automatique
- Devise est configuré pour l'authentification
- PostgreSQL est utilisé en développement et production
