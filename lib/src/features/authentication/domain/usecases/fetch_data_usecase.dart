import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/authentication/authentication.dart';

class FetchDataUseCase {
  final FetchDataRepository _fetchDataRepository;

  FetchDataUseCase(this._fetchDataRepository);

  Future<List<SchoolEntity>> getSchools() async {
    return await _fetchDataRepository.getSchools();
  }

  Future<List<SchoolEntity>> getUnAssignedSchools() async {
    return await _fetchDataRepository.getUnAssignedSchools();
  }

  Future<List<AssignmentEntity>> getAssignments() async {
    return await _fetchDataRepository.getAssignments();
  }

  Future<List<AssignmentEntity>> getAssignmentsByNurse(String user) async {
    return await _fetchDataRepository.getAssignmentsByNurse(user);
  }

  Future<List<PatientEntity>> getPatientsBySchools(List<String> schools) async {
    return await _fetchDataRepository.getPatientsBySchools(schools);
  }

  Future<List<PatientEntity>> getPatientsByDoctor(String id) async {
    return await _fetchDataRepository.getPatientsByDoctor(id);
  }

  Future<List<UserEntity>> getDoctors() async {
    return await _fetchDataRepository.getDoctors();
  }

  Future<List<UserEntity>> getNurses() async {
    return await _fetchDataRepository.getNurses();
  }

  Future<List<ScreeningEntity>> getScreeningsByPatient(
    List<String> patients,
  ) async {
    return await _fetchDataRepository.getScreeningsByPatient(patients);
  }

  Future<List<RemarksEntity>> getRemarksByScreening(String screening) async {
    return await _fetchDataRepository.getRemarksByScreening(screening);
  }
}
