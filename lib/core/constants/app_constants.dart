class AppConstants {
  // Database
  static const String instanceBoxName = 'instances';
  static const String subInstanceBoxName = 'sub_instances';
  static const String personBoxName = 'persons';

  // Image storage
  static const String imageDirectory = 'quick_id_images';

  // Export
  static const String exportDirectory = 'quick_id_exports';

  // Navigation
  static const String homeRoute = '/';
  static const String instancesRoute = '/instances';
  static const String subInstancesRoute = '/sub-instances';
  static const String personsRoute = '/persons';
  static const String addPersonRoute = '/add-person';
  static const String editPersonRoute = '/edit-person';

  // Form steps
  static const int personalInfoStep = 0;
  static const int contactStep = 1;
  static const int photoStep = 2;
  static const int summaryStep = 3;
}
