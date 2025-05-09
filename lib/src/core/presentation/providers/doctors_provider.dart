import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'doctors_provider.g.dart';

@Riverpod(keepAlive: true)
class Doctors extends _$Doctors {
  @override
  List<UserEntity> build() {
    return [];
  }

  void setDoctors(List<UserEntity> users) => state = users;

  UserEntity findById(String id) {
    return state.firstWhere((user) => user.uid == id);
  }
}
