import 'package:flutter/material.dart' as m3;

import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';

class SchoolsTable extends ConsumerWidget {
  const SchoolsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schools = ref.read(schoolsProvider);
    final source = SchoolTableSource(ref, schools);
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
        columns: const [
          DataColumn2(label: Text(kAbbr), fixedWidth: 175),
          DataColumn2(label: Text(kName)),
          DataColumn2(label: Text(kAddress)),
        ],
      ),
    );
  }
}

class SchoolTableSource extends m3.DataTableSource {
  final WidgetRef ref;
  final List<SchoolEntity> _schools;

  SchoolTableSource(this.ref, this._schools);

  @override
  m3.DataRow? getRow(int index) {
    return DataRow2(
      cells: [
        m3.DataCell(CustomText(_schools[index].abbr)),
        m3.DataCell(CustomText(_schools[index].name)),
        m3.DataCell(CustomText(_schools[index].address)),
      ],
      onSelectChanged: (value) {
        ref.read(schoolsTabProvider.notifier).addTab(_schools[index]);
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _schools.length;

  @override
  int get selectedRowCount => 0;
}
