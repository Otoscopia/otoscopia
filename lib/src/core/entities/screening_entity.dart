// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:ionicons/ionicons.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/nurse/nurse.dart';

class ScreeningEntity {
  final String id;
  final String patient;
  final String assignment;
  final String historyOfIllness;
  final String remarks;
  final double temperature;
  final double weight;
  final double height;
  final bool similarCondition;
  final List<bool> chiefComplaint;
  final String chiefComplaintRemarks;
  final bool allergy;
  final String allergyRemarks;
  final bool undergoneSurgery;
  final String undergoneSurgeryRemarks;
  final bool medication;
  final String medicationRemarks;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RecordStatus status;

  ScreeningEntity({
    required this.id,
    required this.patient,
    required this.assignment,
    required this.historyOfIllness,
    required this.remarks,
    required this.temperature,
    required this.weight,
    required this.height,
    required this.similarCondition,
    required this.chiefComplaint,
    required this.chiefComplaintRemarks,
    required this.allergy,
    required this.allergyRemarks,
    required this.undergoneSurgery,
    required this.undergoneSurgeryRemarks,
    required this.medication,
    required this.medicationRemarks,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  IoniconsData get statusIcon {
    switch (status) {
      case RecordStatus.pending:
        return Ionicons.time_outline;
      case RecordStatus.followUp:
        return Ionicons.repeat_outline;
      case RecordStatus.medicalAttention:
        return Ionicons.warning_sharp;
      case RecordStatus.resolved:
        return Ionicons.checkmark_circle;
      default:
        return Ionicons.time_outline;
    }
  }

  Color get statusColor {
    switch (status) {
      case RecordStatus.pending:
        return Colors.yellow;
      case RecordStatus.followUp:
        return Colors.blue;
      case RecordStatus.medicalAttention:
        return Colors.red;
      case RecordStatus.resolved:
        return Colors.green;
      default:
        return AppColors.accentColor.darkest;
    }
  }

  String get statusString {
    switch (status) {
      case RecordStatus.pending:
        return 'Pending';
      case RecordStatus.followUp:
        return 'Follow Up';
      case RecordStatus.medicalAttention:
        return 'Medical Attention';
      case RecordStatus.resolved:
        return 'Resolved';
      default:
        return 'Pending';
    }
  }

  ScreeningEntity copyWith({
    String? id,
    String? patient,
    String? assignment,
    String? historyOfIllness,
    String? remarks,
    double? temperature,
    double? weight,
    double? height,
    bool? similarCondition,
    List<bool>? chiefComplaint,
    String? chiefComplaintRemarks,
    bool? allergy,
    String? allergyRemarks,
    bool? undergoneSurgery,
    String? undergoneSurgeryRemarks,
    bool? medication,
    String? medicationRemarks,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
    RecordStatus? status,
  }) {
    return ScreeningEntity(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      assignment: assignment ?? this.assignment,
      historyOfIllness: historyOfIllness ?? this.historyOfIllness,
      remarks: remarks ?? this.remarks,
      temperature: temperature ?? this.temperature,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      similarCondition: similarCondition ?? this.similarCondition,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      chiefComplaintRemarks:
          chiefComplaintRemarks ?? this.chiefComplaintRemarks,
      allergy: allergy ?? this.allergy,
      allergyRemarks: allergyRemarks ?? this.allergyRemarks,
      undergoneSurgery: undergoneSurgery ?? this.undergoneSurgery,
      undergoneSurgeryRemarks:
          undergoneSurgeryRemarks ?? this.undergoneSurgeryRemarks,
      medication: medication ?? this.medication,
      medicationRemarks: medicationRemarks ?? this.medicationRemarks,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'patients': patient,
      'assignment': assignment,
      'historyOfIllness': historyOfIllness,
      'remarks': remarks,
      'temperature': temperature,
      'weight': weight,
      'height': height,
      'similarCondition': similarCondition,
      'chiefComplaint': chiefComplaint,
      'chiefComplaintRemarks': chiefComplaintRemarks,
      'allergy': allergy,
      'allergyRemarks': allergyRemarks,
      'undergoneSurgery': undergoneSurgery,
      'undergoneSurgeryRemarks': undergoneSurgeryRemarks,
      'medication': medication,
      'medicationRemarks': medicationRemarks,
      'images': images,
      'status': status.toString(),
    };
  }

  static RecordStatus getStatus(String status) {
    switch (status) {
      case "RecordStatus.pending":
        return RecordStatus.pending;
      case "RecordStatus.followUp":
        return RecordStatus.followUp;
      case "RecordStatus.medicalAttention":
        return RecordStatus.medicalAttention;
      case "RecordStatus.resolved":
        return RecordStatus.resolved;
      default:
        return RecordStatus.pending;
    }
  }

  factory ScreeningEntity.fromMap(Map<String, dynamic> map) {
    RecordStatus status = getStatus(map['status']);

    return ScreeningEntity(
      id: map['\$id'] as String,
      patient: map['patients']['\$id'] as String,
      assignment: map['assignment']['\$id'] as String,
      historyOfIllness: map['historyOfIllness'] as String,
      remarks: map['remarks'] as String,
      temperature: double.parse(map['temperature'].toString()),
      weight: double.parse(map['weight'].toString()),
      height: double.parse(map['height'].toString()),
      similarCondition: map['similarCondition'] as bool,
      chiefComplaint: List<bool>.from(map['chiefComplaint']),
      chiefComplaintRemarks: map['chiefComplaintRemarks'] as String,
      allergy: map['allergy'] as bool,
      allergyRemarks: map['allergyRemarks'] as String,
      undergoneSurgery: map['undergoneSurgery'] as bool,
      undergoneSurgeryRemarks: map['undergoneSurgeryRemarks'] as String,
      medication: map['medication'] as bool,
      medicationRemarks: map['medicationRemarks'] as String,
      images: List<String>.from((map['images'])),
      createdAt: DateTime.parse(map['\$createdAt'] as String),
      updatedAt: DateTime.parse(map['\$updatedAt'] as String),
      status: status,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScreeningEntity.fromJson(String source) =>
      ScreeningEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScreeningEntity(id: $id, patient: $patient, assignment: $assignment, historyOfIllness: $historyOfIllness, remarks: $remarks, temperature: $temperature, weight: $weight, height: $height, similarCondition: $similarCondition, chiefComplaint: $chiefComplaint, chiefComplaintRemarks: $chiefComplaintRemarks, allergy: $allergy, allergyRemarks: $allergyRemarks, undergoneSurgery: $undergoneSurgery, undergoneSurgeryRemarks: $undergoneSurgeryRemarks, medication: $medication, medicationRemarks: $medicationRemarks, images: $images, createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
  }

  @override
  bool operator ==(covariant ScreeningEntity other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.patient == patient &&
        other.assignment == assignment &&
        other.historyOfIllness == historyOfIllness &&
        other.remarks == remarks &&
        other.temperature == temperature &&
        other.weight == weight &&
        other.height == height &&
        other.similarCondition == similarCondition &&
        other.chiefComplaint == chiefComplaint &&
        other.chiefComplaintRemarks == chiefComplaintRemarks &&
        other.allergy == allergy &&
        other.allergyRemarks == allergyRemarks &&
        other.undergoneSurgery == undergoneSurgery &&
        other.undergoneSurgeryRemarks == undergoneSurgeryRemarks &&
        other.medication == medication &&
        other.medicationRemarks == medicationRemarks &&
        listEquals(other.images, images) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        patient.hashCode ^
        assignment.hashCode ^
        historyOfIllness.hashCode ^
        remarks.hashCode ^
        temperature.hashCode ^
        weight.hashCode ^
        height.hashCode ^
        similarCondition.hashCode ^
        chiefComplaint.hashCode ^
        chiefComplaintRemarks.hashCode ^
        allergy.hashCode ^
        allergyRemarks.hashCode ^
        undergoneSurgery.hashCode ^
        undergoneSurgeryRemarks.hashCode ^
        medication.hashCode ^
        medicationRemarks.hashCode ^
        images.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        status.hashCode;
  }

  factory ScreeningEntity.initial() {
    return ScreeningEntity(
      id: '',
      patient: '',
      assignment: '',
      historyOfIllness: '',
      remarks: '',
      temperature: 0.0,
      weight: 0.0,
      height: 0.0,
      similarCondition: false,
      chiefComplaint: List.generate(complains.length, (index) => false),
      chiefComplaintRemarks: '',
      allergy: false,
      allergyRemarks: '',
      undergoneSurgery: false,
      undergoneSurgeryRemarks: '',
      medication: false,
      medicationRemarks: '',
      images: <String>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: RecordStatus.pending,
    );
  }

  factory ScreeningEntity.fromMedical(MedicalFormEntity medical, String patient,
      String assignment, List<String> images) {
    return ScreeningEntity(
      id: uuid.v4(),
      patient: patient,
      assignment: assignment,
      historyOfIllness: medical.historyOfIllness,
      remarks: medical.remarks,
      temperature: medical.temperature,
      weight: medical.weight,
      height: medical.height,
      similarCondition: medical.isSimilarCondition,
      chiefComplaint: medical.chiefComplains,
      chiefComplaintRemarks: medical.chiefComplaintRemarks,
      allergy: medical.isAllergy,
      allergyRemarks: medical.allergyRemarks,
      undergoneSurgery: medical.isUndergoneSurgery,
      undergoneSurgeryRemarks: medical.undergoneSurgeryRemarks,
      medication: medical.isMedication,
      medicationRemarks: medical.medicationRemarks,
      images: images,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: RecordStatus.pending,
    );
  }

  String get chiefComplaintString {
    final chiefComplainString = List.generate(chiefComplaint.length, (index) {
      if (chiefComplaint[index]) {
        switch (index) {
          case 0:
            return 'Ear Pain';
          case 1:
            return 'Hearing Loss';
          case 2:
            return 'Tinnitus';
          case 3:
            return 'Ear Discharge';
          case 4:
            return 'Others';
          default:
            return '';
        }
      } else {
        return '';
      }
    }).toString();

    final arrayComplains = chiefComplainString
        .substring(1, chiefComplainString.length - 1)
        .split(', ');
    final nonEmptyComplains =
        arrayComplains.where((element) => element.isNotEmpty).toList();
    final joinedComplains = nonEmptyComplains.asMap().entries.map((entry) {
      final index = entry.key;
      final complain = entry.value;

      if (index == nonEmptyComplains.length - 1) {
        return complain;
      } else if (index == nonEmptyComplains.length - 2) {
        return '$complain and ';
      } else {
        return '$complain, ';
      }
    }).join();

    return joinedComplains;
  }
}
