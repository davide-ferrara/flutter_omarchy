import 'package:flutter_omarchy/src/config/config.dart';
import 'package:flutter_omarchy/src/theme/colors.dart';
import 'package:flutter_omarchy/src/theme/text.dart';

class OmarchyThemeData {
  const OmarchyThemeData({required this.colors, required this.text});

  final OmarchyColorThemeData colors;
  final OmarchyTextStyleData text;

  static OmarchyThemeData fromConfig(OmarchyConfigData config) {
    final colors = OmarchyColorThemeData.fromConfig(config);
    final text = OmarchyTextStyleData.fromConfig(config);
    return OmarchyThemeData(
      colors: colors,
      text: OmarchyTextStyleData(
        bold: text.bold.copyWith(color: colors.foreground),
        normal: text.normal.copyWith(color: colors.foreground),
        italic: text.italic.copyWith(color: colors.foreground),
      ),
    );
  }
}
