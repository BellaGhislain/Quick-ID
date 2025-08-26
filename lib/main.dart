import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/navigation/app_router.dart';
import 'core/providers/app_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/instances/models/instance.dart';
import 'features/instances/repositories/instance_repository.dart';
import 'features/persons/models/person.dart';
import 'features/persons/repositories/person_repository.dart';
import 'features/sub_instances/models/sub_instance.dart';
import 'features/sub_instances/repositories/sub_instance_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(InstanceAdapter());
  Hive.registerAdapter(SubInstanceAdapter());
  Hive.registerAdapter(PersonAdapter());

  // Initialize repositories
  final instanceRepo = InstanceRepository();
  final subInstanceRepo = SubInstanceRepository();
  final personRepo = PersonRepository();

  await instanceRepo.initialize();
  await subInstanceRepo.initialize();
  await personRepo.initialize();

  runApp(
    ProviderScope(
      overrides: [
        instanceRepositoryProvider.overrideWithValue(instanceRepo),
        subInstanceRepositoryProvider.overrideWithValue(subInstanceRepo),
        personRepositoryProvider.overrideWithValue(personRepo),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Quick ID',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
