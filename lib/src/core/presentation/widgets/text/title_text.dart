import 'package:fluent_ui/fluent_ui.dart';

class TitleText extends StatelessWidget {
  const TitleText(
    this.text, {
    super.key,
    this.center = false,
    this.withOpacity = false,
  });

  final String text;
  final bool? center;
  final bool withOpacity;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: center! ? TextAlign.center : TextAlign.start,
      style: FluentTheme.of(context).typography.title!.copyWith(
        color:
            withOpacity
                ? FluentTheme.of(
                  context,
                ).typography.title!.color!.withValues(alpha: 0.6)
                : null,
      ),
    );
  }
}
