import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:otoscopia/src/config/config.dart';
import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/authentication/authentication.dart';

class Mfa extends ConsumerStatefulWidget {
  const Mfa({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MfaState();
}

class _MfaState extends ConsumerState<Mfa> {
  final mfaController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ApplicationContainer(
      child: CenterCard(
        child: SizedBox(
          width: 440,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Logo(height: 32),
                  Gap(16),
                  Text("Authenticate your account",
                      style: TextStyle(fontSize: 20)),
                  Gap(12),
                  Text(
                      "Your account has MFA enabled. Please confirm your account by entering the code generated by your authenticator app.",
                      textAlign: TextAlign.center),
                  Gap(12),
                  Divider(),
                ],
              ),
              const Gap(12),
              InfoLabel(
                label: "OTP Verification Code",
                child: TextBox(
                  controller: mfaController,
                ),
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TextNavigator(kGoBackBtn, pop: true, bold: false),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isLoading) confirmBtn() else const ProgressRing(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Button confirmBtn() {
    return Button(
        child: const Text("Verify OTP"),
        onPressed: () async {
          setState(() => isLoading = true);

          try {

          final user = await ref
              .read(authenticationProvider.notifier)
              .confirmMfa(mfaController.text);

          ref.read(userProvider.notifier).setUser(user);
          await ref.read(fetchDataProvider.notifier).fetch(user);
          await secureStorage.write(key: 'session', value: user.sessionId);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          });
          } catch (error) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => popUpInfoBar(
                kErrorTitle,
                error.toString(),
                context,
              ),
            );
          } finally {
            setState(() => isLoading = false);
          }
        });
  }
}