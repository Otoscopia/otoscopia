import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/settings/settings.dart';

class MyApp extends ConsumerWidget {
  const MyApp(this.deviceType, {super.key});
  final DeviceType deviceType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SettingsEntity settings = ref.watch(settingsProvider);
    ThemeEntity theme = ThemeEntity(settings);

    bool isAuthenticated = ref.watch(authenticationProvider);
    UserEntity? user = ref.watch(userProvider);
    UserRole? role = isAuthenticated ? user?.role : null;

    Map<String, WidgetBuilder> routes = createRoutes(
      isAuthenticated,
      deviceType,
      role,
    );

    return FluentApp(
      routes: routes,
      title: kAppName,
      initialRoute: kInitialRoute,
      themeMode: theme.themeMode,
      theme: theme.lightMode,
      darkTheme: theme.darkMode,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [SentryNavigatorObserver()],
      builder: (context, child) => responsiveBuilder(child!),
    );
  }
}
