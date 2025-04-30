import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';

class VitalsCard extends ConsumerWidget {
  const VitalsCard(
    this._screening, {
    super.key,
    this.remarks,
    this.isReview = false,
    this.isOverview = false,
  });

  final ScreeningEntity _screening;
  final RemarksEntity? remarks;
  final bool isReview;
  final bool isOverview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasRemarks = remarks != null;
    final vitalSigns = hasRemarks ? remarks!.statusIcon : Ionicons.time_outline;
    final vitalSignsColor = hasRemarks ? remarks!.statusColor : Colors.yellow;
    final uploadedAt = DateFormat.yMMMMd().format(_screening.createdAt);
    final temperature = _screening.temperature.toStringAsFixed(1);
    final weight = _screening.weight.toStringAsFixed(1);
    final height = _screening.height.toStringAsFixed(1);
    final updated =
        hasRemarks ? remarks!.status != RecordStatus.pending : false;
    final updatedAt = DateFormat.yMMMMd().format(_screening.updatedAt);

    final children = [
      const Gap(4),
      if (updated)
        VitalRow(Ionicons.cloud_upload, kModifiedAt, uploadedAt)
      else if (isReview || !updated)
        VitalRow(Ionicons.cloud_upload, isReview ? "Screened at:" : kUploadedAt,
            updatedAt),
      const Gap(16),
      VitalRow(Ionicons.thermometer, kTemperature, temperature),
      const Gap(16),
      VitalRow(Ionicons.barbell, kWeight, weight),
      const Gap(16),
      VitalRow(Ionicons.body, kHeight, height),
    ];

    final isWeb = deviceType == DeviceType.web;
    final isMobile = deviceType == DeviceType.mobile;

    final mobile = isMobile == true
        ? isMobile
        : isWeb && MediaQuery.of(context).size.width < 400;

    return CardOpacity(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hasRemarks)
            Row(
              children: [
                Icon(vitalSigns, color: vitalSignsColor, size: 32),
                const Gap(8),
                CustomText(hasRemarks ? remarks!.statusString : "Pending",
                    style: 2),
              ],
            ),
          if (isOverview && hasRemarks)
            Row(
              children: [
                Icon(vitalSigns, color: vitalSignsColor, size: 32),
                const Gap(8),
                CustomText(remarks!.statusString, style: 2),
              ],
            ),
          if (!hasRemarks) const Gap(8),
          if (mobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
        ],
      ),
    );
  }
}
