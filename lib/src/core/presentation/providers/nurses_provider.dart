import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'nurses_provider.g.dart';

@Riverpod(keepAlive: true)
class Nurses extends _$Nurses {
  @override
  List<UserEntity> build() {
    return [];
  }

  void setNurses(List<UserEntity> nurses) => state = nurses;

  UserEntity findById(String id) {
    return state.firstWhere((user) => user.uid == id);
  }
}
