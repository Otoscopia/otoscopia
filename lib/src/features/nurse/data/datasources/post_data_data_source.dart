import 'package:appwrite/appwrite.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/core/functions/get_ids.dart';

class PostDataDataSource {
  final Databases _databases;
  final Storage _storage;

  PostDataDataSource()
    : _databases = Databases(client),
      _storage = Storage(client);

  Future<void> postPatient(PatientEntity patient) async {
    try {
      await _databases.createDocument(
        databaseId: Env.database,
        collectionId: getCollectionId('patients'),
        data: patient.toMap(),
        documentId: patient.id,
      );
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<void> postScreening(ScreeningEntity screening) async {
    final bucketId = getBucketId('screenings');
    try {
      List<String> images = [];

      for (int i = 0; i < screening.images.length; i++) {
        final fileName = screening.images[i].split("\\").last;
        final file = await _storage.createFile(
          fileId: ID.unique(),
          bucketId: bucketId,
          file: InputFile.fromPath(
            path: screening.images[i],
            filename: fileName,
            contentType: "image/jpeg",
          ),
        );

        images.add(file.$id);
      }

      final modified = screening.copyWith(images: images);

      await _databases.createDocument(
        databaseId: Env.database,
        collectionId: getCollectionId('screenings'),
        documentId: screening.id,
        data: modified.toMap(),
      );
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }
}
