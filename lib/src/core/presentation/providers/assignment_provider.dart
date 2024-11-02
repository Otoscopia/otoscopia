import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'assignment_provider.g.dart';

@Riverpod(keepAlive: true)
class Assignments extends _$Assignments {
  @override
  List<AssignmentEntity> build() {
    return [];
  }

  void setAssignments(List<AssignmentEntity> assignments) {
    state = assignments;
  }

  AssignmentEntity findByNurseAndSchool(String nurse, String school) {
    return state.firstWhere((assignment) {
      return assignment.nurse == nurse &&
          assignment.school == school &&
          assignment.isActive == true;
    });
  }

  AssignmentEntity findById(String id) {
    return state.firstWhere(
        (assignment) => assignment.id == id && assignment.isActive == true);
  }

  AssignmentEntity findBySchool(String school) {
    return state.firstWhere((assignment) =>
        assignment.school == school && assignment.isActive == true);
  }
}
