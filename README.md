# Quick ID

Application de gestion d'identités avec stockage offline-first.

## 🚀 Fonctionnalités

### Gestion des Instances
- Créer, modifier et supprimer des instances principales (établissements, entreprises, ONG)
- Navigation vers les sous-instances d'une instance
- Export des données par instance (JSON et CSV)

### Gestion des Sous-Instances
- Créer, modifier et supprimer des sous-instances (salles de classe, départements, bureaux)
- Navigation vers les personnes d'une sous-instance
- Export des données par sous-instance (JSON et CSV)

### Gestion des Personnes
- Formulaire multi-étapes pour l'enregistrement des personnes
- Capture de photos avec la caméra ou sélection depuis la galerie
- Stockage des informations personnelles, structure, fonction, matricule, niveau, filière
- Export des données par personne (JSON et CSV)

### Export et Import
- Export global de toutes les données
- Export par instance
- Export par sous-instance
- Formats supportés : JSON et CSV
- Stockage local des fichiers d'export

## 🏗️ Architecture

### Structure du Projet
```
lib/
├── core/                    # Utilitaires communs
│   ├── constants/          # Constantes de l'application
│   ├── navigation/         # Configuration du routeur
│   ├── providers/          # Providers Riverpod
│   ├── services/           # Services (export, images)
│   └── theme/              # Thèmes de l'application
├── features/               # Fonctionnalités par domaine
│   ├── instances/          # Gestion des instances
│   ├── sub_instances/      # Gestion des sous-instances
│   └── persons/            # Gestion des personnes
└── main.dart               # Point d'entrée de l'application
```

### Technologies Utilisées
- **Flutter 3.x** avec Material 3
- **GoRouter** pour la navigation
- **Riverpod** pour la gestion d'état
- **Hive** pour le stockage local offline-first
- **Image Picker** pour la capture de photos
- **Path Provider** pour l'accès aux fichiers

## 📱 Installation

### Prérequis
- Flutter SDK 3.x
- Dart SDK
- Android Studio / VS Code
- Émulateur Android ou appareil physique

### Étapes d'Installation

1. **Cloner le projet**
   ```bash
   git clone <repository-url>
   cd collectionneur
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Générer le code (IMPORTANT !)**
   ```bash
   flutter packages pub run build_runner build
   ```
   
   **Note** : Cette commande génère les adaptateurs Hive et les providers Riverpod. Elle doit être exécutée après chaque modification des modèles.

4. **Lancer l'application**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Permissions Android
L'application nécessite les permissions suivantes dans `android/app/src/main/AndroidManifest.xml` :
- `CAMERA` : Pour prendre des photos
- `READ_EXTERNAL_STORAGE` : Pour accéder à la galerie
- `WRITE_EXTERNAL_STORAGE` : Pour sauvegarder les photos

### Permissions iOS
Dans `ios/Runner/Info.plist` :
- `NSCameraUsageDescription` : Description de l'utilisation de la caméra
- `NSPhotoLibraryUsageDescription` : Description de l'utilisation de la galerie

## 📊 Structure de la Base de Données

### Modèles Hive

#### Instance
```dart
class Instance {
  int id;
  String nom;
  DateTime dateCreation;
  String? description;
}
```

#### SubInstance
```dart
class SubInstance {
  int id;
  int instanceId;  // Référence vers Instance
  String nom;
  DateTime dateCreation;
  String? description;
}
```

#### Person
```dart
class Person {
  int id;
  int subInstanceId;  // Référence vers SubInstance
  String nom;
  String prenom;
  String contact;
  String? photoPath;  // Chemin local de la photo
  DateTime dateCreation;
  String? notes;
}
```

## 🎯 Utilisation

### Créer une Instance
1. Sur la page d'accueil, appuyer sur le bouton "+"
2. Remplir le nom et la description (optionnelle)
3. Valider la création

### Ajouter une Sous-Instance
1. Cliquer sur une instance pour accéder à ses sous-instances
2. Appuyer sur le bouton "+"
3. Remplir le nom et la description
4. Valider la création

### Enregistrer une Personne
1. Cliquer sur une sous-instance pour accéder à ses personnes
2. Appuyer sur le bouton "+"
3. Suivre les étapes du formulaire :
   - **Étape 1** : Informations personnelles (nom, prénom)
   - **Étape 2** : Contact et notes
   - **Étape 3** : Photo (caméra ou galerie)
   - **Étape 4** : Résumé et validation

### Exporter les Données
1. Utiliser le bouton d'export (📥) dans la barre d'action
2. Choisir le format (JSON ou CSV)
3. Sélectionner la portée (global, par instance, par sous-instance)
4. Les fichiers sont sauvegardés dans le dossier d'export de l'application

## 🚀 Déploiement

### Build de Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Configuration de Production
- Désactiver le mode debug
- Optimiser les images
- Configurer les permissions appropriées
- Tester sur appareils physiques

## 🐛 Dépannage

### Problèmes Courants

#### Erreur "Target of URI hasn't been generated"
**Solution** : Exécuter `flutter packages pub run build_runner build`

#### Erreur "Hive adapter not found"
**Solution** : Vérifier que les adaptateurs sont bien enregistrés dans `main.dart`

#### Photos qui ne s'affichent pas
**Solution** : Vérifier les permissions de stockage et les chemins d'accès

#### Erreur de navigation
**Solution** : Vérifier la configuration de GoRouter dans `app_router.dart`

### Logs et Debug
```bash
# Activer les logs détaillés
flutter run --verbose

# Analyser le code
flutter analyze

# Nettoyer le projet
flutter clean
flutter pub get
```

## 🤝 Contribution

### Guidelines
1. Suivre l'architecture feature-first
2. Utiliser les conventions de nommage Dart/Flutter
3. Ajouter des tests pour les nouvelles fonctionnalités
4. Documenter le code avec des commentaires clairs

### Workflow
1. Créer une branche pour la fonctionnalité
2. Développer et tester
3. Créer une pull request
4. Code review et merge

## 📄 Licence

Ce projet est sous licence [MIT](LICENSE).

## 📞 Support

Pour toute question ou problème :
- Créer une issue sur GitHub
- Consulter la documentation Flutter
- Vérifier les logs de l'application

---

**Développé avec ❤️ en Flutter**
"# Quick-ID" 
