// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AssignmentEntity {
  final String id;
  final String nurse;
  final String school;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssignmentEntity({
    required this.id,
    required this.nurse,
    required this.school,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  AssignmentEntity copyWith({
    String? id,
    String? nurse,
    String? school,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssignmentEntity(
      id: id ?? this.id,
      nurse: nurse ?? this.nurse,
      school: school ?? this.school,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nurse': nurse,
      'school': school,
      'is_active': isActive,
    };
  }

  factory AssignmentEntity.fromMap(Map<String, dynamic> map) {
    return AssignmentEntity(
      id: map['\$id'] as String,
      nurse: map['nurse']["\$id"] as String,
      school: map['school']["\$id"] as String,
      isActive: map['is_active'] as bool,
      createdAt: DateTime.parse(map['\$createdAt']),
      updatedAt: DateTime.parse(map['\$updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AssignmentEntity.fromJson(String source) =>
      AssignmentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AssignmentEntity(id: $id, nurse: $nurse, school: $school, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant AssignmentEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nurse == nurse &&
        other.school == school &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nurse.hashCode ^
        school.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
