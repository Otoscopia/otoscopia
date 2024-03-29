import 'package:fluent_ui/fluent_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

Widget responsiveBuilder(Widget child) {
  return ResponsiveBreakpoints.builder(
    child: child,
    breakpoints: [
      const Breakpoint(start: 0, end: 450, name: MOBILE),
      const Breakpoint(start: 451, end: 800, name: TABLET),
      const Breakpoint(start: 801, end: 1920, name: DESKTOP),
      const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
    ],
  );
}
