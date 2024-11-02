import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/authentication/authentication.dart';

part 'fetch_data_provider.g.dart';

@Riverpod(keepAlive: true)
class FetchData extends _$FetchData {
  static final FetchDataDataSource _source = FetchDataDataSource();
  static final FetchImageDataSource _imageSource = FetchImageDataSource();
  final FetchDataRepository _repository = FetchDataRepositoryImpl(_source);
  final FetchImageRepository _imageRepository =
      FetchImageRepositoryImpl(_imageSource);

  @override
  void build() {
    return;
  }

  Future<void> getSchools() async {
    try {
      final result = await _repository.getSchools();
      ref.read(schoolsProvider.notifier).setSchools(result);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> getUnAssignedSchools() async {
    try {
      final result = await _repository.getUnAssignedSchools();
      ref.read(schoolsProvider.notifier).setSchools(result);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> getAssignments() async {
    try {
      final result = await _repository.getAssignments();
      ref.read(assignmentsProvider.notifier).setAssignments(result);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> getAssignmentsByNurse(UserEntity user) async {
    try {
      final result = await _repository.getAssignmentsByNurse(user.id);
      ref.read(assignmentsProvider.notifier).setAssignments(result);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> getPatientsBySchools() async {
    final schools =
        ref.read(schoolsProvider).map((school) => school.id).toList();
    try {
      final result = await _repository.getPatientsBySchools(schools);
      ref.read(patientsProvider.notifier).setPatients(result);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> getPatientsByDoctor(String id) async {
    try {
      final result = await _repository.getPatientsByDoctor(id);
      ref.read(patientsProvider.notifier).setPatients(result);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> getDoctors() async {
    try {
      final result = await _repository.getDoctors();
      ref.read(doctorsProvider.notifier).setDoctors(result);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> getNurses() async {
    try {
      final result = await _repository.getNurses();
      ref.read(nursesProvider.notifier).setNurses(result);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> getScreeningsByPatient() async {
    final patients = ref.read(patientsProvider).map((e) => e.id).toList();
    try {
      final result = await _repository.getScreeningsByPatient(patients);
      ref.read(screeningsProvider.notifier).setScreenings(result);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> getRemarksByPatients() async {
    final screenings = ref.read(screeningsProvider).map((e) => e.id).toList();
    try {
      final result = await _repository.getRemarksByPatients(screenings);
      ref.read(remarksProvider.notifier).setRemarks(result);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<ScreeningEntity> getScreeningsByPatientId(String id) async {
    try {
      final result = await _repository.getScreeningsByPatientId(id);
      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<RemarksEntity>> getRemarks(String screening) async {
    try {
      final result = await _repository.getRemarksByScreening(screening);
      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<Uint8List>> getImages(String path, List<String> ids) async {
    try {
      final result = await _imageRepository.getImages(path, ids);
      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<PrescriptionEntity>> getPrescription(List<String> ids) async {
    try {
      final result = await _imageRepository.getPrescription(ids);
      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> downloadPrescription(PrescriptionEntity prescription) async {
    try {
      await _imageRepository.downloadPrescription(prescription);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> setTableData() async {
    final patients = ref.read(patientsProvider);
    final screenings = ref.read(screeningsProvider);
    final remarks = ref.read(remarksProvider);
    ref.read(tableProvider.notifier).setTable(patients, screenings, remarks);
  }

  Future<void> filterSchoolsByUser(UserEntity user) async {
    final schools = ref.read(schoolsProvider);
    final assignments = ref.read(assignmentsProvider);
    final filteredSchools = schools.where((school) {
      return assignments.where((assignment) {
        return assignment.school == school.id;
      }).isNotEmpty;
    }).toList();
    ref.read(schoolsProvider.notifier).setSchools(filteredSchools);
  }

  Future<void> setSearchData() async {
    List<SearchEntity> data = [];
    final patients = ref.read(patientsProvider);
    final schools = ref.read(schoolsProvider);
    final doctors = ref.read(doctorsProvider);
    final nurses = ref.read(nursesProvider);

    data.addAll([
      ...patients
          .map((e) => SearchEntity(name: e.name, role: SearchRole.patient)),
      ...schools
          .map((e) => SearchEntity(name: e.name, role: SearchRole.schools)),
      ...doctors
          .map((e) => SearchEntity(name: e.name, role: SearchRole.doctor)),
      ...nurses.map((e) => SearchEntity(name: e.name, role: SearchRole.nurse)),
    ]);

    ref.read(searchProvider.notifier).addList(data);
  }

  Future<void> fetch(UserEntity user) async {
    if (user.role == UserRole.admin) {
      // User Admin Fetch
    } else {
      await getSchools();
      await getDoctors();
      await getNurses();

      if (user.role == UserRole.nurse) {
        await getAssignmentsByNurse(user);
        await filterSchoolsByUser(user);
        await getPatientsBySchools();
      } else {
        await getAssignments();
        await getPatientsByDoctor(user.id);
      }
      await getScreeningsByPatient();
      await getRemarksByPatients();
      await setTableData();

      await setSearchData();
    }
  }
}

@Riverpod(keepAlive: true)
class Remarks extends _$Remarks {
  @override
  List<RemarksEntity> build() {
    return [];
  }

  setRemarks(List<RemarksEntity> remarks) => state = remarks;
}
