import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/nurse/nurse.dart';

part 'post_data_provider.g.dart';

@Riverpod(keepAlive: true)
class PostData extends _$PostData {
  @override
  void build() {
    return;
  }

  static final _source = PostDataDataSource();
  static final _repository = PostDataRepositoryImpl(_source);

  Future<bool> postPatient(PatientEntity patient) async {
    try {
      await _repository.postPatient(patient);
      return true;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<bool> postScreening(ScreeningEntity screening) async {
    try {
      await _repository.postScreening(screening);
      return true;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }
}
