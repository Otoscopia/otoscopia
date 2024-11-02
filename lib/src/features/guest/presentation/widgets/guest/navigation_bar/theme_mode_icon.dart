import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';

import 'package:otoscopia/src/features/settings/settings.dart';

class ThemeModeIcon extends ConsumerWidget {
  const ThemeModeIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(settingsProvider).themeMode;
    IoniconsData iconData = themeMode == ThemeMode.system
        ? Ionicons.invert_mode
        : themeMode == ThemeMode.light
            ? Ionicons.sunny
            : Ionicons.moon;

    return IconButton(
      icon: Icon(iconData, size: 18),
      onPressed: () => ref.read(settingsProvider.notifier).setThemeMode(
          themeMode == ThemeMode.system ? ThemeMode.light : ThemeMode.dark),
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.isHovered) return FluentTheme.of(context).accentColor;
          return FluentTheme.of(context).typography.body!.color;
        }),
      ),
    );
  }
}
