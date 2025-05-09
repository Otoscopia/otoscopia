import 'package:flutter/foundation.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:otoscopia/src/app.dart';
import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final packageInfo = await PackageInfo.fromPlatform();

  await DependencyInjection().init();

  if (kDebugMode) {
    runApp(ProviderScope(child: MyApp(deviceType)));
  } else {
    await SentryFlutter.init(
      (options) {
        options.dsn = Env.sentryDsn;
        options.release = packageInfo.version;
        options.tracesSampleRate = 1.0;
        options.tracesSampler = (samplingContext) => 1;
      },
      appRunner: () {
        return runApp(
          ProviderScope(
            child: DefaultAssetBundle(
              bundle: SentryAssetBundle(),
              child: MyApp(deviceType),
            ),
          ),
        );
      },
    );
  }
}
