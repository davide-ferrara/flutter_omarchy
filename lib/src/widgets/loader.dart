import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/omarchy.dart';
import 'package:flutter_omarchy/src/theme/colors.dart';

class OmarchyLoader extends StatefulWidget {
  const OmarchyLoader({
    super.key,
    this.color,
    this.size,
    this.period = const Duration(milliseconds: 500),
    this.accent,
  });

  final Color? color;
  final double? size;
  final Duration period;
  final AnsiColor? accent;

  @override
  State<OmarchyLoader> createState() => _OmarchyLoaderState();
}

class _OmarchyLoaderState extends State<OmarchyLoader>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(vsync: this);
  @override
  void initState() {
    super.initState();
    controller.repeat(period: widget.period);
  }

  @override
  void didUpdateWidget(covariant OmarchyLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.period != oldWidget.period) {
      controller.repeat(period: widget.period);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context);
    final color =
        widget.color ??
        switch (widget.accent) {
          AnsiColor accent => omarchy.theme.colors.bright[accent],
          null => omarchy.theme.colors.foreground,
        };
    final size =
        widget.size ?? (omarchy.theme.text.normal.fontSize ?? 12) * 0.8;
    return CustomPaint(
      size: Size(size, size),
      foregroundPainter: _Painter(color: color, anim: controller),
    );
  }
}

class _Painter extends CustomPainter {
  const _Painter({required this.color, required this.anim})
    : super(repaint: anim);
  final Animation<double> anim;
  final Color color;
  double get time => anim.value;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width / 4
      ..style = PaintingStyle.stroke
      ..shader = RadialGradient(
        radius: 0.6,
        center: Alignment(
          math.sin(time * 2 * math.pi),
          math.cos(time * 2 * math.pi),
        ),
        colors: [color, color.withValues(alpha: 0.1)],
        stops: [0.0, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _Painter oldDelegate) {
    return oldDelegate.color != color;
  }
}
