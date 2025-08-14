import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/config/config.dart';

class OmarchyColorThemeData {
  const OmarchyColorThemeData({
    required this.background,
    required this.foreground,
    required this.border,
    required this.selectedText,
    required this.normal,
    required this.bright,
  });

  factory OmarchyColorThemeData.fromConfig(OmarchyConfigData config) {
    final primary = config.alacritty.values['colors']['primary'];
    return OmarchyColorThemeData(
      foreground: _color(primary['foreground']),
      background: _color(primary['background']),
      border: _color(config.walker.colors['border']),
      selectedText: _color(config.walker.colors['selected-text']),
      normal: OmarchyAnsiColorThemeData.fromAlacritty(
        config.alacritty.values['colors']['normal'],
      ),
      bright: OmarchyAnsiColorThemeData.fromAlacritty(
        config.alacritty.values['colors']['bright'],
      ),
    );
  }

  final Color background;
  final Color foreground;
  final Color border;
  final Color selectedText;
  final OmarchyAnsiColorThemeData normal;
  final OmarchyAnsiColorThemeData bright;
}

class OmarchyAnsiColorThemeData {
  const OmarchyAnsiColorThemeData({
    required this.black,
    required this.white,
    required this.red,
    required this.green,
    required this.yellow,
    required this.blue,
    required this.magenta,
    required this.cyan,
  });

  factory OmarchyAnsiColorThemeData.fromAlacritty(Map<String, dynamic> config) {
    return OmarchyAnsiColorThemeData(
      black: _color(config['black']),
      white: _color(config['white']),
      red: _color(config['red']),
      yellow: _color(config['yellow']),
      blue: _color(config['blue']),
      magenta: _color(config['magenta']),
      cyan: _color(config['cyan']),
      green: _color(config['green']),
    );
  }
  final Color black;
  final Color white;
  final Color red;
  final Color green;
  final Color yellow;
  final Color blue;
  final Color magenta;
  final Color cyan;
}

Color _color(String? hex) {
  if (hex == null) return Color(0xFF000000);
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', '').replaceFirst('0x', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
