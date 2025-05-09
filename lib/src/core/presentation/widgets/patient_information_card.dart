import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';

class PatientInformationCard extends ConsumerWidget {
  const PatientInformationCard(this._patient, {super.key});
  final PatientEntity _patient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDoctor = ref.read(userProvider)!.isDoctor;
    final isNurse = ref.read(userProvider)!.isNurse;

    final name = _patient.name;
    final age = DateTime.now().difference(_patient.birthDate).inDays ~/ 365;
    final gender = _patient.gender == Gender.male ? kGenders[0] : kGenders[1];
    final guardian = _patient.guardian;
    final guardianPhone = _patient.guardianPhone;
    final school = ref.read(schoolsProvider.notifier).findById(_patient.school);
    final doctor = _patient.doctor;
    final code = _patient.code;
    final assignment = ref
        .read(assignmentsProvider.notifier)
        .findBySchool(_patient.school);
    final nurse = ref.read(nursesProvider.notifier).findById(assignment.nurse);

    return CardOpacity(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: double.infinity),
          CustomText(name, style: 1),
          CustomText("$age/$gender", style: 3),
          CustomText("$guardian, $guardianPhone", style: 3),
          CustomText(school.name, style: 3),
          if (isDoctor)
            CustomText("$kAssignedNurse ${nurse.readableName}", style: 3),
          if (isNurse)
            CustomText(
              "$kAssignedDoctor ${doctor?['readable_name']}",
              style: 3,
            ),
          CustomText("$kPatientCode $code", style: 3),
        ],
      ),
    );
  }
}
