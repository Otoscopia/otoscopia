import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/authentication/authentication.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationDataSource _source;

  AuthenticationRepositoryImpl(this._source);

  @override
  Future<UserEntity> login(SignInFormEntity form) async {
    try {
      List response = await _source.login(form);

      final Session session = response[0];
      final Document user = response[1];
      final MfaFactors mfa = response[2];
      final Document config = response[3];

      final userEntity = UserEntity.fromAppwrite(
        user: user,
        session: session,
        mfa: mfa,
        config: config,
      );

      return userEntity;
    } on AppwriteException {
      rethrow;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> getUser(String sessionId) async {
    try {
      List response = await _source.getUser(sessionId);

      final Session session = response[0];
      final Document user = response[1];
      final MfaFactors mfa = response[2];
      final Document config = response[3];

      final userEntity = UserEntity.fromAppwrite(
        user: user,
        session: session,
        mfa: mfa,
        config: config,
      );

      return userEntity;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<bool> signUp(SignUpFormEntity form) {
    try {
      return _source.signUp(form);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<void> logout(String sessionId) {
    return _source.logout(sessionId);
  }

  @override
  Future<UserEntity> confirmMfa(String otp) async {
    try {
      List response = await _source.confirmMfa(otp);

      final Session session = response[0];
      final Document user = response[1];
      final MfaFactors mfa = response[2];
      final Document config = response[3];

      final userEntity = UserEntity.fromAppwrite(
        user: user,
        session: session,
        mfa: mfa,
        config: config,
      );

      return userEntity;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }
}
