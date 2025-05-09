import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/nurse/nurse.dart';

part 'patient_provider.g.dart';

@Riverpod(keepAlive: true)
class Patient extends _$Patient {
  @override
  PatientEntity? build() {
    return null;
  }

  void setPatient(WidgetRef ref, PatientFormEntity form, bool hasValue) {
    final user = ref.read(userProvider)!;
    final doctors = ref.read(doctorsProvider);
    final school = ref.read(schoolsProvider.notifier).findByName(form.school);
    form.schoolController.text = school.id;
    if (hasValue) {
      state = PatientEntity.copyFromForm(state!, form);
    } else {
      state = PatientEntity.fromFormEntity(form, user.uid, doctors);
    }
  }

  void resetInformation() {
    state = null;
  }
}
