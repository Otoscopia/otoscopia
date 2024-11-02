import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/link.dart';

class CustomHyperLink extends StatelessWidget {
  const CustomHyperLink(
    this.text, {
    super.key,
    required this.to,
  });

  final String to;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(to),
      builder: (context, followLink) => HyperlinkButton(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.isHovered) {
              return FluentTheme.of(context).accentColor;
            }
            return FluentTheme.of(context).typography.body!.color;
          }),
        ),
        onPressed: followLink,
        child: Text(text),
      ),
    );
  }
}
