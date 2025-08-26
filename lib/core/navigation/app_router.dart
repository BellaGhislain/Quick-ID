import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/instances/presentation/pages/instances_page.dart';
import '../../features/persons/models/person.dart';
import '../../features/persons/presentation/pages/add_person_page.dart';
import '../../features/persons/presentation/pages/edit_person_page.dart';
import '../../features/persons/presentation/pages/persons_page.dart';
import '../../features/sub_instances/presentation/pages/sub_instances_page.dart';
import '../constants/app_constants.dart';
import '../pages/about_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppConstants.homeRoute,
  routes: [
    GoRoute(
      path: AppConstants.homeRoute,
      name: 'home',
      builder: (context, state) => const InstancesPage(),
    ),
    GoRoute(
      path: AppConstants.instancesRoute,
      name: 'instances',
      builder: (context, state) => const InstancesPage(),
    ),
    GoRoute(
      path: '${AppConstants.subInstancesRoute}/:instanceId',
      name: 'subInstances',
      builder: (context, state) {
        final instanceId = int.parse(state.pathParameters['instanceId']!);
        return SubInstancesPage(instanceId: instanceId);
      },
    ),
    GoRoute(
      path: '${AppConstants.personsRoute}/:subInstanceId',
      name: 'persons',
      builder: (context, state) {
        final subInstanceId = int.parse(state.pathParameters['subInstanceId']!);
        return PersonsPage(subInstanceId: subInstanceId);
      },
    ),
    GoRoute(
      path: '${AppConstants.addPersonRoute}/:subInstanceId',
      name: 'addPerson',
      builder: (context, state) {
        final subInstanceId = int.parse(state.pathParameters['subInstanceId']!);
        final typeParam = state.uri.queryParameters['type'];
        PersonType? personType;
        if (typeParam != null) {
          personType = PersonType.values.firstWhere(
            (e) => e.name == typeParam,
            orElse: () => PersonType.etudiant,
          );
        }
        return AddPersonPage(
          subInstanceId: subInstanceId,
          personType: personType,
        );
      },
    ),
    GoRoute(
      path: '/edit-person/:personId',
      name: 'editPerson',
      builder: (context, state) {
        final personId = int.parse(state.pathParameters['personId']!);
        return EditPersonPage(personId: personId);
      },
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page non trouvée')),
    body: const Center(child: Text('La page demandée n\'existe pas.')),
  ),
);
