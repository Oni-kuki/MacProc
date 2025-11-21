#!/bin/bash

# ────────────────────────────────────────────────────────────────
#  Procmon-like pour macOS (fs_usage + opensnoop + execsnoop)
#  Affiche l’activité fichiers, exécutions et I/O système
# ────────────────────────────────────────────────────────────────

echo "=============================================================="
echo "                 MINI PROCMON POUR MACOS"
echo "=============================================================="
echo ""
echo "LÉGENDE :"
echo "  [FS]    = Activité système de fichiers (fs_usage)"
echo "  [OPEN]  = Fichiers ouverts par les processus (opensnoop)"
echo "  [EXEC]  = Processus exécutés (execsnoop)"
echo ""
echo "Appuyez sur Ctrl+C pour arrêter."
echo "=============================================================="
echo ""

# Lancer chaque outil dans une couleur différente
# (désactivable si ton terminal ne supporte pas la couleur)

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # reset

# fs_usage — activité fichiers / réseau / I/O
sudo fs_usage -w 2>/dev/null | \
  sed "s/^/${RED}[FS]${NC} /" &

PID_FS=$!

# opensnoop — fichiers ouverts
sudo opensnoop 2>/dev/null | \
  sed "s/^/${BLUE}[OPEN]${NC} /" &

PID_OPEN=$!

# execsnoop — programmes exécutés
sudo execsnoop 2>/dev/null | \
  sed "s/^/${GREEN}[EXEC]${NC} /" &

PID_EXEC=$!

# Quand on interrompt, tout se ferme proprement
cleanup() {
  echo ""
  echo "Arrêt du moniteur..."
  sudo kill $PID_FS $PID_OPEN $PID_EXEC 2>/dev/null
  exit 0
}

trap cleanup INT
wait
