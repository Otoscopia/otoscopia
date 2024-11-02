import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/nurse/nurse.dart';

class ScreeningInformationScreen extends ConsumerStatefulWidget {
  const ScreeningInformationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScreeningInformationScreenState();
}

class _ScreeningInformationScreenState
    extends ConsumerState<ScreeningInformationScreen> {
  MedicalFormEntity medical = MedicalFormEntity();

  @override
  Widget build(BuildContext context) {
    return DoubleCard(
      scroll: true,
      child: Column(
        children: [
          TextFormInput(
            kHistoryOfIllness,
            medical.historyOfIllnessController,
            maxLines: 5,
          ),
          const Gap(16),
          InfoLabel(
            label: kRemarks,
            child: TextFormBox(
              controller: medical.remarksController,
              minLines: 1,
              maxLines: 5,
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormInput(
                  kTemperature,
                  medical.temperatureController,
                  isTemperature: true,
                  maxLength: 4,
                  suffix: const Text("°C"),
                ),
              ),
              const Gap(16),
              Expanded(
                child: TextFormInput(
                  kHeight,
                  medical.heightController,
                  booleanFilter: true,
                  maxLength: 5,
                  suffix: const Text("cm"),
                ),
              ),
              const Gap(16),
              Expanded(
                child: TextFormInput(
                  kWeight,
                  medical.weightController,
                  booleanFilter: true,
                  maxLength: 4,
                  suffix: const Text("kg"),
                ),
              ),
            ],
          ),
          const Gap(16),
          ChiefComplains(
            medical.chiefComplains,
            medical.chiefComplainsRemarksController,
          ),
          const Gap(16),
          YesNoRadio(
            kSimilarCondition,
            medical.similarCondition,
            onChanged: (value) =>
                setState(() => medical.similarCondition = value),
          ),
          const Gap(16),
          YesNoRadioInput(
            radioLabel: kAllergy,
            value: medical.allergy,
            inputLabel: kAllergyRemarks,
            controller: medical.allergyRemarksController,
            onChanged: (value) => setState(() => medical.allergy = value),
          ),
          const Gap(16),
          YesNoRadioInput(
            radioLabel: kSurgicalProcedure,
            value: medical.undergoneSurgery,
            inputLabel: kSurgicalProcedureRemarks,
            controller: medical.undergoneSurgeryRemarksController,
            onChanged: (value) =>
                setState(() => medical.undergoneSurgery = value),
          ),
          const Gap(16),
          YesNoRadioInput(
            radioLabel: kMedication,
            value: medical.medication,
            inputLabel: kMedicationRemarks,
            controller: medical.medicationRemarksController,
            onChanged: (value) => setState(() => medical.medication = value),
          ),
          const Gap(16),
          ScreeningInformationBtn(medical: medical),
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();
    final screening = ref.read(screeningInformationProvider);

    if (screening != null) {
      MedicalFormEntity medicalForm = MedicalFormEntity.fromScreeningEntity(
        screening,
      );
      medical = medicalForm;
    }
  }
}
