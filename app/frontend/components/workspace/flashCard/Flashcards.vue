<script lang="ts">
  const flashcards = [
    // ——— Linux: commandes courtes ———
    { id: 4, term: 'List files in long format', definition: 'ls -l', color: '#FFFACD' }, // citron givré
    { id: 6, term: 'Créer un dossier', definition: 'mkdir <nom_du_dossier>', color: '#FFDCF4' }, // rose dragée
    {
      id: 8,
      term: 'Afficher le contenu d’un fichier',
      definition: 'cat <fichier>',
      color: '#FFEBCF',
    }, // abricot clair
    {
      id: 10,
      term: 'Recherche d’une chaîne dans les fichiers',
      definition: 'grep "motif" *',
      color: '#D4EBF2',
    }, // bleu lagon pâle
    {
      id: 12,
      term: 'Changer les permissions d’un fichier',
      definition: 'chmod 755 <fichier>',
      color: '#CDEFD9',
    }, // vert menthe clair
    {
      id: 14,
      term: 'Compresser un dossier en .tar.gz',
      definition: 'tar -czf archive.tar.gz <dossier>',
      color: '#D9C4FF',
    }, // lavande pâle

    // ——— Linux: définitions plus longues ———
    {
      id: 5,
      term: 'Qu’est‑ce que le noyau Linux ?',
      definition: `Le noyau Linux est le cœur du système : c’est lui qui gère l’ordonnancement des processus, la mémoire, les pilotes matériels et la sécurité.
Il sert d’interface entre les applications utilisateur et les composants matériels, assurant une abstraction uniforme et stable.`,
      color: '#AEDFF7',
    }, // bleu ciel léger

    {
      id: 7,
      term: 'Qu’est‑ce qu’un lien symbolique ?',
      definition: `Un lien symbolique (symlink) est un fichier spécial qui pointe vers un autre fichier ou répertoire.
Contrairement à un hard link, il contient le chemin vers la cible ; si la cible est déplacée ou supprimée, le lien devient cassé.
Les symlinks facilitent la création de raccourcis et la gestion flexible d’arborescences complexes.`,
      color: '#E6F7E6',
    }, // vert mousse pâle

    {
      id: 9,
      term: 'À quoi sert le fichier /etc/fstab ?',
      definition: `/etc/fstab est le fichier de configuration listant les systèmes de fichiers à monter automatiquement au démarrage.
Chaque ligne définit le périphérique ou le label, le point de montage, le type (ext4, vfat, nfs…), les options (defaults, noatime…), et les ordres de vérification fsck.
Bien configuré, il garantit un montage cohérent et sécurisé des disques, partitions chiffrées, réseaux ou volumes logiques.`,
      color: '#F6D6FF',
    }, // mauve pastel

    {
      id: 11,
      term: 'UID 0 : quel rôle ?',
      definition: `L’UID 0 correspond à l’utilisateur « root », qui possède tous les privilèges sur la machine.
Cet identifiant permet d’exécuter n’importe quelle commande, modifier les permissions et accéder à tous les fichiers.
Pour des raisons de sécurité, il est recommandé d’utiliser sudo pour limiter les actions root à ce qui est strictement nécessaire.`,
      color: '#FFEDB8',
    }, // crème vanille

    {
      id: 13,
      term: 'Qu’est‑ce que systemd ?',
      definition: `systemd est le système d’initialisation (init) et gestionnaire de services par défaut de nombreuses distributions modernes.
Il démarre les unités (services, sockets, timers…), gère leur dépendances, journalise les logs via journald et offre des outils comme systemctl.
Son architecture parallèle réduit significativement le temps de boot et fournit une API uniforme pour l’administration.`,
      color: '#F9B4AC',
    }, // pêche doux

    {
      id: 15,
      term: 'Différence entre hard link et soft link ?',
      definition: `• Hard link : entrée supplémentaire dans une même partition pointant directement vers l’inode du fichier.
  – Toutes les entrées partagent les mêmes données ; la suppression de l’une n’efface pas les autres tant qu’il reste au moins un lien.
• Soft link (lien symbolique) : fichier contenant le chemin vers la cible, pouvant traverser les systèmes de fichiers.
  – Si la cible disparaît, le symlink devient invalide (« dangling »).`,
      color: '#FFFACD',
    }, // citron givré
  ];

  export default {
    flashcards,
  };
</script>
