import 'package:otoscopia/src/config/config.dart';

String get databaseId => collectionIds['database'];

String getCollectionId(String name) {
  return List.from(
    collectionIds['collections'],
  ).firstWhere((e) => e['name'] == name)['id'];
}

String getFunctionId(String name) {
  return List.from(
    functionIds['functions'],
  ).firstWhere((e) => e['name'] == name)['id'];
}

String geteventId(String activity) {
  return List.from(
    eventIds['events'],
  ).firstWhere((e) => e['activity'] == activity)['id'];
}

String getBucketId(String name) {
  return List.from(
    storageIds['collections'],
  ).firstWhere((e) => e['name'] == name)['id'];
}
