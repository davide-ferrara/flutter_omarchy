import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/omarchy.dart';
import 'package:flutter_omarchy/src/widgets/resize_divider.dart';

class OmarchyScaffold extends StatefulWidget {
  const OmarchyScaffold({
    super.key,
    required this.child,
    this.leadingMenu,
    this.status,
    this.minLeadingMenuWidth = 50.0,
    this.maxLeadingMenuWidth = 500.0,
  });

  final Widget child;
  final Widget? leadingMenu;
  final Widget? status;
  final double minLeadingMenuWidth;
  final double maxLeadingMenuWidth;

  @override
  State<OmarchyScaffold> createState() => _OmarchyScaffoldState();
}

class _OmarchyScaffoldState extends State<OmarchyScaffold> {
  var leadingMenuWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context).theme;
    var child = widget.child;
    if (widget.leadingMenu case final menu?) {
      child = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(key: Key('menu'), width: leadingMenuWidth, child: menu),
          OmarchyResizeDivider(
            key: Key('divider'),
            min: widget.minLeadingMenuWidth,
            max: widget.maxLeadingMenuWidth,
            size: leadingMenuWidth,
            onSizeChanged: (v) => setState(() {
              leadingMenuWidth = v;
            }),
          ),
          Expanded(key: Key('content'), child: child),
        ],
      );
    }

    if (widget.status case final status?) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(key: Key('main'), child: child),
          status,
        ],
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      color: omarchy.colors.background,
      child: child,
    );
  }
}
