import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'schools_tabs_provider.g.dart';

@Riverpod(keepAlive: true)
class SchoolsTab extends _$SchoolsTab {
  static final List<Tab> _tabs = [
    Tab(
      text: const Text(kHome),
      icon: const Icon(FluentIcons.home),
      closeIcon: null,
      semanticLabel: kHome,
      body: const SchoolsTable(),
    ),
  ];

  @override
  List<Tab> build() {
    return _tabs;
  }

  void addTab(SchoolEntity school) {
    final int index =
        state.indexWhere((Tab tab) => (tab.text as Text).data == school.name);

    if (!(index != -1)) {
      late final Tab tab;
      tab = Tab(
        text: Text(school.name),
        icon: const Icon(FluentIcons.home),
        semanticLabel: school.name,
        body: SchoolsInfo(school),
        onClosed: () {
          state = state..remove(tab);
        },
      );

      state = [...state, tab];
      ref.read(schoolsIndexProvider.notifier).setIndex(state.length - 1);
    } else {
      ref.read(schoolsIndexProvider.notifier).setIndex(index);
    }
  }
}

@Riverpod(keepAlive: true)
class SchoolsIndex extends _$SchoolsIndex {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) => state = index;
}
