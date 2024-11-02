import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:system_theme/system_theme.dart';

import 'package:otoscopia/application.dart';
import 'package:otoscopia/src/app.dart';
import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';

Future<void> main() async {
  const sentryRelease = '$kPackageName@${ApplicationConfig.currentVersion}';

  SystemTheme.fallbackColor = AppColors.secondary;
  await SystemTheme.accentColor.load();

  WidgetsFlutterBinding.ensureInitialized();

  DeviceType deviceType = getDeviceType();

  await DependencyInjection().init(deviceType);

  if (kDebugMode) {
    runApp(ProviderScope(child: MyApp(deviceType)));
  } else {
    await SentryFlutter.init((options) {
      options.dsn = Env.sentryApi;
      options.release = sentryRelease;
      options.tracesSampleRate = 1.0;
      options.tracesSampler = (samplingContext) => 1;
    }, appRunner: () {
      return runApp(
        ProviderScope(
          child: DefaultAssetBundle(
            bundle: SentryAssetBundle(),
            child: MyApp(deviceType),
          ),
        ),
      );
    });
  }
}
