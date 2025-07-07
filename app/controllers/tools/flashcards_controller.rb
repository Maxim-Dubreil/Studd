module Tools
  class FlashcardsController < ::ApplicationController

    def new
    end

    # def create
    #   workspace = Workspace.find(params[:workspace_id])
    #   flashcards = FlashcardGenerator.new(workspace.content).call
    #   render json: { flashcards: flashcards }
    # rescue ActiveRecord::RecordNotFound
    #   render json: { error: "Workspace introuvable" }, status: :not_found
    # rescue => e
    #   render json: { error: "Échec de génération : #{e.message}" }, status: :unprocessable_entity
    # end

    def create
      cours = <<~TEXT
        Cours d'Histoire - La Révolution française et l'Empire (1789-1815)

        Chapitre 1 : Les causes de la Révolution française

        La Révolution française trouve ses origines dans de multiples facteurs :
        - Une monarchie absolue fragilisée par les dettes de l'État
        - Des impôts injustement répartis entre les trois ordres
        - Le rôle des philosophes des Lumières, qui critiquent l'arbitraire royal et défendent la liberté
        - Une crise économique et sociale profonde, marquée par la famine et le chômage

        Chapitre 2 : Les grandes étapes de la Révolution

        1789 marque le début de la Révolution :
        - 5 mai 1789 : ouverture des États Généraux à Versailles
        - 17 juin 1789 : le Tiers État se proclame Assemblée nationale
        - 14 juillet 1789 : prise de la Bastille, symbole de l'absolutisme
        - Nuit du 4 août : abolition des privilèges
        - 26 août 1789 : Déclaration des Droits de l’Homme et du Citoyen

        Chapitre 3 : La mise en place d’une monarchie constitutionnelle

        Entre 1789 et 1791, l’Assemblée nationale constituante rédige une constitution.
        - Le roi conserve le pouvoir exécutif, mais les lois sont votées par l’Assemblée
        - En 1791, Louis XVI tente de fuir à Varennes, ce qui crée une rupture avec le peuple
        - La défiance à l’égard de la monarchie s’accentue

        Chapitre 4 : La République et la Terreur

        - 21 septembre 1792 : la République est proclamée
        - 21 janvier 1793 : Louis XVI est exécuté
        - 1793-1794 : Robespierre met en place la Terreur
          → les opposants à la Révolution sont guillotinés
        - La Convention adopte des mesures sociales mais gouverne dans la peur

        Chapitre 5 : Le Directoire et l’instabilité politique

        Après la chute de Robespierre :
        - Le Directoire (1795-1799) remplace la Convention
        - Le régime est instable, la corruption est importante
        - Les tensions sociales persistent et le pouvoir devient impopulaire

        Chapitre 6 : L'ascension de Napoléon Bonaparte

        - 1799 : coup d’État du 18 Brumaire → Napoléon prend le pouvoir
        - Mise en place du Consulat, puis du Premier Empire (1804)
        - Réformes importantes : Code civil, lycées, Banque de France
        - Politique autoritaire et centralisée

        Chapitre 7 : L’Empire et sa chute

        - Napoléon mène de nombreuses guerres en Europe (coalitions)
        - Il contrôle une grande partie du continent mais multiplie les ennemis
        - 1812 : échec de la campagne de Russie → début du déclin
        - 1814 : abdication, puis retour pour les Cent-Jours
        - 1815 : défaite à Waterloo, exil définitif à Sainte-Hélène

        Conclusion :

        La Révolution française a profondément transformé la France : fin de l’Ancien Régime, nouveaux droits, souveraineté nationale. L’Empire napoléonien a diffusé ces idées en Europe, tout en instaurant une dictature militaire. Cette période reste fondatrice de notre histoire politique moderne.

      TEXT
      flashcards = Generators::FlashcardGenerator.new(cours).call
      render json: { flashcards: flashcards }

      rescue StandardError => e
        render json: { error: "Erreur de génération : #{e.message}" }, status: :unprocessable_entity
    end

    #faire par rapport au save plutot que au create

    private

    def workspace_params
      params.permit(:workspace_id)
    end

  end
end