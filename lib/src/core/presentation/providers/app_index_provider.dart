import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'app_index_provider.g.dart';

@Riverpod(keepAlive: true)
class AppIndex extends _$AppIndex {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }

  void visitPatient(PatientEntity patient) {
    state = 1;
    ref.read(patientsTabProvider.notifier).addTab(patient);
  }
}
