import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';

Future<void> desktopInit() async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1000, 700),
    minimumSize: Size(1000, 700),
    title: kAppName,
    center: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  Directory applicationSupport = await getApplicationSupportDirectory();
  applicationDirectory = applicationSupport.path;

  Directory applicationDocuments = await getApplicationDocumentsDirectory();
  documentDirectory = applicationDocuments.path;

  Hive.init(documentDirectory);

  final storageKey = await secureStorage.read(key: kHiveKey);

  late HiveCipher cipher;

  if (storageKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(key: kHiveKey, value: base64UrlEncode(key));
    cipher = HiveAesCipher(key);
  } else {
    final key = base64Url.decode(storageKey);
    cipher = HiveAesCipher(key);
  }

  collection = await BoxCollection.open(
    kOtoscopiaHiveBox,
    hiveBoxes,
    key: cipher,
    path: documentDirectory,
  );
}