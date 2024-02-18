import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/nurse/nurse.dart';

class LocalImage extends ConsumerStatefulWidget {
  const LocalImage(this._images, {super.key, required this.index});
  final List _images;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocalImageState();
}

class _LocalImageState extends ConsumerState<LocalImage> {
  @override
  Widget build(BuildContext context) {
    final images = widget._images;
    return Stack(
      children: [
        Image.file(
          File(images[widget.index]),
          fit: BoxFit.cover,
          width: 350,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Ionicons.close_circle),
            onPressed: () async {
              try {
                await ref
                    .read(screeningInformationProvider.notifier)
                    .removeImage(images[widget.index]);
                setState(() {});
              } catch (e) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  popUpInfoBar(kErrorTitle, e.toString(), context);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
