import 'package:flutter/material.dart';
import 'package:flutter_omarchy/src/omarchy.dart';

class OmarchyTooltip extends StatelessWidget {
  const OmarchyTooltip({
    super.key,
    required this.child,
    this.richMessage,
    this.message,
  });

  final String? message;
  final InlineSpan? richMessage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context);
    return Tooltip(
      message: message,
      decoration: BoxDecoration(color: omarchy.theme.colors.normal.black),
      textStyle: omarchy.theme.text.normal.copyWith(
        color: omarchy.theme.colors.bright.white,
      ),
      richMessage: richMessage,
      child: child,
    );
  }
}
