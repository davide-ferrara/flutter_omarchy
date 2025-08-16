import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/omarchy.dart';
import 'package:flutter_omarchy/src/theme/colors.dart';
import 'package:flutter_omarchy/src/widgets/utils/default_foreground.dart';
import 'package:flutter_omarchy/src/widgets/utils/grouping.dart';
import 'package:flutter_omarchy/src/widgets/utils/side_positioning.dart';

class OmarchyStatusBar extends StatelessWidget {
  const OmarchyStatusBar({super.key, this.leading, this.trailing});

  final List<Widget>? leading;
  final List<Widget>? trailing;

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context);
    return Container(
      color: omarchy.theme.colors.normal.black,
      child: Row(
        children: [
          if (leading case final leading?)
            SidePositioning(
              position: SidePosition.leading,
              child: Row(children: [...leading.group()]),
            ),
          if (trailing case final trailing?)
            SidePositioning(
              position: SidePosition.leading,
              child: Row(children: [...trailing..group()].reversed.toList()),
            ),
        ],
      ),
    );
  }
}

enum OmarchyStatusColor { black, blue }

class OmarchyStatus extends StatelessWidget {
  const OmarchyStatus({
    super.key,
    required this.child,
    this.accent = AnsiColor.white,
  });

  final Widget child;
  final AnsiColor accent;

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context);
    final normal = omarchy.theme.colors.normal[accent];
    final bright = omarchy.theme.colors.bright[accent];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      color: normal.withValues(alpha: 0.3),
      child: DefaultForeground(foreground: bright, child: child),
    );
  }
}
