import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/core/functions/get_ids.dart';
import 'package:otoscopia/src/features/authentication/authentication.dart';

class AuthenticationDataSource {
  final Account _account;
  final Databases _database;
  final Functions _function;

  AuthenticationDataSource()
    : _account = Account(client),
      _database = Databases(client),
      _function = Functions(client);

  Future<List> login(SignInFormEntity form) async {
    try {
      final session = await _account.createEmailPasswordSession(
        email: form.email,
        password: form.password,
      );

      final user = await _account.get();

      final response = await _database.getDocument(
        databaseId: Env.database,
        collectionId: Env.users,
        documentId: user.$id,
      );

      if (response.data['activity_status']['status']['\$id'] ==
          '67bf07ea0022e1fa81ec') {
        throw Exception(kAccountDeactivated);
      }

      if (!response.data['is_verified']) {
        throw Exception(kAccountNotVerified);
      }

      await initializeAppwriteInjector(session, response.data['role']['\$id']);

      final futures = await Future.wait([
        _account.listMfaFactors(),

        _database.getDocument(
          databaseId: Env.database,
          collectionId: getCollectionId('admin_users_account_configuration'),
          documentId: '68046eca002a509e0cce',
        ),

        _database.updateDocument(
          databaseId: databaseId,
          collectionId: getCollectionId('activity_status'),
          documentId: response.data['activity_status']['\$id'],
          data: {'status': '67bf07de00139dce8f0e'},
        ),
      ]);

      final mfaFactors = futures[0];

      final config = futures[1];

      return [session, response, mfaFactors, config];
    } on AppwriteException catch (error) {
      if (error.type == 'user_more_factors_required') {
        throw Exception(error.type);
      } else if (error.type == 'user_blocked') {
        throw Exception(kAccountDeactivated);
      }
      rethrow;
    }
  }

  Future<List> getUser(String sessionId) async {
    try {
      final session = await _account.getSession(sessionId: sessionId);
      final user = await _account.get();

      final futures = await Future.wait([
        _account.listMfaFactors(),

        _database.getDocument(
          databaseId: Env.database,
          collectionId: getCollectionId('admin_users_account_configuration'),
          documentId: '68046eca002a509e0cce',
        ),
      ]);

      final response = await _database.getDocument(
        databaseId: Env.database,
        collectionId: getCollectionId('users'),
        documentId: user.$id,
      );

      final mfaFactors = futures[0];

      final config = futures[1];

      await initializeAppwriteInjector(session, response.data['role']['\$id']);

      return [session, response, mfaFactors, config];
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<bool> signUp(SignUpFormEntity form) async {
    try {
      // final user = await _account.create(
      //   email: form.email,
      //   password: form.password,
      //   name: form.name,
      //   userId: ID.unique(),
      // );

      // await _function.createExecution(
      //   functionId: Env.accountCreation,
      //   body: json.encode(form.toMap(user.$id)),
      //   path: '/',
      //   method: ExecutionMethod.pOST,
      // );

      return true;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<void> logout(String sessionId) async {
    try {
      await _account.deleteSession(sessionId: sessionId);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<List> confirmMfa(String otp) async {
    try {
      final result = await _account.createMfaChallenge(
        factor: AuthenticationFactor.totp,
      );

      final session = await _account.updateMfaChallenge(
        challengeId: result.$id,
        otp: otp,
      );

      final user = await _account.get();

      final futures = await Future.wait([
        _account.listMfaFactors(),

        _database.getDocument(
          databaseId: Env.database,
          collectionId: getCollectionId('admin_users_account_configuration'),
          documentId: '68046eca002a509e0cce',
        ),
      ]);

      final response = await _database.getDocument(
        databaseId: Env.database,
        collectionId: getCollectionId('users'),
        documentId: user.$id,
      );

      final mfaFactors = futures[0];

      final config = futures[1];

      await initializeAppwriteInjector(session, response.data['role']['\$id']);

      return [session, response, mfaFactors, config];
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<void> initializeAppwriteInjector(Session? session, String role) async {
    try {
      late final Execution response;

      late String info;
      if (kIsWeb) {
        final web = (device as WebBrowserInfo);
        info = "${web.platform} - ${web.browserName} - ${web.userAgent}";
      } else if (Platform.isWindows) {
        final win = (device as WindowsDeviceInfo);
        info = "${win.productName} - ${win.computerName} - ${win.buildLab}";
      } else if (Platform.isMacOS) {
        final mac = (device as MacOsDeviceInfo);
        info = "${mac.model} - ${mac.computerName} - ${mac.osRelease}";
      }

      final body = {
        'user': session?.userId,
        'role': role,
        'location': session?.countryName,
        'ip': session?.ip,
        'device': info,
        'resource': '6803beaf00232580b773',
      };

      response = await _function.createExecution(
        functionId: Env.appwriteInjector,
        body: json.encode(body),
        method: ExecutionMethod.gET,
      );

      final jsonResponse =
          json.decode(response.responseBody) as Map<String, dynamic>;

      initializeAppwriteIds(
        collections: jsonResponse['databases'],
        storages: jsonResponse['buckets'],
        functions: jsonResponse['functions'],
        events: jsonResponse['events'],
      );
    } on AppwriteException catch (_) {
      rethrow;
    }
  }

  void initializeAppwriteIds({
    required collections,
    required storages,
    required functions,
    required events,
  }) {
    collectionIds = collections;
    storageIds = storages;
    functionIds = functions;
    eventIds = events;
  }
}
