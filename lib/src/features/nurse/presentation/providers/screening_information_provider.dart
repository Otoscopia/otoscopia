import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/nurse/nurse.dart';

part 'screening_information_provider.g.dart';

@Riverpod(keepAlive: true)
class ScreeningInformation extends _$ScreeningInformation {
  @override
  ScreeningEntity? build() {
    return null;
  }

  void setScreening(MedicalFormEntity medical) {
    final patient = ref.read(patientProvider)!;
    state = ScreeningEntity.fromMedical(medical, patient.id, state!.images);
  }

  void setImage(String image) {
    state = state!.copyWith(images: [...state!.images, image]);
  }

  void resetInformation() => state = null;

  Future<void> removeImage(String image) async {
    final earPosition = image.split("\\").last.toLowerCase().contains("left")
        ? "left"
        : "right";
    final imagePosition = state!.images
        .where((element) => element.toLowerCase().contains(earPosition))
        .toList();

    final length = imagePosition.length;

    if (length == 1) {
      throw Exception("You can't remove the last image");
    }

    File file = File(image);
    try {
      await file.delete();
      state = state!.copyWith(images: state!.images..remove(image));
    } catch (e) {
      throw Exception("Error deleting the image");
    }
  }
}
