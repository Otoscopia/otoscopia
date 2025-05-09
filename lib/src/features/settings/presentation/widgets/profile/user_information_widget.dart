import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:otoscopia/src/core/core.dart';

class UserInformation extends ConsumerWidget {
  const UserInformation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final role = user.role.name.uppercaseFirst();
    return Row(
      children: [
        CircularImage(user.avatar ?? 'https://picsum.photos/200', size: 100.0),
        const Gap(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(user.readableName.toUpperCase(), style: 4),
            CustomText(user.email),
            CustomText(role),
          ],
        ),
      ],
    );
  }
}
