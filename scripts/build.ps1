# Script de build PowerShell pour le projet Collectionneur
# Ce script automatise le processus de build Flutter sur Windows

Write-Host "🚀 Démarrage du build du projet Collectionneur..." -ForegroundColor Green

# Vérifier que Flutter est installé
try {
    $flutterVersion = flutter --version
    Write-Host "✅ Flutter détecté" -ForegroundColor Green
} catch {
    Write-Host "❌ Flutter n'est pas installé ou n'est pas dans le PATH" -ForegroundColor Red
    exit 1
}

# Nettoyer le projet
Write-Host "🧹 Nettoyage du projet..." -ForegroundColor Yellow
flutter clean

# Récupérer les dépendances
Write-Host "📦 Récupération des dépendances..." -ForegroundColor Yellow
flutter pub get

# Générer le code avec build_runner
Write-Host "🔨 Génération du code avec build_runner..." -ForegroundColor Yellow
flutter packages pub run build_runner build --delete-conflicting-outputs

# Analyser le code
Write-Host "🔍 Analyse du code..." -ForegroundColor Yellow
flutter analyze

# Tests (optionnel)
$runTests = Read-Host "Voulez-vous exécuter les tests ? (y/n)"
if ($runTests -eq "y" -or $runTests -eq "Y") {
    Write-Host "🧪 Exécution des tests..." -ForegroundColor Yellow
    flutter test
}

# Build de l'APK (optionnel)
$buildApk = Read-Host "Voulez-vous construire l'APK ? (y/n)"
if ($buildApk -eq "y" -or $buildApk -eq "Y") {
    Write-Host "📱 Construction de l'APK..." -ForegroundColor Yellow
    flutter build apk --release
    Write-Host "✅ APK construit avec succès dans build/app/outputs/flutter-apk/" -ForegroundColor Green
}

Write-Host "🎉 Build terminé avec succès !" -ForegroundColor Green




