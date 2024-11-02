import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'screenings_provider.g.dart';

@Riverpod(keepAlive: true)
class Screenings extends _$Screenings {
  @override
  List<ScreeningEntity> build() {
    return [];
  }

  void setScreenings(List<ScreeningEntity> screenings) => state = screenings;

  void removeScreening(int index) => state.removeAt(index);

  List<ScreeningEntity> findByPatientId(String patientId) {
    return state.where((screening) => screening.patient == patientId).toList();
  }

  int findByScreeningId(String screeningId) {
    return state.indexWhere((screening) => screening.id == screeningId);
  }

  void addScreening(ScreeningEntity screening) {
    final index = findByScreeningId(screening.id);
    if (index >= 0) {
      removeScreening(index);
    }

    state = [...state, screening];
  }

  updateStatus(ScreeningEntity screening) {
    final index = findByScreeningId(screening.id);
    if (index >= 0) {
      state[index] = screening;
    }
  }
}
