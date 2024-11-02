import 'package:flutter/material.dart' as m3;

import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';

import 'package:otoscopia/src/core/core.dart';

class CustomTable extends ConsumerWidget {
  const CustomTable({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserRole role = ref.read(userProvider)!.role;
    bool nurse = role == UserRole.nurse;
    bool doctor = role == UserRole.doctor;

    final data = ref.watch(tableProvider);

    m3.DataTableSource source = TableSource(ref, data, context);

    final isWeb = getDeviceType() == DeviceType.web;
    final isMobile = getDeviceType() == DeviceType.mobile;

    final mobile = isMobile == true
        ? isMobile
        : isWeb && MediaQuery.of(context).size.width < 400;

    return Card(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          PaginatedDataTable2(
            dividerThickness: 0,
            showCheckboxColumn: false,
            minWidth: mobile ? 500 : 1200,
            empty: const Center(child: Text(kNoDataAvailable)),
            headingRowColor:
                const m3.WidgetStatePropertyAll(Colors.transparent),
            sortArrowAlwaysVisible: true,
            rowsPerPage: 20,
            columns: [
              DataColumn2(
                label: const Text(kName),
                size: mobile ? ColumnSize.L : ColumnSize.M,
              ),
              if (!mobile)
                const DataColumn2(
                    label: Text(kAgeAndGender), size: ColumnSize.S),
              DataColumn2(
                  label: const Text(kStatus), fixedWidth: mobile ? 175 : null),
              if (!mobile) const DataColumn2(label: Text(kSchool)),
              if (!mobile)
                if (nurse) const DataColumn2(label: Text(kDoctor)),
              if (!mobile)
                if (doctor) const DataColumn2(label: Text(kNurse)),
            ],
            source: source,
          ),
          if (nurse)
            Positioned(
              bottom: 20,
              right: 240,
              child: HyperlinkButton(
                child: const Text(kAddPatient),
                onPressed: () {
                  ref.read(dashboardTabProvider.notifier).addPatient();
                },
              ),
            ),
        ],
      ),
    );
  }
}

class TableSource extends m3.DataTableSource {
  final WidgetRef ref;
  final List<TableEntity> _data;
  final BuildContext _context;

  TableSource(this.ref, this._data, this._context);

  @override
  m3.DataRow? getRow(int index) {
    final role = ref.read(userProvider)!.isNurse;
    final table = _data[index];
    final patient = table.patient;

    final school = ref.read(schoolsProvider.notifier).findById(patient.school);
    final assignment =
        ref.read(assignmentsProvider.notifier).findBySchool(school.id);
    final nurse = ref.read(nursesProvider.notifier).findById(assignment.nurse);
    final doctor = ref.read(doctorsProvider.notifier).findById(patient.doctor);
    final age = DateTime.now().difference(patient.birthDate).inDays ~/ 365;
    final icon = table.remarks?.statusIcon ?? Ionicons.time_outline;
    final status = table.remarks?.statusString ?? "Pending";
    final gender = patient.gender == Gender.male ? "Male" : "Female";

    final isWeb = getDeviceType() == DeviceType.web;
    final isMobile = getDeviceType() == DeviceType.mobile;

    final mobile = isMobile == true
        ? isMobile
        : isWeb && MediaQuery.of(_context).size.width < 400;

    final hasRemarks = table.remarks != null;

    final isDark = FluentTheme.of(_context).brightness == Brightness.dark;

    final style = role ? 7 : (hasRemarks ? 0 : 5);

    return DataRow2(
      color: role && !hasRemarks
          ? null
          : isDark
              ? const m3.WidgetStatePropertyAll(Color(0xFF1d2224))
              : const m3.WidgetStatePropertyAll(Color(0xFFabb1b4)),
      onSelectChanged: (value) {
        ref.read(dashboardTabProvider.notifier).addTab(table);
      },
      cells: [
        m3.DataCell(CustomText(patient.name, style: style)),
        if (!mobile) m3.DataCell(CustomText("$age/$gender", style: style)),
        m3.DataCell(m3.Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            const Gap(4),
            CustomText(status, style: style),
          ],
        )),
        if (!mobile) m3.DataCell(CustomText(school.name, style: style)),
        if (!mobile && role) m3.DataCell(CustomText(doctor.name, style: style)),
        if (!mobile && !role) m3.DataCell(CustomText(nurse.name, style: style)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  void sortByName<T>(
      Comparable<T> Function(TableEntity d) getField, bool ascending) {
    _data.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }
}
