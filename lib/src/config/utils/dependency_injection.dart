import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:appwrite/appwrite.dart';
import 'package:system_theme/system_theme.dart';
import 'package:uuid/uuid.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';

import 'desktop_dependency.dart';

late final Client client;
late final Realtime realtime;
late final Functions functions;
late final Uuid uuid;
late final String applicationDirectory;
late final String documentDirectory;
late final DeviceType deviceType;

class DependencyInjection {
  static final DependencyInjection _singleton = DependencyInjection._internal();

  factory DependencyInjection() {
    return _singleton;
  }

  DependencyInjection._internal();

  Future<void> init() async {
    uuid = const Uuid();

    SystemTheme.fallbackColor = AppColors.secondary;
    await SystemTheme.accentColor.load();

    await appwriteInit();

    deviceType = getDeviceType();

    switch (deviceType) {
      case DeviceType.mobile:
        mobileInit();
        break;
      case DeviceType.desktop:
        await desktopInit();
        break;
      case DeviceType.web:
        webInit();
        break;
    }
  }

  void mobileInit() {}

  void webInit() {}

  Future<void> appwriteInit() async {
    client = Client();
    client.setEndpoint(Env.endpoint).setProject(Env.project);
    realtime = Realtime(client);
    functions = Functions(client);
  }

  DeviceType getDeviceType() {
    if (kIsWeb) {
      return DeviceType.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      return DeviceType.mobile;
    } else {
      return DeviceType.desktop;
    }
  }
}
