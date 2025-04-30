import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';

import 'offline_bottom_bar.dart';

class ApplicationContainer extends ConsumerWidget {
  const ApplicationContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ScaffoldPage(
        padding: EdgeInsets.zero,
        content: OfflineBuilder(
          connectivityBuilder: (context, connectivity, child) {
            final connected = !connectivity.contains(ConnectivityResult.none);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (ref.read(connectionProvider) != connected) {
                ref.read(connectionProvider.notifier).setConnection(connected);
              }
            });

            return Stack(
              fit: StackFit.expand,
              children: [
                child,
                OfflineBottomBar(connected),
              ],
            );
          },
          child: child,
        ),
      ),
    );
  }
}
