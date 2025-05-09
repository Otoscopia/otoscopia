import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/settings/settings.dart';

class UserAccount extends ConsumerStatefulWidget {
  const UserAccount({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserAccountState();
}

class _UserAccountState extends ConsumerState<UserAccount> {
  final _controllers = UserAccountControllers();
  bool enableEditing = false;

  @override
  void initState() {
    final user = ref.read(userProvider)!;

    _controllers.update(
      name: user.readableName,
      email: user.email,
      phone: user.contactNumber,
      address: user.workAddress,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: InfoLabel(
                label: "Full Name",
                child: TextFormBox(
                  controller: _controllers.nameController,
                  enabled: enableEditing,
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              child: InfoLabel(
                label: "Contact Number",
                child: TextFormBox(
                  controller: _controllers.phoneController,
                  enabled: enableEditing,
                ),
              ),
            ),
          ],
        ),
        const Gap(16),
        InfoLabel(
          label: "Clinic Address",
          child: TextFormBox(
            controller: _controllers.addressController,
            enabled: enableEditing,
          ),
        ),
        const Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 150,
              child: FilledButton(
                onPressed: enableEditing ? saveInformation : editInformation,
                child: Text(
                  enableEditing ? "Save Information" : "Edit Information",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void saveInformation() {
    final user = ref.read(userProvider.notifier);
    user.updateInformation(
      name: _controllers.nameController.text,
      phone: _controllers.phoneController.text,
      workAddress: _controllers.addressController.text,
    );

    editInformation();
  }

  void editInformation() {
    setState(() {
      enableEditing = !enableEditing;
    });
  }
}
