import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/authentication/authentication.dart';

part 'table_provider.g.dart';

@Riverpod(keepAlive: true)
class Table extends _$Table {
  @override
  List<TableEntity> build() {
    return [];
  }

  void setTable(
    List<PatientEntity> patients,
    List<ScreeningEntity> screenings,
    List<RemarksEntity> remarks,
  ) {
    patients.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final tables =
        screenings.map((screening) {
          final patient = patients.firstWhere(
            (patient) => patient.id == screening.patient,
          );

          final remark = remarks.where(
            (element) => element.screening == screening.id,
          );

          if (remark.length > 1) {
            remarks.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          }

          return TableEntity(
            patient: patient,
            screening: screening,
            remarks: remark.firstOrNull,
          );
        }).toList();

    final data = tables.reversed.toList();

    tables.sort((a, b) {
      if (a.remarks != null && b.remarks == null) {
        return 1;
      } else if (a.remarks == null && b.remarks != null) {
        return -1;
      } else {
        return 0;
      }
    });

    state = data;
  }

  int findTableByPatientId(String id) =>
      state.indexWhere((element) => element.patient.id == id);

  void addTable(TableEntity table) {
    final index = findTableByPatientId(table.patient.id);
    if (index >= 0) {
      removeTable(index);
    }

    state = [...state, table];
  }

  void updateTable(TableEntity table) {
    final index = findTableByPatientId(table.patient.id);
    if (index >= 0) {
      state[index] = table;
    }
  }

  void removeTable(int index) => state.removeAt(index);

  void fromPatientSnapshot(Map<String, dynamic> snapshot) async {
    final user = ref.read(userProvider)!;
    final patient = PatientEntity.fromMap(snapshot);

    if (patient.doctor == user.uid) {
      final screening = await ref
          .read(fetchDataProvider.notifier)
          .getScreeningsByPatientId(patient.id);
      addTable(TableEntity(patient: patient, screening: screening));
      ref.read(patientsProvider.notifier).addPatient(patient);
      ref.read(screeningsProvider.notifier).addScreening(screening);
    } else if (user.role == UserRole.nurse) {
      final assignments = ref.read(assignmentsProvider);
      final AssignmentEntity? assignment =
          assignments
              .where((element) => element.school == patient.school)
              .firstOrNull;

      if (assignment != null) {
        ref.read(patientsProvider.notifier).addPatient(patient);
      }
    }
  }

  void fromScreeningSnapshot(Map<String, dynamic> snapshot) {
    final user = ref.read(userProvider)!;
    final patient = PatientEntity.fromMap(snapshot['patient']);

    if (patient.doctor == user.uid) {
      final screening = ScreeningEntity.fromMap(snapshot);
      addTable(TableEntity(patient: patient, screening: screening));
      ref.read(patientsProvider.notifier).addPatient(patient);
      ref.read(screeningsProvider.notifier).addScreening(screening);
    } else if (user.role == UserRole.nurse) {
      final assignments = ref.read(assignmentsProvider);
      final AssignmentEntity? assignment =
          assignments
              .where((element) => element.school == patient.school)
              .firstOrNull;

      if (assignment != null) {
        final screening = ScreeningEntity.fromMap(snapshot);
        ref.read(patientsProvider.notifier).addPatient(patient);
        addTable(TableEntity(patient: patient, screening: screening));
        ref.read(patientsProvider.notifier).addPatient(patient);
        ref.read(screeningsProvider.notifier).addScreening(screening);
      }
    }
  }

  void fromRemarksSnapshot(Map<String, dynamic> snapshot) {
    final user = ref.read(userProvider)!;
    final patientName = snapshot['screening']['patient']['name'];
    final patient = ref.read(patientsProvider.notifier).findByName(patientName);

    if (patient != null) {
      if (patient.doctor == user.uid) {
        final screening = ScreeningEntity.fromMap(snapshot['screening']);
        final remarks = RemarksEntity.fromMap(snapshot);

        addTable(
          TableEntity(patient: patient, screening: screening, remarks: remarks),
        );
        ref.read(patientsProvider.notifier).addPatient(patient);
        ref.read(screeningsProvider.notifier).addScreening(screening);
        ref.read(screeningsProvider.notifier).addScreening(screening);
      } else if (user.role == UserRole.nurse) {
        final assignments = ref.read(assignmentsProvider);
        final AssignmentEntity? assignment =
            assignments
                .where((element) => element.school == patient.school)
                .firstOrNull;

        if (assignment != null) {
          final screening = ScreeningEntity.fromMap(snapshot['screening']);
          final remarks = RemarksEntity.fromMap(snapshot);

          ref.read(patientsProvider.notifier).addPatient(patient);
          ref.read(screeningsProvider.notifier).addScreening(screening);
          addTable(
            TableEntity(
              patient: patient,
              screening: screening,
              remarks: remarks,
            ),
          );
        }
      }
    }
  }
}
