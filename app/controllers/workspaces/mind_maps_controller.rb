module Workspaces
  class MindmapsController < ApplicationController
    before_action :set_workspace
    before_action :set_mindmap, only: [:show, :destroy]

    def show
      @hide_navbar = true
      @hide_sidebar = true
    end

    def create
      cours = <<~TEXT
  Cours d'Informatique - Linux : Histoire, fonctionnement et utilisation

  Chapitre 1 : Introduction à Linux

  Linux est un système d’exploitation libre et open source, né en 1991 grâce à Linus Torvalds. Inspiré des principes d’UNIX, il est conçu pour offrir stabilité, sécurité et flexibilité. Contrairement aux systèmes propriétaires comme Windows ou macOS, Linux est modifiable par tous et se décline en de nombreuses distributions adaptées à des usages variés : postes de travail, serveurs, embarqué, sécurité, etc.
  - Noyau créé par Linus Torvalds en 1991
  - Code source libre et modifiable
  - Grande variété de distributions

  Chapitre 2 : Architecture et composants de Linux

  L’architecture de Linux repose sur plusieurs couches interdépendantes. Le noyau (kernel) est le cœur du système : il gère la mémoire, les processus et les périphériques. Le shell sert d’interface entre l’utilisateur et le noyau, permettant d’exécuter des commandes. Par-dessus, on peut trouver un environnement graphique (GNOME, KDE, etc.) et un ensemble d’applications. Le système de fichiers suit une hiérarchie stricte, où chaque dossier a un rôle précis.
  - Noyau : gestion matérielle et logicielle
  - Shell : interface en ligne de commande
  - Hiérarchie FHS : /etc, /home, /var, /usr, etc.

  Chapitre 3 : Commandes essentielles

  La maîtrise de Linux passe par la connaissance des commandes de base. Elles permettent de naviguer dans le système, manipuler des fichiers, surveiller les processus et rechercher des informations. Ces commandes peuvent être combinées grâce aux redirections et aux pipes pour créer des traitements complexes.
  - Navigation : pwd, cd, ls
  - Gestion de fichiers : cp, mv, rm, mkdir
  - Consultation : cat, less, head, tail
  - Recherche : find, grep

  Chapitre 4 : Gestion des logiciels

  Chaque distribution dispose de son gestionnaire de paquets, outil central pour installer, mettre à jour et supprimer des programmes. Les distributions basées sur Debian utilisent apt, celles sur Red Hat utilisent dnf ou yum, Arch Linux utilise pacman. Les logiciels peuvent aussi être compilés depuis leur code source, mais cette approche est plus technique.
  - apt, dnf, yum, pacman
  - Installation, mise à jour, suppression
  - Compilation manuelle : ./configure, make, make install

  Chapitre 5 : Administration système

  Administrer un système Linux implique la gestion des utilisateurs, la configuration des services, la surveillance des ressources et la planification des tâches. Les commandes sudo et su permettent d’obtenir des privilèges administrateur. systemctl sert à démarrer, arrêter ou vérifier l’état des services. Pour planifier des tâches, on utilise cron.
  - Gestion utilisateurs : useradd, passwd, groups
  - Services : systemctl, service
  - Planification : cron, at

  Chapitre 6 : Réseau sous Linux

  Linux offre de puissants outils pour la configuration et la surveillance réseau. ip et ifconfig permettent de gérer les interfaces, ping et traceroute servent à diagnostiquer la connectivité. Les outils comme netstat ou ss affichent les connexions actives, tandis que ufw et iptables servent à configurer un pare-feu.
  - Configuration : ip, ifconfig
  - Diagnostic : ping, traceroute
  - Pare-feu : ufw, iptables

  Chapitre 7 : Sécurité

  La sécurité repose sur la bonne gestion des permissions, des utilisateurs et des services exposés. La configuration correcte des droits d’accès est primordiale. L’usage de clés SSH pour l’administration à distance, la mise à jour régulière du système et la surveillance des journaux système (via journalctl) font partie des bonnes pratiques.
  - Permissions : chmod, chown
  - Sécurité SSH : clés publiques/privées
  - Mises à jour régulières

  Chapitre 8 : Scripts et automatisation

  Linux permet d’automatiser de nombreuses tâches grâce aux scripts shell. Un script Bash peut contenir des variables, des conditions et des boucles pour exécuter des actions répétitives. Ces scripts peuvent être lancés manuellement ou planifiés via cron.
  - Langage Bash
  - Variables, conditions, boucles
  - Automatisation de sauvegardes

  Conclusion :

  Linux est un système puissant, flexible et fiable. Sa philosophie ouverte et sa communauté active en font un outil incontournable pour l’administration système, le développement et l’apprentissage de l’informatique. Maîtriser Linux, c’est acquérir des compétences solides et transférables dans de nombreux domaines techniques.
TEXT

      # Génération de la mindmap
      mindmap_data = Generators::MindMapGenerator.new(cours).call

      # Création de l'enregistrement en base de données
      @mindmapContent = @workspace.mind_maps.create!(
        name: "La Révolution française et l'Empire (1789-1815)",
        content: mindmap_data
      )

      if @mindmapContent.save
        render json: { mindmap: @mindmapContent }, status: :created
      else
        render json: { errors: @mindmapContent.errors.full_messages },
              status: :unprocessable_entity
      end
    end

    def destroy
      # 1. Récupère la dernière mind-map du workspace
      last_map = @workspace.mind_maps.order(id: :desc).first

      if last_map
        last_map.destroy
        respond_to do |format|
          format.html { redirect_to workspace_path(@workspace), notice: 'Dernière mind-map supprimée.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to workspace_path(@workspace), alert: 'Aucune mind-map à supprimer.' }
          format.json { render json: { error: 'Mindmap introuvable' }, status: :not_found }
        end
      end
    end

    private

    def set_workspace
      @workspace = Workspace.find(params[:workspace_id])
    end

    def set_mindmap
      @mindmap = @workspace.mind_maps.order(id: :desc).first
    end
  end
end