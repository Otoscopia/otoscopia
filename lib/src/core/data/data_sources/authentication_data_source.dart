import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/authentication/authentication.dart';

class AuthenticationDataSource {
  final Account _account;
  final Databases _database;
  final Functions _function;

  AuthenticationDataSource()
      : _account = Account(client),
        _database = Databases(client),
        _function = Functions(client);

  Future<List> login(SignInFormEntity form) async {
    try {
      final session = await _account.createEmailPasswordSession(
        email: form.email,
        password: form.password,
      );

      final user = await _account.get();
      final verified = user.emailVerification && user.phoneVerification;

      final mfaFactors = await _account.listMfaFactors();

      final result = await _database.getDocument(
        databaseId: Env.database,
        collectionId: Env.userCollection,
        documentId: user.$id,
      );

      if (!verified) {
        throw Exception(kAccountNotVerified);
      }

      return [session, result, user.prefs.data, mfaFactors];
    } on AppwriteException catch (error) {
      if (error.type == 'user_more_factors_required') {
        throw Exception(error.type);
      }
      throw Exception(error.message);
    }
  }

  Future<List> getUser(String sessionId) async {
    try {
      final session = await _account.getSession(sessionId: sessionId);
      final user = await _account.get();

      final mfaFactors = await _account.listMfaFactors();

      final result = await _database.getDocument(
        databaseId: Env.database,
        collectionId: Env.userCollection,
        documentId: user.$id,
      );
      return [session, result, user.prefs.data, mfaFactors];
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<bool> signUp(SignUpFormEntity form) async {
    try {
      final user = await _account.create(
        email: form.email,
        password: form.password,
        name: form.name,
        userId: ID.unique(),
      );

      await _function.createExecution(
        functionId: Env.accountCreation,
        body: json.encode(form.toMap(user.$id)),
        path: '/',
        method: ExecutionMethod.pOST,
      );

      return true;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<void> logout(String sessionId) async {
    try {
      await _account.deleteSession(sessionId: sessionId);
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<List> confirmMfa(String otp) async {
    try {
      final result = await _account.createMfaChallenge(
        factor: AuthenticationFactor.totp,
      );

      await _account.updateMfaChallenge(challengeId: result.$id, otp: otp);

      final user = await _account.get();

      final data = await _database.getDocument(
        databaseId: Env.database,
        collectionId: Env.userCollection,
        documentId: user.$id,
      );

      final mfaFactors = await _account.listMfaFactors();
      final session = await _account.listSessions();

      return [
        session.sessions.first,
        data.data,
        user.prefs.data,
        mfaFactors,
      ];
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }
}
