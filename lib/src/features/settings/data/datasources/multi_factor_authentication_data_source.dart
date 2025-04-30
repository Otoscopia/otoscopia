import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';

import 'package:otoscopia/src/config/config.dart';

class MultiFactorAuthenticationDataSource {
  final Account _account;
  final Avatars _avatars;

  MultiFactorAuthenticationDataSource()
      : _account = Account(client),
        _avatars = Avatars(client);

  Future<List<String>> getRecoveryCodes() async {
    try {
      final response = await _account.createMfaRecoveryCodes();
      return List<String>.from(response.recoveryCodes);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  /// Enable authenticator app
  Future<List> enableAuthenticatorApp() async {
    try {
      // create time based one time password
      final response =
          await _account.createMfaAuthenticator(type: AuthenticatorType.totp);

      // get qr code and secret key
      return [await _avatars.getQR(text: response.uri), response.secret];
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  /// Disable authenticator app
  Future<void> disableAuthenticatorApp(String otp) async {
    try {
      // delete authenticator app
      await _account.deleteMfaAuthenticator(type: AuthenticatorType.totp);

      // update user mfa status to false
      await _account.updateMFA(mfa: false);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  /// Verify authenticator app
  Future<void> verifyAuthenticatorApp(String otp) async {
    try {
      await _account.updateMfaAuthenticator(
        otp: otp,
        type: AuthenticatorType.totp,
      );

      // update user mfa status to true
      await _account.updateMFA(mfa: true);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }
}
