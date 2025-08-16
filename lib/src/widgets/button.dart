import 'package:flutter_omarchy/flutter_omarchy.dart';
import 'package:flutter_omarchy/src/theme/colors.dart';
import 'package:flutter_omarchy/src/widgets/utils/default_foreground.dart';
import 'package:flutter_omarchy/src/widgets/utils/pointer_area.dart';

class OmarchyButtonStyleData {
  const OmarchyButtonStyleData({
    required this.normal,
    required this.focused,
    required this.pressed,
    required this.disabled,
    required this.hovering,
  });
  final OmarchyButtonStyleStateData normal;
  final OmarchyButtonStyleStateData focused;
  final OmarchyButtonStyleStateData pressed;
  final OmarchyButtonStyleStateData disabled;
  final OmarchyButtonStyleStateData hovering;

  OmarchyButtonStyleStateData fromPointer(PointerState state) =>
      switch (state) {
        PointerState(isPressed: true) => pressed,
        PointerState(isHovering: true) => hovering,
        PointerState(hasFocus: true) => focused,
        PointerState(isEnabled: false) => disabled,
        _ => normal,
      };
}

typedef OmarchyButtonStyleStateData = ({
  Color border,
  Color foreground,
  Color background,
});

abstract class OmarchyButtonStyle {
  const OmarchyButtonStyle();
  const factory OmarchyButtonStyle.primary([AnsiColor accent]) =
      PrimaryOmarchyButtonStyle;

  OmarchyButtonStyleData resolve(BuildContext context);
}

class PrimaryOmarchyButtonStyle extends OmarchyButtonStyle {
  const PrimaryOmarchyButtonStyle([this.accent = AnsiColor.white]);
  final AnsiColor accent;

  @override
  OmarchyButtonStyleData resolve(BuildContext context) {
    final omarchy = Omarchy.of(context).theme;
    final bright = omarchy.colors.bright[accent];
    final normal = omarchy.colors.normal[accent];
    return switch (accent) {
      // TODO
      _ => OmarchyButtonStyleData(
        normal: (
          border: normal,
          background: normal.withValues(alpha: 0),
          foreground: bright,
        ),
        pressed: (
          border: bright,
          background: normal.withValues(alpha: 0.25),
          foreground: bright,
        ),
        focused: (
          border: bright,
          background: normal.withValues(alpha: 0),
          foreground: bright,
        ),
        hovering: (
          border: normal,
          background: normal.withValues(alpha: 0.15),
          foreground: bright,
        ),
        disabled: (
          border: normal.withValues(alpha: 0.5),
          background: normal.withValues(alpha: 0),
          foreground: normal,
        ),
      ),
    };
  }
}

class OmarchyButton extends StatelessWidget {
  const OmarchyButton({
    super.key,
    required this.child,
    this.onPressed,
    this.style = const PrimaryOmarchyButtonStyle(),
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final OmarchyButtonStyle style;
  final EdgeInsets padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final style = this.style.resolve(context);
    return PointerArea(
      onTap: onPressed,
      child: child,
      builder: (context, state, child) {
        final stateStyle = style.fromPointer(state);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: stateStyle.background,
            border: BoxBorder.all(width: 2, color: stateStyle.border),
          ),
          padding: const EdgeInsets.all(16),
          child: DefaultForeground(
            foreground: stateStyle.foreground,
            child: child!,
          ),
        );
      },
    );
  }
}
