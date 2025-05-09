import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/core/functions/get_ids.dart';

class FetchDataDataSource {
  final Databases _databases;

  FetchDataDataSource() : _databases = Databases(client);

  Future<DocumentList> getSchools() async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('schools'),
        queries: [Query.limit(100), Query.equal('is_active', true)],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getUnAssignedSchools() async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('schools'),
        queries: [
          Query.limit(100),
          Query.equal('is_assigned', false),
          Query.equal('is_active', true),
        ],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getAssignments() async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('assignments'),
        queries: [Query.limit(100)],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getAssignmentsByNurse(String id) async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('assignments'),
        queries: [Query.equal("nurse", id)],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getPatientsBySchools(List<String> schools) async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('patients'),
        queries: [
          if (schools.isNotEmpty) Query.equal('school', schools),
          Query.limit(100),
        ],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getPatientsByDoctor(String id) async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('patients'),
        queries: [Query.equal('doctor', id)],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getDoctors() async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('users'),
        queries: [Query.equal('role', '67bf07930003fc7ef011')],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getNurses() async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('users'),
        queries: [Query.equal('role', '67bf0797001abaa5b346')],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getScreeningsByPatient(List<String> patients) async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('screenings'),
        queries: [if (patients.isNotEmpty) Query.equal('patient', patients)],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getRemarksByPatients(List<String> screening) async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('remarks'),
        queries: [
          if (screening.isNotEmpty) Query.equal('screening', screening),
          Query.limit(100),
        ],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getScreeningsByPatientId(String patient) async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('screenings'),
        queries: [Query.equal('patient', patient)],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }

  Future<DocumentList> getRemarksByScreening(String screening) async {
    try {
      DocumentList result = await _databases.listDocuments(
        databaseId: Env.database,
        collectionId: getCollectionId('remarks'),
        queries: [Query.equal('screening', screening)],
      );

      return result;
    } on AppwriteException catch (error) {
      throw Exception(error.message);
    }
  }
}
