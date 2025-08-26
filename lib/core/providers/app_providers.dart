import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/instances/models/instance.dart';
import '../../features/instances/repositories/instance_repository.dart';
import '../../features/persons/models/person.dart';
import '../../features/persons/repositories/person_repository.dart';
import '../../features/sub_instances/models/sub_instance.dart';
import '../../features/sub_instances/repositories/sub_instance_repository.dart';

// Repository providers
final instanceRepositoryProvider = Provider<InstanceRepository>((ref) {
  return InstanceRepository();
});

final subInstanceRepositoryProvider = Provider<SubInstanceRepository>((ref) {
  return SubInstanceRepository();
});

final personRepositoryProvider = Provider<PersonRepository>((ref) {
  return PersonRepository();
});

// State providers
final instancesProvider = StateNotifierProvider<InstancesNotifier, AsyncValue<List<Instance>>>((
  ref,
) {
  return InstancesNotifier(ref.read(instanceRepositoryProvider));
});

final subInstancesProvider =
    StateNotifierProvider<SubInstancesNotifier, AsyncValue<List<SubInstance>>>((ref) {
      return SubInstancesNotifier(ref.read(subInstanceRepositoryProvider));
    });

final personsProvider = StateNotifierProvider<PersonsNotifier, AsyncValue<List<Person>>>((ref) {
  return PersonsNotifier(ref.read(personRepositoryProvider));
});

// Filtered providers
final subInstancesByInstanceProvider =
    StateNotifierProvider.family<
      SubInstancesByInstanceNotifier,
      AsyncValue<List<SubInstance>>,
      int
    >((ref, instanceId) {
      return SubInstancesByInstanceNotifier(ref.read(subInstanceRepositoryProvider), instanceId);
    });

final personsBySubInstanceProvider =
    StateNotifierProvider.family<PersonsBySubInstanceNotifier, AsyncValue<List<Person>>, int>((
      ref,
      subInstanceId,
    ) {
      return PersonsBySubInstanceNotifier(ref.read(personRepositoryProvider), subInstanceId);
    });

// Notifiers
class InstancesNotifier extends StateNotifier<AsyncValue<List<Instance>>> {
  final InstanceRepository _repository;

  InstancesNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadInstances() async {
    try {
      state = const AsyncValue.loading();
      final instances = await _repository.getAllInstances();
      state = AsyncValue.data(instances);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addInstance(Instance instance) async {
    try {
      await _repository.addInstance(instance);
      await loadInstances();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateInstance(Instance instance) async {
    try {
      await _repository.updateInstance(instance);
      await loadInstances();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteInstance(int id) async {
    try {
      await _repository.deleteInstance(id);
      await loadInstances();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class SubInstancesNotifier extends StateNotifier<AsyncValue<List<SubInstance>>> {
  final SubInstanceRepository _repository;

  SubInstancesNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadSubInstances() async {
    try {
      state = const AsyncValue.loading();
      final subInstances = await _repository.getAllSubInstances();
      state = AsyncValue.data(subInstances);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addSubInstance(SubInstance subInstance) async {
    try {
      await _repository.addSubInstance(subInstance);
      await loadSubInstances();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateSubInstance(SubInstance subInstance) async {
    try {
      await _repository.updateSubInstance(subInstance);
      await loadSubInstances();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteSubInstance(int id) async {
    try {
      await _repository.deleteSubInstance(id);
      await loadSubInstances();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class SubInstancesByInstanceNotifier extends StateNotifier<AsyncValue<List<SubInstance>>> {
  final SubInstanceRepository _repository;
  final int _instanceId;

  SubInstancesByInstanceNotifier(this._repository, this._instanceId)
    : super(const AsyncValue.loading());

  Future<void> loadSubInstances() async {
    try {
      state = const AsyncValue.loading();
      final subInstances = await _repository.getSubInstancesByInstanceId(_instanceId);
      state = AsyncValue.data(subInstances);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addSubInstance(SubInstance subInstance) async {
    try {
      await _repository.addSubInstance(subInstance);
      await loadSubInstances();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateSubInstance(SubInstance subInstance) async {
    try {
      await _repository.updateSubInstance(subInstance);
      await loadSubInstances();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteSubInstance(int id) async {
    try {
      await _repository.deleteSubInstance(id);
      await loadSubInstances();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class PersonsNotifier extends StateNotifier<AsyncValue<List<Person>>> {
  final PersonRepository _repository;

  PersonsNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadPersons() async {
    try {
      state = const AsyncValue.loading();
      final persons = await _repository.getAllPersons();
      state = AsyncValue.data(persons);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addPerson(Person person) async {
    try {
      await _repository.addPerson(person);
      await loadPersons();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePerson(Person person) async {
    try {
      await _repository.updatePerson(person);
      await loadPersons();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deletePerson(int id) async {
    try {
      await _repository.deletePerson(id);
      await loadPersons();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class PersonsBySubInstanceNotifier extends StateNotifier<AsyncValue<List<Person>>> {
  final PersonRepository _repository;
  final int _subInstanceId;

  PersonsBySubInstanceNotifier(this._repository, this._subInstanceId)
    : super(const AsyncValue.loading());

  Future<void> loadPersons() async {
    try {
      state = const AsyncValue.loading();
      final persons = await _repository.getPersonsBySubInstanceId(_subInstanceId);
      state = AsyncValue.data(persons);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addPerson(Person person) async {
    try {
      await _repository.addPerson(person);
      await loadPersons();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePerson(Person person) async {
    try {
      await _repository.updatePerson(person);
      await loadPersons();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deletePerson(int id) async {
    try {
      await _repository.deletePerson(id);
      await loadPersons();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
