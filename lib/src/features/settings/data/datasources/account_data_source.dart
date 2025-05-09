import 'package:flutter/services.dart';

import 'package:appwrite/appwrite.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/core/functions/get_ids.dart';

class AccountDataSource {
  final Account _account;
  final Databases _database;
  final Storage _storage;
  final Functions _function;

  AccountDataSource()
    : _account = Account(client),
      _database = Databases(client),
      _storage = Storage(client),
      _function = Functions(client);

  /// Update the user's name
  Future<void> updateName(String name) async {
    try {
      await _account.updateName(name: name);

      return;
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Update the user's contact number
  Future<void> updateContact(String contact, String password) async {
    try {
      await _account.updatePhone(phone: contact, password: password);

      return;
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Update the user's clinic address
  Future<void> updateAddress(String address) async {
    try {
      final userResponse = await _account.get();

      await _database.updateDocument(
        databaseId: Env.database,
        collectionId: getCollectionId('users'),
        documentId: userResponse.$id,
        data: {'workAddress': address},
      );

      return;
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Update the user's profile picture
  Future<void> updateProfilePicture({String? path, Uint8List? cache}) async {
    try {
      assert(path != null || cache != null);

      final userResponse = await _account.get();

      if (path == null) {
        final file = await _storage.createFile(
          bucketId: getBucketId('avatars'),
          fileId: userResponse.$id,
          file: InputFile.fromBytes(
            bytes: cache!,
            filename: "profile-${userResponse.$id}.png",
          ),
        );

        await _account.updatePrefs(prefs: {'avatar': file.$id});

        return;
      }

      await _storage.createFile(
        bucketId: getBucketId('avatars'),
        fileId: userResponse.$id,
        file: InputFile.fromPath(path: path),
      );

      await _account.updatePrefs(prefs: {'avatar': path});
      return;
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Change the user's password
  Future<void> changePassword(String password, String oldPassword) async {
    try {
      // final response = await _account.updatePassword(password: password, oldPassword: oldPassword);
      // await _function.createExecution(
      //   functionId: Env.messaging,
      //   body: json.encode({"message_type": "password_reset", 'userId': response.$id}),
      //   path: '/',
      //   method: ExecutionMethod.pOST,
      // );
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
    return;
  }

  /// Delete the user's account
  Future<void> deleteAccount(String id) async {
    try {
      // await _function.createExecution(
      //   functionId: Env.messaging,
      //   body: json.encode({'userId': id, 'message_type': 'request_account_deletion'}),
      //   path: '/',
      //   method: ExecutionMethod.pOST,
      // );
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }
}
