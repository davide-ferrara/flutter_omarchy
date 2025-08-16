import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/theme/colors.dart';

abstract class OmarchyColorThemes {
  static const tokyoNight = OmarchyColorThemeData(
    background: Color(0xFF1a1b26),
    foreground: Color(0xFFa9b1d6),
    border: Color(0xFF33ccff),
    selectedText: Color(0xFF7dcfff),
    normal: OmarchyAnsiColorThemeData(
      black: Color(0xFF32344a),
      white: Color(0xFF787c99),
      red: Color(0xFFf7768e),
      green: Color(0xFF9ece6a),
      yellow: Color(0xFFe0af68),
      blue: Color(0xFF7aa2f7),
      magenta: Color(0xFFad8ee6),
      cyan: Color(0xFF449dab),
    ),
    bright: OmarchyAnsiColorThemeData(
      black: Color(0xFF444b6a),
      white: Color(0xFF787c99),
      red: Color(0xFFff7aa3),
      green: Color(0xFFb9f27c),
      yellow: Color(0xFFff9e64),
      blue: Color(0xFF7da6ff),
      magenta: Color(0xFFbb9af7),
      cyan: Color(0xFF0db9d7),
    ),
  );

  static const rosepine = OmarchyColorThemeData(
    background: Color(0xFFfaf4ed),
    foreground: Color(0xFF575279),
    border: Color(0xFF575279),
    selectedText: Color(0xFF88C0D0),
    normal: OmarchyAnsiColorThemeData(
      black: Color(0xFFf2e9e1),
      white: Color(0xFF575279),
      red: Color(0xFFb4637a),
      green: Color(0xFF286983),
      yellow: Color(0xFFea9d34),
      blue: Color(0xFF56949f),
      magenta: Color(0xFF907aa9),
      cyan: Color(0xFFd7827e),
    ),
    bright: OmarchyAnsiColorThemeData(
      black: Color(0xFF9893a5),
      white: Color(0xFF575279),
      red: Color(0xFFb4637a),
      green: Color(0xFF286983),
      yellow: Color(0xFFea9d34),
      blue: Color(0xFF56949f),
      magenta: Color(0xFF907aa9),
      cyan: Color(0xFFd7827e),
    ),
  );
}
