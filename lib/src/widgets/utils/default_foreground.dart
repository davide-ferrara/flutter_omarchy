import 'package:flutter/widgets.dart';

class DefaultForeground extends StatelessWidget {
  const DefaultForeground({
    super.key,
    required this.foreground,
    required this.child,
    this.fontSize,
  });

  final Widget child;
  final Color? foreground;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyle(fontSize: fontSize, color: foreground),
      child: IconTheme(
        data: IconThemeData(
          color: foreground,
          size: fontSize != null ? fontSize! * 1.2 : null,
        ),
        child: child,
      ),
    );
  }
}
