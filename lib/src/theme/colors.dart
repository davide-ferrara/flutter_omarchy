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
    final alacritty = config.alacritty;
    if (alacritty == null) {
      return const OmarchyColorThemeData.tokyoNight();
    }

    final primary = alacritty.values['colors']['primary'];
    final bright = OmarchyAnsiColorThemeData.fromAlacritty(
      alacritty.values['colors']['bright'],
    );
    return OmarchyColorThemeData(
      foreground: _color(primary['foreground']),
      background: _color(primary['background']),
      border: _color(config.walker?.colors['border'], bright.blue),
      selectedText: _color(config.walker?.colors['selected-text'], bright.blue),
      normal: OmarchyAnsiColorThemeData.fromAlacritty(
        alacritty.values['colors']['normal'],
      ),
      bright: bright,
    );
  }

  const OmarchyColorThemeData.tokyoNight()
    : background = const Color(0xFF1a1b26),
      foreground = const Color(0xFFa9b1d6),
      border = const Color(0xFF33ccff),
      selectedText = const Color(0xFF7dcfff),
      normal = const OmarchyAnsiColorThemeData.tokyoNightNormal(),
      bright = const OmarchyAnsiColorThemeData.tokyoNightBright();

  final Color background;
  final Color foreground;
  final Color border;
  final Color selectedText;
  final OmarchyAnsiColorThemeData normal;
  final OmarchyAnsiColorThemeData bright;
}

enum AnsiColor { black, white, red, green, blue, yellow, magenta, cyan }

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

  const OmarchyAnsiColorThemeData.tokyoNightNormal()
    : black = const Color(0xFF32344a),
      white = const Color(0xFF787c99),
      red = const Color(0xFF787c99),
      green = const Color(0xFF787c99),
      yellow = const Color(0xFF787c99),
      blue = const Color(0xFF787c99),
      magenta = const Color(0xFF787c99),
      cyan = const Color(0xFF787c99);

  const OmarchyAnsiColorThemeData.tokyoNightBright()
    : black = const Color(0xFF444b6a),
      white = const Color(0xFFacb0d0),
      red = const Color(0xFFff7a93),
      green = const Color(0xFFb9f27c),
      yellow = const Color(0xFFff9e64),
      blue = const Color(0xFF7da6ff),
      magenta = const Color(0xFFbb9af7),
      cyan = const Color(0xFF0db9d7);

  final Color black;
  final Color white;
  final Color red;
  final Color green;
  final Color yellow;
  final Color blue;
  final Color magenta;
  final Color cyan;

  Color operator [](AnsiColor color) {
    return switch (color) {
      AnsiColor.black => black,
      AnsiColor.white => white,
      AnsiColor.red => red,
      AnsiColor.blue => blue,
      AnsiColor.green => green,
      AnsiColor.yellow => yellow,
      AnsiColor.magenta => magenta,
      AnsiColor.cyan => cyan,
    };
  }
}

Color _color(String? hex, [Color fallback = const Color(0xFF000000)]) {
  if (hex == null) return fallback;
  final buffer = StringBuffer();
  try {
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', '').replaceFirst('0x', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  } catch (_) {
    return fallback;
  }
}
