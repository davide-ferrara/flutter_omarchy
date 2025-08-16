import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/omarchy.dart';
import 'package:flutter_omarchy/src/widgets/utils/pointer_area.dart';

class OmarchyResizeDivider extends StatefulWidget {
  const OmarchyResizeDivider({
    super.key,

    required this.size,
    required this.min,
    required this.max,
    required this.onSizeChanged,
    this.direction = Axis.horizontal,
  });

  final Axis direction;
  final double size;
  final double min;
  final double max;
  final ValueChanged<double> onSizeChanged;

  @override
  State<OmarchyResizeDivider> createState() => _OmarchyResizeDividerState();
}

class _OmarchyResizeDividerState extends State<OmarchyResizeDivider> {
  late double current;

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context);
    return PointerArea(
      hoverCursor: SystemMouseCursors.resizeLeftRight,
      onPanStart: (_) {
        current = widget.size;
      },
      onPanUpdate: (details) {
        final delta = switch (widget.direction) {
          Axis.horizontal => details.delta.dx,
          Axis.vertical => details.delta.dy,
        };
        current = (current + delta).clamp(widget.min, widget.max);
        widget.onSizeChanged(current);
      },
      builder: (context, pointer, _) => Container(
        width: switch (widget.direction) {
          Axis.horizontal => 4,
          Axis.vertical => double.infinity,
        },
        height: switch (widget.direction) {
          Axis.vertical => 4,
          Axis.horizontal => double.infinity,
        },
        color: switch (pointer) {
          PointerState(isPressed: true) => omarchy.theme.colors.bright.white,
          PointerState(isHovering: true) => omarchy.theme.colors.bright.black,
          _ => omarchy.theme.colors.normal.black,
        },
      ),
    );
  }
}
