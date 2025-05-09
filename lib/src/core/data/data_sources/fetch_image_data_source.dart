import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:file_saver/file_saver.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/core/functions/get_ids.dart';

class FetchImageDataSource {
  final Storage _storage;

  FetchImageDataSource() : _storage = Storage(client);

  Future<List<Uint8List>> getImages(String path, List<String> ids) async {
    final bucketId = getBucketId('screenings');
    final List<Uint8List> images = [];

    try {
      for (String id in ids) {
        final file = await _storage.getFile(bucketId: bucketId, fileId: id);

        if (file.name.toLowerCase().contains(path.toLowerCase())) {
          final result = await _storage.getFilePreview(
            bucketId: bucketId,
            fileId: id,
          );

          images.add(result);
        }
      }

      return images;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<PrescriptionEntity>> getPrescription(List<String> id) async {
    final bucketId = getBucketId('prescriptions');
    final List<PrescriptionEntity> images = [];

    try {
      for (String id in id) {
        final file = await _storage.getFile(bucketId: bucketId, fileId: id);
        final result = await _storage.getFilePreview(
          bucketId: bucketId,
          fileId: id,
        );

        images.add(
          PrescriptionEntity(id: file.$id, name: file.name, image: result),
        );
      }

      return images;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> downloadPrescription(PrescriptionEntity prescription) async {
    final bucketId = getBucketId('prescriptions');

    try {
      final response = await _storage.getFileDownload(
        bucketId: bucketId,
        fileId: prescription.id,
      );

      await FileSaver.instance.saveFile(
        bytes: response,
        name: prescription.name,
      );
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }
}
