import 'package:flutter/services.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:otoscopia/src/core/core.dart';
import 'package:otoscopia/src/features/authentication/authentication.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final _form = SignUpFormEntity();

  late List<TreeViewItem> items;

  final roles = accountRole
      .map((item) => ComboBoxItem(value: item, child: Text(item)))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SizedBox(
        width: 440,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(kSignUp, style: TextStyle(fontSize: 24)),
            const Gap(12),
            EmailTextInput(emailController: _form.emailController),
            const Gap(16),
            PasswordFormBox(
              controller: _form.passwordController,
              placeholder: kPassword,
              onEditingComplete: onClick,
            ),
            const Gap(16),
            TextFormBox(
              placeholder: kFullName,
              controller: _form.nameController,
            ),
            const Gap(16),
            TextFormBox(
              placeholder: kPhoneNumber,
              controller: _form.phoneController,
              prefix: const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(kCountryCode),
              ),
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\+]'))
              ],
            ),
            const Gap(16),
            TextFormBox(
              placeholder: kWorkAddress,
              controller: _form.addressController,
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: ComboBox(
                    isExpanded: true,
                    placeholder: const Text(kRole),
                    items: roles,
                    value: _form.role,
                    onChanged: (value) => setState(() {
                      if (value == kDoctor) {
                        _form.schools.clear();
                      }
                      _form.role = value!;
                    }),
                  ),
                ),
                if (_form.role == kNurse) const Gap(16),
                if (_form.role == kNurse)
                  FutureBuilder(
                    future: getSchools(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ProgressRing();
                      }

                      final schools = ref.read(schoolsProvider);

                      items = schools
                          .map((item) => TreeViewItem(
                                content: Text(item.name),
                                value: item,
                              ))
                          .toList();

                      return Button(
                        child: const Text(kAddSchools),
                        onPressed: () => showContentDialog(context),
                      );
                    },
                  ),
              ],
            ),
            const Gap(16),
            const TextNavigator(kAlreadyHaveAnAccount, pop: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isLoading) signUpBtn() else const ProgressRing(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showContentDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 550),
        title: const Text(kSelectAssignedSchools),
        content: TreeView(
            items: items,
            selectionMode: TreeViewSelectionMode.multiple,
            onItemInvoked: (item, reason) async {
              final school = item.value as SchoolEntity;

              if (_form.schools.contains(school.id)) {
                _form.schools.remove(school.id);
              } else {
                _form.schools.add(school.id);
              }
            }),
        actions: [
          Button(
            child: const Text(kCancelBtn),
            onPressed: () {
              Navigator.pop(context);
              _form.schools.clear();
            },
          ),
          FilledButton(
            child: const Text(kSaveBtn),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
    setState(() {});
  }

  Button signUpBtn() {
    return Button(
        child: const Text(kSignUpBtn),
        onPressed: () async {
          if (_form.isValid) {
            await onClick();
          } else {
            popUpInfoBar(kInvalidForm, kFillAllFields, context);
          }
        });
  }

  Future<void> onClick() async {
    setState(() => isLoading = true);
    if (formKey.currentState!.validate()) {
      try {
        final response =
            await ref.read(authenticationProvider.notifier).signUp(_form);

        if (response) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
            popUpInfoBar(
              kAccountCreated,
              kCheckEmail,
              context,
              barSeverity: InfoBarSeverity.success,
            );
          });
        }
      } on Exception catch (error) {
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
    }
  }

  Future<bool> getSchools() async {
    try {
      await ref.read(fetchDataProvider.notifier).getUnAssignedSchools();
      return true;
    } catch (e) {
      return false;
    }
  }
}
