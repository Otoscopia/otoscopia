import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/core/functions/get_ids.dart';

class AppNavigation extends ConsumerWidget {
  const AppNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(connectionProvider);
    final user = ref.read(userProvider);

    final events = [
      'databases.${Env.database}.collections.${getCollectionId('patients')}.documents',
      'databases.${Env.database}.collections.${getCollectionId('screenings')}.documents',
      'databases.${Env.database}.collections.${getCollectionId('remarks')}.documents',
      'databases.${Env.database}.collections.${getCollectionId('activity_status')}.documents.${user?.activityStatusId}',
    ];

    if (connection) {
      final subscriber = realtime.subscribe(events);

      subscriber.stream.listen((event) {
        try {
          if (event.channels.contains(events[0])) {
            ref.read(tableProvider.notifier).fromPatientSnapshot(event.payload);
          } else if (event.channels.contains(events[1])) {
            ref
                .read(tableProvider.notifier)
                .fromScreeningSnapshot(event.payload);
          } else if (event.channels.contains(events[2])) {
            ref.read(tableProvider.notifier).fromRemarksSnapshot(event.payload);
          } else if (event.channels.contains(events[3])) {
            databases.updateDocument(
              databaseId: databaseId,
              collectionId: getCollectionId('activity_status'),
              documentId: user!.uid,
              data: {'status': '67bf07de00139dce8f0e'},
            );
          }
        } catch (e) {
          WidgetsFlutterBinding().addPostFrameCallback((_) {
            popUpInfoBar(kErrorTitle, e.toString(), context);
          });
        }
      });
    }

    final isWeb = deviceType == DeviceType.web;
    final isMobile = deviceType == DeviceType.mobile;

    final mobile = isWeb && MediaQuery.of(context).size.width < 400 || isMobile;

    final navigation = NavigationEntity(context, ref);

    return ApplicationContainer(
      child: NavigationView(
        appBar:
            mobile
                ? const NavigationAppBar(
                  title: Logo(),
                  automaticallyImplyLeading: false,
                )
                : null,
        pane: NavigationPane(
          displayMode:
              mobile ? PaneDisplayMode.minimal : PaneDisplayMode.compact,
          size: const NavigationPaneSize(openMaxWidth: 300),
          selected: ref.watch(appIndexProvider),
          onChanged: (i) => ref.watch(appIndexProvider.notifier).setIndex(i),
          header: mobile ? null : const Logo(),
          autoSuggestBox: const SearchBox(),
          items: navigation.items,
          footerItems: navigation.footer,
          autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        ),
      ),
    );
  }
}


// wss://cloud.otoscopia.ph/v1/realtime?
// project=67ecc3d2001aa5bc3e9b&
// channels%5B%5D=databases.6635e2ea0018d0f415e9.collections.67ee3a8b001086ef439a.documents&
// channels%5B%5D=databases.6635e2ea0018d0f415e9.collections.67ee3a770021217af5dc.documents&
// channels%5B%5D=databases.6635e2ea0018d0f415e9.collections.6804b3e00037287a1721.documents&
// channels%5B%5D=databases.6635e2ea0018d0f415e9.collections.67ee60620021d898e380.documents.66336368001ab54dd19f