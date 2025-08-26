#!/bin/bash

# Script de build pour le projet Collectionneur
# Ce script automatise le processus de build Flutter

echo "🚀 Démarrage du build du projet Collectionneur..."

# Vérifier que Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé ou n'est pas dans le PATH"
    exit 1
fi

# Nettoyer le projet
echo "🧹 Nettoyage du projet..."
flutter clean

# Récupérer les dépendances
echo "📦 Récupération des dépendances..."
flutter pub get

# Générer le code avec build_runner
echo "🔨 Génération du code avec build_runner..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Analyser le code
echo "🔍 Analyse du code..."
flutter analyze

# Tests (optionnel)
read -p "Voulez-vous exécuter les tests ? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧪 Exécution des tests..."
    flutter test
fi

# Build de l'APK (optionnel)
read -p "Voulez-vous construire l'APK ? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📱 Construction de l'APK..."
    flutter build apk --release
    echo "✅ APK construit avec succès dans build/app/outputs/flutter-apk/"
fi

echo "🎉 Build terminé avec succès !"




