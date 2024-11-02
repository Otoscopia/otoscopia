import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/settings/settings.dart';

import 'change_password_dialog.dart';
import 'disable_mfa_function.dart';
import 'enable_mfa_function.dart';

class AccountSecurity extends ConsumerWidget {
  const AccountSecurity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const width = 150.0;

    final user = ref.read(userProvider)!;
    final authenticatorApp = user.mfaFactors.totp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoundedBackground(
          child: ListTile(
            leading: const Icon(FluentIcons.authenticator_app),
            title: const CustomText('Enable/Disable Authenticator App'),
            subtitle: const CustomText(
                'Enable or disable authenticator app for your account'),
            trailing: Button(
              onPressed: () async => authenticatorApp
                  ? disableMfaFunction(context)
                  : enableMfaFunction(context, ref),
              child: CustomText(authenticatorApp
                  ? 'Disable Authenticator App'
                  : 'Enable Authenticator App'),
            ),
          ),
        ),
        const Gap(4),
        RoundedBackground(
          child: ListTile(
            leading: const Icon(FluentIcons.lock),
            title: const CustomText('Change Password'),
            subtitle: const CustomText('Change your account password'),
            trailing: SizedBox(
              width: width,
              child: Button(
                onPressed: () async => changePasswordDialog(context),
                child: const CustomText('Change Password'),
              ),
            ),
          ),
        ),
        const Gap(4),
        const RoundedBackground(
          child: ListTile(
            leading: Icon(FluentIcons.delete),
            title: CustomText('Delete Account'),
            subtitle:
                CustomText('Ask admin to delete your account permanently'),
            trailing: SizedBox(
              width: width,
              child: Button(
                onPressed: null,
                child: CustomText('Delete Account'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
