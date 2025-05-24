#!/bin/sh
set -e

cd /app

# Vérifie si node_modules existe
if [ ! -d "node_modules" ]; then
  echo "📦 node_modules manquant — exécution de 'npm ci'..."
  npm ci
else
  echo "✅ node_modules déjà présent — pas de npm ci"
fi

# Exécute la commande passée au conteneur
exec "$@"