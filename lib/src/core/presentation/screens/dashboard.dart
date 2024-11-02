import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = getDeviceType() == DeviceType.web;
    final isMobile = getDeviceType() == DeviceType.mobile;

    final mobile = isMobile == true
        ? isMobile
        : isWeb && MediaQuery.of(context).size.width < 400;

    return TabView(
      closeDelayDuration: Duration.zero,
      tabs: ref.watch(dashboardTabProvider),
      shortcutsEnabled: true,
      currentIndex: ref.watch(dashboardIndexProvider),
      closeButtonVisibility: mobile
          ? CloseButtonVisibilityMode.always
          : CloseButtonVisibilityMode.onHover,
      onChanged: (index) {
        ref.read(dashboardIndexProvider.notifier).setIndex(index);
      },
    );
  }
}
