import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/authentication/authentication.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _form = SignInFormEntity();

  @override
  Widget build(BuildContext context) {
    return ApplicationContainer(
      child: CenterCard(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 440,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Logo(height: 32),
                const Gap(16),
                const Text(kSignIn, style: TextStyle(fontSize: 24)),
                const Gap(12),
                EmailTextInput(emailController: _form.emailController),
                const Gap(16),
                PasswordFormBox(
                  controller: _form.passwordController,
                  placeholder: kPassword,
                  onEditingComplete: onClick,
                ),
                const Gap(16),
                const TextNavigator(
                  kNoAccount,
                  bold: false,
                  child: NamedGuest.register,
                ),
                const TextNavigator(
                  kAccountNotAccessible,
                  bold: false,
                  child: NamedGuest.forgotPassword,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_isLoading) signInBtn() else const ProgressRing(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Button signInBtn() {
    return Button(
      child: const Text(kSignInBtn),
      onPressed: () async {
        if (_form.isValid) await onClick();
      },
    );
  }

  Future<void> onClick() async {
    setState(() => _isLoading = true);
    if (_formKey.currentState!.validate()) {
      try {
        final user = await ref
            .read(authenticationProvider.notifier)
            .login(_form);

        ref.read(userProvider.notifier).setUser(user);
        await ref.read(fetchDataProvider.notifier).fetch(user);

        if (user.uid.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          });
        }
      } on Exception catch (error) {
        if (error.toString().contains('user_more_factors_required')) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.push(
              context,
              FluentPageRoute(builder: (context) => const Mfa()),
            ),
          );
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback(
          (_) => popUpInfoBar(kErrorTitle, error.toString(), context),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
