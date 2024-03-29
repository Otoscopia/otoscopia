import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';

class OfflineBottomBar extends ConsumerWidget {
  const OfflineBottomBar(this.connection, {super.key});
  final bool connection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      height: 24,
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: connection ? AppColors.transparent : AppColors.primary,
        child: connection ? null : offlineWidget(),
      ),
    );
  }

  Row offlineWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          kOffline.toUpperCase(),
          style: const TextStyle(letterSpacing: 1),
        ),
      ],
    );
  }
}
