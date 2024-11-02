import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'patients_provider.g.dart';

@Riverpod(keepAlive: true)
class Patients extends _$Patients {
  @override
  List<PatientEntity> build() {
    return [];
  }

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
