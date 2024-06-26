import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';

class PatientsNotifier extends StateNotifier<List<PatientEntity>> {
  PatientsNotifier() : super([]);

  void setPatients(List<PatientEntity> patients) {
    patients.sort((a, b) => a.name.compareTo(b.name));
    state = patients;
  }

  void removePatient(int index) => state.removeAt(index);

  void addPatient(PatientEntity patient) {
    final index = state.indexWhere((element) => element.id == patient.id);
    if (index >= 0) {
      removePatient(index);
    }

    state = [...state, patient];
  }

  List<PatientEntity> findByDoctorId(String doctorId) {
    final patients = state.where((patient) => patient.creator == doctorId);
    return patients.toList();
  }

  List<PatientEntity> findBySchoolId(String schoolId) {
    final patients = state.where((patient) => patient.school == schoolId);
    return patients.toList();
  }

  PatientEntity findById(String id) {
    final patient = state.firstWhere((patient) => patient.id == id);
    return patient;
  }

  PatientEntity? findByName(String name) {
    final patient = state.firstWhereOrNull((patient) => patient.name == name);
    return patient;
  }
}

final patientsProvider =
    StateNotifierProvider<PatientsNotifier, List<PatientEntity>>(
  (ref) => PatientsNotifier(),
);
