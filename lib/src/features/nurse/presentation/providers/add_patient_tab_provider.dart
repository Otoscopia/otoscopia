import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/features/nurse/nurse.dart';

part 'add_patient_tab_provider.g.dart';

@Riverpod(keepAlive: true)
class AddPatientTab extends _$AddPatientTab {
  static final tabs = [
    Tab(
      text: const Text("Patient Information"),
      body: const AddPatientInformation(),
    ),
  ];
  @override
  List<Tab> build() {
    return tabs;
  }

  void addLeftCamera() {
    final int index = state.indexWhere(
      (Tab tab) => (tab.text as Text).data == "Left Ear",
    );

    if (!(index != -1)) {
      late final Tab tab;
      tab = Tab(
        text: const Text("Left Ear"),
        body: const CameraScreen(0),
      );

      state = [...state, tab];
      ref.read(addPatientIndexProvider.notifier).setIndex(state.length - 1);
    } else {
      ref.read(addPatientIndexProvider.notifier).setIndex(index);
    }
  }

  void addRightCamera() {
    final int index = state.indexWhere(
      (Tab tab) => (tab.text as Text).data == "Right Ear",
    );

    if (!(index != -1)) {
      late final Tab tab;
      tab = Tab(
        text: const Text("Right Ear"),
        body: const CameraScreen(1),
      );

      state = [...state, tab];
      ref.read(addPatientIndexProvider.notifier).setIndex(state.length - 1);
    } else {
      ref.read(addPatientIndexProvider.notifier).setIndex(index);
    }
  }

  void addScreeningInformation() {
    final int index = state.indexWhere(
      (Tab tab) => (tab.text as Text).data == "Screening Information",
    );

    if (!(index != -1)) {
      late final Tab tab;
      tab = Tab(
        text: const Text("Screening Information"),
        body: const ScreeningInformationScreen(),
      );

      state = [...state, tab];
      ref.read(addPatientIndexProvider.notifier).setIndex(state.length - 1);
    } else {
      ref.read(addPatientIndexProvider.notifier).setIndex(index);
    }
  }

  void addReview() {
    final int index = state.indexWhere(
      (Tab tab) => (tab.text as Text).data == "Review",
    );

    if (!(index != -1)) {
      late final Tab tab;
      tab = Tab(
        text: const Text("Review"),
        body: const Reviews(),
      );

      state = [...state, tab];
      ref.read(addPatientIndexProvider.notifier).setIndex(state.length - 1);
    } else {
      ref.read(addPatientIndexProvider.notifier).setIndex(index);
    }
  }

  void resetTabs() {
    state = tabs;
    ref.read(addPatientIndexProvider.notifier).setIndex(0);
  }
}

@Riverpod(keepAlive: true)
class AddPatientIndex extends _$AddPatientIndex {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) => state = index;
}
