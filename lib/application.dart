import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:otoscopia/src/core/core.dart';

class ApplicationConfig {
  static const kRepository =
      "https://api.github.com/repos/otoscopia/otoscopia/releases";

  Future<List<ReleaseEntity>> fetchReleases() async {
    final response = await http.get(Uri.parse(kRepository));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((e) => ReleaseEntity.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load releases');
    }
  }
}
