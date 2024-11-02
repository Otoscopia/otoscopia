import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'schools_provider.g.dart';

@Riverpod(keepAlive: true)
class Schools extends _$Schools {
  @override
  List<SchoolEntity> build() {
    return [];
  }

  void setSchools(List<SchoolEntity> schools) {
    schools.sort((a, b) => a.name.compareTo(b.name));
    state = schools;
  }

  SchoolEntity findByName(String name) {
    final SchoolEntity school =
        state.firstWhere((school) => school.name == name);
    return school;
  }

  SchoolEntity findById(String id) {
    final SchoolEntity school = state.firstWhere((school) => school.id == id);
    return school;
  }
}
