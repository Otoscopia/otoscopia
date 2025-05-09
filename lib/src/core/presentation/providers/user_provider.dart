import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class User extends _$User {
  @override
  UserEntity? build() {
    return null;
  }

  void setUser(UserEntity? user) {
    state = user;
  }

  void updateInformation({String? name, String? phone, String? workAddress}) {
    final user = state!.copyWith(
      readableName: name,
      contactNumber: phone,
      workAddress: workAddress,
    );

    setUser(user);
  }

  void updateMfa(bool mfa) {
    final user = state!.copyWith(mfaEnabled: mfa);

    setUser(user);
  }
}
