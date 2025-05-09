// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/models.dart';

import 'package:otoscopia/src/core/core.dart';

class UserEntity {
  final String uid;
  final String readableName;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String workAddress;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final DateTime lastPasswordUpdated;
  final UserRole role;
  final String roleId;
  final Gender gender;
  final Status activityStatus;
  final Status accountStatus;
  final String activityStatusId;
  final DateTime createdAt;
  final bool mfaEnabled;
  final bool isVerified;
  final DateTime? passwordExpiration;
  final DateTime? deactivationTime;
  final String? session;
  final String? location;
  final String? ip;
  final String? avatar;

  UserEntity({
    required this.uid,
    required this.readableName,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.workAddress,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.lastPasswordUpdated,
    required this.role,
    required this.roleId,
    required this.gender,
    required this.activityStatus,
    required this.activityStatusId,
    required this.accountStatus,
    required this.createdAt,
    required this.mfaEnabled,
    required this.isVerified,
    this.session,
    this.location,
    this.ip,
    this.deactivationTime,
    this.passwordExpiration,
    this.avatar,
  });

  UserEntity copyWith({
    String? uid,
    String? readableName,
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? contactNumber,
    String? workAddress,
    bool? isPhoneVerified,
    bool? isEmailVerified,
    DateTime? lastPasswordUpdated,
    UserRole? role,
    String? roleId,
    Gender? gender,
    Status? activityStatus,
    String? activityStatusId,
    Status? accountStatus,
    DateTime? createdAt,
    bool? mfaEnabled,
    bool? isVerified,
    DateTime? passwordExpiration,
    DateTime? deactivationTime,
    String? session,
    String? location,
    String? ip,
    String? avatar,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      readableName: readableName ?? this.readableName,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      contactNumber: contactNumber ?? this.contactNumber,
      workAddress: workAddress ?? this.workAddress,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      lastPasswordUpdated: lastPasswordUpdated ?? this.lastPasswordUpdated,
      role: role ?? this.role,
      roleId: roleId ?? this.roleId,
      gender: gender ?? this.gender,
      activityStatus: activityStatus ?? this.activityStatus,
      activityStatusId: activityStatusId ?? this.activityStatusId,
      accountStatus: accountStatus ?? this.accountStatus,
      createdAt: createdAt ?? this.createdAt,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      isVerified: isVerified ?? this.isVerified,
      passwordExpiration: passwordExpiration ?? this.passwordExpiration,
      deactivationTime: deactivationTime ?? this.deactivationTime,
      session: session ?? this.session,
      location: location ?? this.location,
      ip: ip ?? this.ip,
      avatar: avatar ?? this.avatar,
    );
  }

  factory UserEntity.fromAppwrite({
    required Document user,
    Session? session,
    MfaFactors? mfa,
    Document? config,
  }) {
    final passwordExpiration =
        config?.data['password_expiration']['value'] ?? '0';

    Map<String, dynamic> data = user.data;
    final role = data['role']['key'];
    final gender = data['gender']['name'];
    final activityStatus = data['activity_status']['status']['name'];
    final accountStatus = data['account_status']['status']['name'];
    final deactivationTime = data['account_status']['deactivation'];
    final lastPasswordUpdated = DateTime.parse(
      user.data['last_password_updated'],
    );

    final DateTime tempPasswordExpirationDate = lastPasswordUpdated.add(
      Duration(days: int.parse(passwordExpiration)),
    );

    final int daysRemaining =
        tempPasswordExpirationDate.difference(DateTime.now()).inDays;

    final passwordExpirationDate = lastPasswordUpdated.add(
      Duration(days: daysRemaining),
    );

    return UserEntity(
      uid: data['\$id'],
      readableName: user.data['readable_name'],
      firstName: user.data['first_name'],
      middleName: user.data['middle_name'],
      lastName: user.data['last_name'],
      email: user.data['email'],
      contactNumber: data['contact_number'],
      workAddress: data['work_address'],
      role: UserRole.values.firstWhere((r) => r.name.contains(role)),
      roleId: data['role']['\$id'],
      gender: Gender.values.firstWhere((g) => g.name.contains(gender)),
      mfaEnabled: data['mfa_enabled'],
      isVerified: data['is_verified'],
      isPhoneVerified: data['is_phone_verified'],
      isEmailVerified: data['is_email_verified'],
      lastPasswordUpdated: DateTime.parse(data['last_password_updated']),
      activityStatus: Status.values.firstWhere(
        (s) => s.name.contains(activityStatus),
      ),
      activityStatusId: data['activity_status']['\$id'],
      accountStatus: Status.values.firstWhere(
        (status) => status.name.contains(accountStatus),
      ),
      createdAt: DateTime.parse(user.$createdAt),
      passwordExpiration: passwordExpirationDate,
      session: session?.$id,
      location: session?.countryName,
      ip: session?.ip,
      deactivationTime:
          deactivationTime != null ? DateTime.tryParse(deactivationTime) : null,
    );
  }

  bool get isDoctor => UserRole.doctor == role;

  bool get isNurse => UserRole.nurse == role;
}
