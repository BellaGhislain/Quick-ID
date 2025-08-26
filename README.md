# Quick-ID - Application de gestion d'identités

## 🎯 Description

Quick-ID est une application Flutter de gestion d'identités avec stockage offline-first, conçue pour gérer des structures organisationnelles hiérarchiques. L'application distingue maintenant deux types de personnes : **Étudiants** et **Employés**.

## 🏗️ Architecture des données

### Structure hiérarchique

1. **Instances** - Niveau principal (ex: entreprises, écoles, organisations)
2. **Sub-Instances** - Sous-niveaux (ex: départements, filiales, classes)
3. **Persons** - Personnes avec informations détaillées selon le type

### Types de personnes

#### 🎓 **Étudiants** (pour les écoles)

- **Champs obligatoires :**
  - Nom et Prénom
  - Matricule
  - Filière
- **Champs pré-remplis :**
  - Niveau (automatiquement rempli avec le nom de la sub-instance)

#### 💼 **Employés** (pour les entreprises)

- **Champs obligatoires :**
  - Nom et Prénom
  - Fonction
  - Matricule
- **Champs pré-remplis :**
  - Structure (automatiquement rempli avec le nom de la sub-instance)

## ✨ Fonctionnalités principales

### 🔍 **Sélection intelligente du type**

- Choix entre Étudiant et Employé lors de l'ajout d'une personne
- Interface adaptée selon le type sélectionné
- Pré-remplissage automatique des champs appropriés

### 📱 **Interface adaptative**

- Formulaires différents selon le type de personne
- Validation adaptée aux champs obligatoires
- Affichage des informations pertinentes

### 🖼️ **Gestion des photos**

- Photo obligatoire pour tous les types
- Prise de photo intégrée
- Sélection depuis la galerie
- Stockage local optimisé

### 🔍 **Filtrage et recherche**

- Filtrage par type de personne
- Vue d'ensemble claire avec badges de type
- Export sélectif selon les filtres

### 📊 **Export des données**

- Export en CSV
- Export en Excel
- Filtrage par type lors de l'export

## 🛠️ Technologies utilisées

- **Flutter** avec SDK 3.8.1
- **Riverpod** pour la gestion d'état
- **Hive** pour la base de données locale
- **Go Router** pour la navigation
- **Image Picker** pour la gestion des photos

## 🚀 Installation et utilisation

### Prérequis

- Flutter SDK 3.8.1+
- Dart SDK compatible

### Installation

```bash
# Cloner le projet
git clone [url-du-projet]

# Installer les dépendances
flutter pub get

# Générer le code Hive
flutter packages pub run build_runner build

# Lancer l'application
flutter run
```

## 📱 Utilisation

### 1. Créer une instance

- Créez une instance principale (ex: "École ABC" ou "Entreprise XYZ")

### 2. Créer une sub-instance

- Créez une sub-instance (ex: "Classe 3ème A" ou "Département Marketing")

### 3. Ajouter des personnes

- Choisissez le type : Étudiant ou Employé
- Remplissez les informations requises
- Prenez ou sélectionnez une photo
- Validez et enregistrez

### 4. Gérer et filtrer

- Consultez la liste des personnes
- Filtrez par type
- Modifiez ou supprimez des entrées
- Exportez les données

## 🔧 Configuration

### Génération de code

```bash
# Générer les adaptateurs Hive
flutter packages pub run build_runner build

# Surveiller les changements
flutter packages pub run build_runner watch
```

### Icônes et splash screen

```bash
# Générer les icônes
flutter packages pub run flutter_launcher_icons:main

# Générer le splash screen
flutter packages pub run flutter_native_splash:create
```

## 📁 Structure du projet

```
lib/
├── core/
│   ├── constants/          # Constantes de l'application
│   ├── navigation/         # Configuration du routeur
│   ├── providers/          # Providers Riverpod
│   ├── services/           # Services (export, image, etc.)
│   ├── theme/              # Thèmes et styles
│   └── pages/              # Pages communes
├── features/
│   ├── instances/          # Gestion des instances
│   ├── sub_instances/      # Gestion des sub-instances
│   └── persons/            # Gestion des personnes
│       ├── models/         # Modèles de données
│       ├── repositories/   # Accès aux données
│       └── presentation/   # Interface utilisateur
└── main.dart               # Point d'entrée
```

## 🎨 Personnalisation

### Couleurs

- **Étudiants** : Vert (#4CAF50)
- **Employés** : Bleu (#2196F3)
- **Thème principal** : Rouge (#CA1B49)

### Thèmes

- Support des thèmes clair et sombre
- Adaptation automatique selon les préférences système

## 📋 Fonctionnalités à venir

- [ ] Synchronisation cloud
- [ ] Gestion des groupes
- [ ] Statistiques et rapports
- [ ] Notifications push
- [ ] Support multi-langues

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :

- Signaler des bugs
- Proposer des améliorations
- Soumettre des pull requests

## 📄 Licence

Ce projet est sous licence privée. Tous droits réservés.

---

**Quick-ID** - Gestion intelligente des identités 🚀
