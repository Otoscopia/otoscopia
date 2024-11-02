import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';

class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabView(
      currentIndex: ref.watch(patientsIndexProvider),
      tabs: ref.watch(patientsTabProvider),
      onChanged: (value) {
        ref.read(patientsIndexProvider.notifier).setIndex(value);
      },
    );
  }
}
