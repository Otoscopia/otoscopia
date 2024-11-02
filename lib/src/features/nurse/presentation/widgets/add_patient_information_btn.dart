import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/nurse/nurse.dart';

class AddPatientInformationBtn extends ConsumerWidget {
  const AddPatientInformationBtn(this._form, {super.key});

  final PatientFormEntity _form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool hasValue = ref.read(patientProvider) != null;

    return FilledButton(
      onPressed: () {
        bool isValid = _form.isValid;

        if (!isValid) {
          popUpInfoBar(
            kErrorTitle,
            kErrorMessage,
            context,
            barSeverity: InfoBarSeverity.warning,
          );
          return;
        }

        ref.read(patientProvider.notifier).setPatient(ref, _form, hasValue);
        ref.read(addPatientTabProvider.notifier).addLeftCamera();
      },
      child: Text(hasValue ? kUpdateBtn : kContinueBtn),
    );
  }
}
