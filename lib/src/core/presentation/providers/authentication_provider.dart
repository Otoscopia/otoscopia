import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/authentication/authentication.dart';

part 'authentication_provider.g.dart';

@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  static final AuthenticationDataSource _source = AuthenticationDataSource();
  final AuthenticationRepository _repository = AuthenticationRepositoryImpl(
    _source,
  );

  @override
  bool build() {
    return false;
  }

  Future<UserEntity> login(SignInFormEntity form) async {
    try {
      final user = await _repository.login(form);
      state = true;
      ref.read(userProvider.notifier).setUser(user);
      await ref.read(fetchDataProvider.notifier).fetch(user);
      return user;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<void> getUser(String sessionId) async {
    try {
      final user = await _repository.getUser(sessionId);
      state = true;
      ref.read(userProvider.notifier).setUser(user);
      await ref.read(fetchDataProvider.notifier).fetch(user);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<bool> signUp(SignUpFormEntity form) async {
    try {
      await _repository.signUp(form);
      return true;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<UserEntity> confirmMfa(String otp) async {
    try {
      return await _repository.confirmMfa(otp);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<void> logout() async {
    UserEntity user = ref.read(userProvider)!;
    try {
      await _repository.logout(user.session!);

      state = false;

      ref.read(doctorsProvider).clear();
      ref.read(nursesProvider).clear();
      ref.read(assignmentsProvider).clear();
      ref.read(patientsProvider).clear();
      ref.read(tableProvider).clear();
      ref.read(appIndexProvider.notifier).setIndex(0);
      ref.read(patientsIndexProvider.notifier).setIndex(0);
      ref.read(schoolsIndexProvider.notifier).setIndex(0);
      ref.read(schoolsIndexProvider.notifier).setIndex(0);
      ref.read(userProvider.notifier).setUser(null);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
