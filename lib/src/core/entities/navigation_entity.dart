import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as icons;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/settings/settings.dart';

class NavigationEntity {
  final BuildContext _context;
  final WidgetRef _ref;

  NavigationEntity(this._context, this._ref);

  String get image => _ref.watch(userProvider)!.avatar!;

  List<NavigationPaneItem> get footer => [
    PaneItemSeparator(),
    PaneItemAction(
      icon: const Icon(icons.FluentIcons.megaphone_loud_20_regular),
      title: const Text("Whats New"),
      onTap: () async => await whatsNew(_context),
    ),
    PaneItem(
      icon: const Icon(icons.FluentIcons.settings_20_regular),
      title: const Text(kSettings),
      body: const Settings(),
    ),
    PaneItemAction(
      icon: const Icon(icons.FluentIcons.sign_out_20_regular),
      title: const Text("Sign out"),
      onTap: () async {
        _ref.read(authenticationProvider.notifier).logout();

        Navigator.pushNamedAndRemoveUntil(_context, '/', (route) => false);
      },
    ),
    PaneItemSeparator(),
  ];

  List<NavigationPaneItem> get items => [
    PaneItem(
      icon: const Icon(FluentIcons.view_dashboard),
      title: const Text(kDashboard),
      body: const Dashboard(),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.issue_tracking),
      title: const Text(kPatients),
      body: const PatientsScreen(),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.e_discovery),
      title: const Text(kSchools),
      body: const SchoolsScreen(),
    ),
  ];

  List<NavigationPaneItem> get adminItems => [
    PaneItem(
      icon: const Icon(FluentIcons.view_dashboard),
      title: const Text(kDashboard),
      body: const Dashboard(),
    ),
  ];
}
