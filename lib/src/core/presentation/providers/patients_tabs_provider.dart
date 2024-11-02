import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'patients_tabs_provider.g.dart';

@Riverpod(keepAlive: true)
class PatientsTab extends _$PatientsTab {
  static final _tabs = [
    Tab(
      text: const Text("Patients"),
      icon: const Icon(FluentIcons.health),
      closeIcon: null,
      semanticLabel: "Patients",
      body: const PatientsTable(),
    ),
  ];

  @override
  List<Tab> build() {
    return _tabs;
  }

  bool findTab(PatientEntity patient) {
    final index =
        state.indexWhere((Tab tab) => (tab.text as Text).data == patient.name);

    if (index != -1) {
      ref.read(patientsIndexProvider.notifier).setIndex(index);
    }

    return !(index != -1);
  }

  void addTab(PatientEntity patient) {
    if (findTab(patient)) {
      late final Tab tab;
      tab = Tab(
        text: Text(patient.name),
        icon: const Icon(FluentIcons.contact_heart),
        semanticLabel: patient.name,
        body: PatientsInfo(patient),
        onClosed: () {
          state = state..remove(tab);
        },
      );

      state = [...state, tab];
      ref.read(patientsIndexProvider.notifier).setIndex(state.length - 1);
    }
  }
}

@Riverpod(keepAlive: true)
class PatientsIndex extends _$PatientsIndex {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) => state = index;
}
