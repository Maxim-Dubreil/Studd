#fichier de test pour le service openAI

require 'dotenv/load'

# Exemple de test :
runner = OpenaiPromptRunner.new(
  focusTool: "flash_card",
  contenu: "La Révolution française commence en 1789. Elle entraîne la chute de la monarchie absolue."
)

runner.run