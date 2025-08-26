# Copilot Instructions for Quick-ID

## Project Overview
- **Quick-ID** is a Flutter (Dart) offline-first identity management app.
- The architecture is feature-first: `lib/features/` for domain logic, `lib/core/` for shared utilities/services.
- Data is stored locally using Hive. State management uses Riverpod. Navigation is via GoRouter.
- Images are handled with Image Picker and stored using Path Provider.

## Key Directories & Files
- `lib/core/services/`: Shared services (e.g., `image_service.dart`, `export_service.dart`, `download_service.dart`).
- `lib/features/instances/`, `sub_instances/`, `persons/`: Main app domains, each with models, pages, and widgets.
- `main.dart`: App entry point, initializes providers, adapters, and routing.
- `pubspec.yaml`: Declares dependencies and assets.

## Developer Workflows
- **Install dependencies:** `flutter pub get`
- **Code generation:** `flutter packages pub run build_runner build` (run after model/provider changes)
- **Run app:** `flutter run`
- **Build release:** `flutter build apk --release` (Android), `flutter build ios --release` (iOS)
- **Analyze:** `flutter analyze`
- **Clean:** `flutter clean` then `flutter pub get`

## Patterns & Conventions
- **Feature-first:** Each domain (instance, sub-instance, person) is isolated in its own folder.
- **Multi-step forms:** Person registration uses a stepper with validation at each step.
- **Export/Import:** Data export is available at global, instance, and sub-instance levels. Files are saved locally (see `download_service.dart`).
- **Permissions:** Android/iOS permissions for camera, storage, and gallery are required (see README for details).
- **Error handling:** User-facing errors use `SnackBar`. Service errors are logged with `print`.
- **Code generation:** Hive adapters and Riverpod providers are generated; always run build_runner after model changes.

## Integration Points
- **Hive:** All models are Hive objects; adapters are generated and registered in `main.dart`.
- **Riverpod:** Providers are defined in `lib/core/providers/` and injected throughout features.
- **GoRouter:** Routing is configured in `lib/core/navigation/`.
- **Image Picker/Path Provider:** Used in `image_service.dart` for photo capture and storage.

## Examples
- To add a new export format, extend `export_service.dart` and update UI actions in feature pages.
- To add a new field to a model, update the model, run build_runner, and update forms/UI accordingly.

## Troubleshooting
- If you see "Target of URI hasn't been generated" or missing adapters, re-run build_runner.
- If images don't display, check permissions and file paths.
- For navigation issues, review GoRouter setup.

Refer to `README.md` for more details and workflow examples.
