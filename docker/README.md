# Docker – Environnement de développement

> Cette documentation décrit **l’environnement de dev conteneurisé** pour le projet Rails 8 / Vite 5 / Vue 3 / Tailwind 4.
> Les commandes utilisent **Docker Compose v2** (`docker compose …`). Adaptez‑les si vous utilisez encore l’ancien binaire `docker-compose`.

---

## 1. Construction des images (première fois ou après modification majeure du Dockerfile)

```bash
# Construit uniquement les images définies dans docker/docker-compose.yml
docker compose -f docker/docker-compose.yml build
```

### Tout en un (re‑build + démarrage) – raccourci

```bash
docker compose -f docker/docker-compose.yml up --build
```

---

## 2. Démarrage / arrêt des conteneurs

| Action                                         | Commande                                              |
| ---------------------------------------------- | ----------------------------------------------------- |
| **Démarrer** (en arrière‑plan)                 | `docker compose -f docker/docker-compose.yml up -d`   |
| **Démarrer** (logs dans le terminal)           | `docker compose -f docker/docker-compose.yml up`      |
| **Arrêter et supprimer** les conteneurs        | `docker compose -f docker/docker-compose.yml down`    |
| **Arrêter + supprimer les volumes** (reset DB) | `docker compose -f docker/docker-compose.yml down -v` |

> _Astuce :_ appuyez sur **Ctrl‑C** lorsque `up` s’exécute au premier plan pour arrêter élégamment puis lancez `docker compose down` pour nettoyer.

---

## 3. Services exposés

| Service                 | URL (hôte)                                                         | Description                           |
| ----------------------- | ------------------------------------------------------------------ | ------------------------------------- |
| Rails                   | [http://localhost:3000](http://localhost:3000)                     | API / pages server‑side               |
| Vite (dev‑server + HMR) | [http://localhost:3036/vite-dev/](http://localhost:3036/vite-dev/) | Assets & Hot Reload                   |
| PostgreSQL              | `localhost:5432`                                                   | Credentials : `postgres` / `postgres` |

La base est créée et migrée automatiquement par `bin/rails db:prepare` dans **entrypoints/dev.sh**.

---

## 4. Commandes utiles à l’intérieur du conteneur _web_

```bash
# Console Rails
docker compose -f docker/docker-compose.yml exec web rails c

# Générer un modèle, un contrôleur.
docker compose -f docker/docker-compose.yml exec web rails g MODEL/CONTROLLER

# Lancer les migrations manuellement
docker compose -f docker/docker-compose.yml exec web rails db:migrate

# Ouvrir un shell bash dans le container
docker compose -f docker/docker-compose.yml exec web bash
```

---

## 5. Arborescence Docker

```
docker/
├── Dockerfile.dev      # Image de développement (Rails + Vite + pnpm)
├── Dockerfile.prod     # Image de production (multi‑stage)
├── docker-compose.yml  # Orchestration web + PostgreSQL
├── entrypoints/
│   └── dev.sh          # Attente DB + db:prepare + foreman (Rails + Vite)
```

---

## 6. Notes & bonnes pratiques

- **Hot Reload** : grâce au couple *vite_rails* + Foreman, toute modification dans `app/frontend` déclenche un HMR instantané dans le navigateur.
- **Ports** : si 3000 ou 5432 sont déjà utilisés sur votre machine, modifiez uniquement la partie **gauche** du mapping (`4000:3000`, `5433:5432`, etc.).
- **Volumes** : `postgres_data` conserve la base entre les redémarrages. Supprimez‑le avec `down -v` pour repartir de zéro.
- **Production** : voir `Dockerfile.prod` (multi‑stage) et prévoyez les variables `RAILS_MASTER_KEY` / `DATABASE_URL` ou utilisez **Kamal** pour le déploiement.
