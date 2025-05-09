import 'package:flutter/services.dart';

import 'package:appwrite/appwrite.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/core/functions/get_ids.dart';

class PostRemarkDataSource {
  final Databases _database;
  final Storage _storage;

  PostRemarkDataSource()
    : _database = Databases(client),
      _storage = Storage(client);

  Future<void> postRemark(
    RemarksEntity remarks,
    List<Uint8List> bytes,
    List<String> names,
  ) async {
    try {
      if (remarks.status != RecordStatus.followUp) {
        await _database.createDocument(
          databaseId: Env.database,
          collectionId: getCollectionId('remarks'),
          documentId: remarks.id,
          data: remarks.toMap(),
        );
      } else {
        List<String> ids = [];
        for (int i = 0; i < bytes.length; i++) {
          final file = bytes[i];
          final response = await _storage.createFile(
            fileId: ID.unique(),
            bucketId: getBucketId('prescription'),
            file: InputFile.fromBytes(bytes: file, filename: names[i]),
          );

          ids.add(response.$id);
        }

        await _database.createDocument(
          databaseId: Env.database,
          collectionId: getCollectionId('remarks'),
          documentId: remarks.id,
          data: remarks.toMap(images: ids),
        );
      }
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<bool> referDoctor(String id, String doctor) async {
    try {
      await _database.updateDocument(
        documentId: id,
        databaseId: Env.database,
        collectionId: getCollectionId('patients'),
        data: <String, dynamic>{'doctor': doctor},
      );

      return true;
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }
}
