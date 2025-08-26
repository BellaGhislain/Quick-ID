# Configuration des Icônes et Splash Screen - Quick ID

## 🎨 Génération des Icônes de Lancement

Après avoir installé les dépendances, générez les icônes pour toutes les plateformes :

```bash
# Installer les dépendances
flutter pub get

# Générer les icônes de lancement
flutter pub run flutter_launcher_icons:main
```

## 🌅 Génération du Splash Screen

Générez le splash screen natif :

```bash
# Générer le splash screen
flutter pub run flutter_native_splash:create
```

## 📱 Plateformes Supportées

- ✅ Android (API 21+)
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS

## 🎯 Configuration

### Icônes de Lancement
- **Image source** : `assets/images/mnelectronic.jpg`
- **Couleur de fond** : `#ca1b49` (rouge MN Electronics)
- **Taille Android** : 48x48px
- **Taille iOS** : 1024x1024px

### Splash Screen
- **Couleur de fond** : `#ca1b49`
- **Image centrale** : `assets/images/mnelectronic.jpg`
- **Support Android 12** : Oui

## 🔧 Personnalisation

Pour modifier la configuration :

1. **Icônes** : Modifiez la section `flutter_launcher_icons` dans `pubspec.yaml`
2. **Splash Screen** : Modifiez la section `flutter_native_splash` dans `pubspec.yaml`
3. **Image** : Remplacez `assets/images/mnelectronic.jpg` par votre image

## 📋 Commandes Utiles

```bash
# Nettoyer et régénérer
flutter clean
flutter pub get
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create

# Vérifier la configuration
flutter doctor
flutter analyze
```

## ⚠️ Notes Importantes

- L'image source doit être de haute qualité (1024x1024px minimum)
- Format recommandé : PNG ou JPG
- Redémarrez l'application après la génération
- Testez sur appareils physiques pour vérifier le rendu
