// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:otoscopia/src/core/core.dart';

class SearchEntity {
  final String name;
  final SearchRole role;
  SearchEntity({
    required this.name,
    required this.role,
  });

  SearchEntity copyWith({
    String? name,
    SearchRole? role,
  }) {
    return SearchEntity(
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'role': role.toString(),
    };
  }

  factory SearchEntity.fromMap(Map<String, dynamic> map) {
    final role = getRole(map['role'] as String);
    return SearchEntity(
      name: map['name'] as String,
      role: role,
    );
  }

  static SearchRole getRole(String role) {
    switch (role) {
      case 'SearchRole.patient':
        return SearchRole.patient;
      case 'SearchRole.doctor':
        return SearchRole.doctor;
      case 'SearchRole.school':
        return SearchRole.nurse;
      case 'SearchRole.nurse':
        return SearchRole.nurse;
      case 'SearchRole.schools':
        return SearchRole.schools;
      case 'SearchRole.settings':
        return SearchRole.settings;
      default:
        return SearchRole.profile;
    }
  }

  String toJson() => json.encode(toMap());

  factory SearchEntity.fromJson(String source) =>
      SearchEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SearchEntity(name: $name, role: $role)';

  @override
  bool operator ==(covariant SearchEntity other) {
    if (identical(this, other)) return true;

    return other.name == name && other.role == role;
  }

  @override
  int get hashCode => name.hashCode ^ role.hashCode;
}
