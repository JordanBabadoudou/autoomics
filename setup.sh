#!/bin/bash

echo "🚀 [AutoOmics] Initialisation de l'environnement Conda..."

# Vérifie si conda est installé
if ! command -v conda &> /dev/null; then
    echo "❌ Conda n'est pas installé. Installez Miniconda ou Anaconda d'abord."
    exit 1
fi

# Créer l’environnement Conda
conda env create -f environment.yml

# Activer l’environnement
echo "✅ Environnement 'autoomics-env' créé."
echo "➡️ Activez-le avec : conda activate autoomics-env"

# Installer les paquets R s’ils ne sont pas disponibles via conda
echo "📦 Installation des packages R depuis CRAN (si besoin)..."
Rscript requirements-r.R

echo "✅ Installation terminée."
