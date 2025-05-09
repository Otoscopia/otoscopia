import 'package:flutter/material.dart' as m3;

import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';

class PatientsTable extends ConsumerWidget {
  const PatientsTable({super.key, this.isMedicalRecords = false});
  final bool isMedicalRecords;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.read(patientsProvider);
    final source = PatientsTableSource(ref, patients);
    final role = ref.read(userProvider)!.role;
    final nurse = role == UserRole.nurse;
    return Card(
      padding: EdgeInsets.zero,
      child: PaginatedDataTable2(
        dividerThickness: 0,
        showCheckboxColumn: false,
        minWidth: 1000,
        empty: const Center(child: Text(kNoDataAvailable)),
        headingRowColor: const m3.WidgetStatePropertyAll(Colors.transparent),
        sortArrowAlwaysVisible: true,
        rowsPerPage: 20,
        source: source,
        columns: [
          const DataColumn2(label: Text(kName)),
          const DataColumn2(label: Text(kAgeAndGender), fixedWidth: 150),
          const DataColumn2(label: Text(kSchool)),
          if (nurse) const DataColumn2(label: Text(kDoctor)),
          if (!nurse) const DataColumn2(label: Text(kNurse)),
        ],
      ),
    );
  }
}

class PatientsTableSource extends m3.DataTableSource {
  final WidgetRef ref;
  final List<PatientEntity> _patients;

  PatientsTableSource(this.ref, this._patients);

  @override
  m3.DataRow? getRow(int index) {
    final patient = _patients[index];
    final age = DateTime.now().difference(patient.birthDate).inDays ~/ 365;
    final gender = patient.gender == Gender.male ? kGenders[0] : kGenders[1];
    final school =
        ref.read(schoolsProvider.notifier).findById(patient.school).name;
    final doctor = patient.doctor?['readable_name'];

    return DataRow2(
      cells: [
        m3.DataCell(CustomText(patient.name)),
        m3.DataCell(CustomText("$age/$gender")),
        m3.DataCell(CustomText(school)),
        m3.DataCell(CustomText(doctor)),
      ],
      onSelectChanged: (value) {
        ref.read(patientsTabProvider.notifier).addTab(patient);
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _patients.length;

  @override
  int get selectedRowCount => 0;
}
