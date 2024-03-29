import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabView(
      closeDelayDuration: Duration.zero,
      tabs: ref.watch(dashboardTabProvider),
      shortcutsEnabled: true,
      currentIndex: ref.watch(dashboardIndexProvider),
      closeButtonVisibility: CloseButtonVisibilityMode.onHover,
      onChanged: (index) {
        ref.read(dashboardIndexProvider.notifier).setIndex(index);
      },
    );
  }
}
