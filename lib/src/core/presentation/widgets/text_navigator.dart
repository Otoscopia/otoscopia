import 'package:fluent_ui/fluent_ui.dart';

class TextNavigator extends StatelessWidget {
  const TextNavigator(
    this.text, {
    super.key,
    this.child,
    this.bold = true,
    this.pop = false,
  });

  final String text;
  final String? child;
  final bool bold;
  final bool pop;

  @override
  Widget build(BuildContext context) {
    return HyperlinkButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.isHovered) return FluentTheme.of(context).accentColor;
          return FluentTheme.of(context).typography.body!.color;
        }),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onPressed: () =>
          pop ? Navigator.pop(context) : Navigator.pushNamed(context, child!),
    );
  }
}
