import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/omarchy.dart';

class OmarchyScaffold extends StatelessWidget {
  const OmarchyScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context).theme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      color: omarchy.colors.background,
      child: child,
    );
  }
}
