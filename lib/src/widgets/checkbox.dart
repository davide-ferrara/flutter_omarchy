import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/omarchy.dart';
import 'package:flutter_omarchy/src/theme/colors.dart';
import 'package:flutter_omarchy/src/widgets/icon_data.g.dart';

enum CheckboxState { checked, unchecked, multiple }

class OmarchyCheckbox extends StatelessWidget {
  const OmarchyCheckbox({
    super.key,
    CheckboxState? state,
    bool isChecked = false,
    this.accent,
    this.size,
  }) : state =
           state ??
           (isChecked ? CheckboxState.checked : CheckboxState.unchecked);

  final CheckboxState state;
  final AnsiColor? accent;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = Omarchy.of(context).theme;
    final foreground = accent != null
        ? theme.colors.bright[accent!]
        : theme.colors.foreground;
    final background = accent != null
        ? theme.colors.normal[accent!].withValues(alpha: 0.4)
        : theme.colors.bright.black;
    final isSelected = switch (state) {
      CheckboxState.unchecked => false,
      CheckboxState.checked || CheckboxState.multiple => true,
    };
    final size = this.size ?? (theme.text.normal.fontSize ?? 12) * 1.2;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isSelected ? background : background.withValues(alpha: 0),
        border: Border.all(
          color: isSelected ? foreground : theme.colors.normal.white,
          width: 2,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 120),
        child: IconTheme(
          data: IconThemeData(color: foreground, size: size * 0.6),
          child: switch (state) {
            CheckboxState.checked => const Icon(OmarchyIcons.codCheck),
            CheckboxState.unchecked => const SizedBox.shrink(),
            CheckboxState.multiple => Container(
              color: foreground,
              margin: const EdgeInsets.all(4.0),
            ),
          },
        ),
      ),
    );
  }
}
