import 'package:otoscopia/src/core/core.dart';

abstract class FetchDataRepository {
  Future<List<SchoolEntity>> getSchools();

  Future<List<SchoolEntity>> getUnAssignedSchools();

  Future<List<AssignmentEntity>> getAssignments();

  Future<List<AssignmentEntity>> getAssignmentsByNurse(String user);

  Future<List<PatientEntity>> getPatientsBySchools(List<String> schools);

  Future<List<PatientEntity>> getPatientsByDoctor(String id);

  Future<List<UserEntity>> getDoctors();

  Future<List<UserEntity>> getNurses();

  Future<List<ScreeningEntity>> getScreeningsByPatient(List<String> patients);

  Future<List<RemarksEntity>> getRemarksByPatients(List<String> screening);

  Future<ScreeningEntity> getScreeningsByPatientId(String patients);

  Future<List<RemarksEntity>> getRemarksByScreening(String screening);
}
