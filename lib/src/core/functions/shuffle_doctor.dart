import 'dart:math';

import 'package:otoscopia/src/core/core.dart';

UserEntity shuffleDoctor(List<UserEntity> doctors) {
  int index = Random.secure().nextInt(doctors.length);

  doctors.shuffle(Random(Random().nextInt(1000)));

  return doctors[index];
}
