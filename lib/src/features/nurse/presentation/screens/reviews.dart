import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/nurse/nurse.dart';

class Reviews extends ConsumerStatefulWidget {
  const Reviews({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReviewsState();
}

class _ReviewsState extends ConsumerState<Reviews> {
  bool isUploading = false;
  bool isPatientUploading = false;
  bool isScreeningUploading = false;

  @override
  Widget build(BuildContext context) {
    final patient = ref.read(patientProvider)!;
    final screening = ref.read(screeningInformationProvider)!;

    return DoubleCard(
      scroll: isUploading ? false : true,
      child: isUploading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LoadingWidget(),
                if (isPatientUploading) const Text(kUploadingPatient),
                if (isPatientUploading) const Text(kUploadingPatientMessage),
                if (isScreeningUploading) const Text(kUploadingScreening),
                if (isScreeningUploading)
                  const Text(kUploadingScreeningMessage),
              ],
            )
          : Column(
              children: [
                PatientInformationCard(patient),
                const Gap(8),
                VitalsCard(screening, isReview: true),
                const Gap(8),
                ScreeningInformationCard(screening),
                const Gap(8),
                EarImages("$kLeftEar:", screening.images),
                const Gap(8),
                EarImages("$kRightEar:", screening.images),
                const Gap(8),
                FilledButton(
                  child: const Text(kSubmitBtn),
                  onPressed: () async {
                    final complete = await onPressed(patient, screening);

                    if (complete) {
                      ref
                          .read(dashboardTabProvider.notifier)
                          .removePatientTab();
                    }
                  },
                ),
              ],
            ),
    );
  }

  Future<bool> onPressed(
      PatientEntity patient, ScreeningEntity screening) async {
    setState(() {
      isUploading = true;
      isPatientUploading = true;
    });
    final notifier = ref.read(postDataProvider.notifier);
    final connection = ref.read(connectionProvider);

    try {
      await notifier.postPatient(patient);

      setState(() {
        isPatientUploading = false;
        isScreeningUploading = true;
      });

      await notifier.postScreening(screening);

      if (!connection) {
        final newTable = TableEntity(
          patient: patient,
          screening: screening,
        );
        ref.read(tableProvider.notifier).addTable(newTable);
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        popUpInfoBar(kErrorTitle, e.toString(), context);
      });
      return false;
    } finally {
      setState(() {
        isScreeningUploading = false;
        isUploading = false;
      });
    }
    return true;
  }
}
