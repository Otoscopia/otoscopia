import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'nurses_provider.g.dart';

@Riverpod(keepAlive: true)
class Nurses extends _$Nurses {
  @override
  List<UsersEntity> build() {
    return [];
  }

  void setNurses(List<UsersEntity> nurses) => state = nurses;

  UsersEntity findById(String id) {
    return state.firstWhere((user) => user.id == id);
  }
}
