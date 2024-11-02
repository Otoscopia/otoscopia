// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appwrite/models.dart';

import 'package:otoscopia/src/core/core.dart';

class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String workAddress;
  final UserRole role;
  final String sessionId;
  final String? image;
  final MfaFactors mfaFactors;
  final Map<String, dynamic> preferences;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.workAddress,
    required this.role,
    required this.sessionId,
    required this.mfaFactors,
    required this.preferences,
    this.image,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? workAddress,
    String? publicKey,
    UserRole? role,
    String? sessionId,
    String? image,
    MfaFactors? mfaFactors,
    Map<String, dynamic>? preferences,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      workAddress: workAddress ?? this.workAddress,
      role: role ?? this.role,
      sessionId: sessionId ?? this.sessionId,
      image: image ?? this.image,
      mfaFactors: mfaFactors ?? this.mfaFactors,
      preferences: preferences ?? this.preferences,
    );
  }

  UserEntity updateMfaFactors(bool mfa) {
    final response = MfaFactors(
      totp: mfa,
      phone: mfaFactors.phone,
      email: mfaFactors.email,
      recoveryCode: mfaFactors.recoveryCode,
    );
    return copyWith(mfaFactors: response);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'workAddress': workAddress,
      'role': role.toString(),
      'sessionId': sessionId,
      'image': image,
      'mfaFactors': mfaFactors,
      'preferences': preferences,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map, String session,
      MfaFactors mfa, Map<String, dynamic> prefs) {
    UserRole role = getRole(map['role']);
    final id = map['\$id'] as String;
    final image = map['image'] as String?;

    return UserEntity(
      id: id,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      workAddress: map['workAddress'] as String,
      role: role,
      sessionId: session,
      image: image ?? "https://robohash.org/$id?set=set4",
      mfaFactors: mfa,
      preferences: prefs,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source, String session, MfaFactors mfa,
          Map<String, dynamic> prefs) =>
      UserEntity.fromMap(
          json.decode(source) as Map<String, dynamic>, session, mfa, prefs);

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, phone: $phone, workAddress: $workAddress, role: $role, sessionId: $sessionId)';
  }

  @override
  bool operator ==(covariant UserEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.workAddress == workAddress &&
        other.role == role &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        workAddress.hashCode ^
        role.hashCode ^
        sessionId.hashCode;
  }

  static UserRole getRole(String role) {
    switch (role) {
      case "admin":
        return UserRole.admin;
      case "doctor":
        return UserRole.doctor;
      case "nurse":
        return UserRole.nurse;
      case "patient":
        return UserRole.patient;
      default:
        return UserRole.patient;
    }
  }

  bool get isDoctor => role == UserRole.doctor;

  bool get isNurse => role == UserRole.nurse;
}
