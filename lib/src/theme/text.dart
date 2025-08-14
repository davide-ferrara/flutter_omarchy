import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_omarchy/src/config/config.dart';

class OmarchyTextStyleData {
  const OmarchyTextStyleData({required this.normal});
  final TextStyle normal;

  factory OmarchyTextStyleData.fromConfig(OmarchyConfigData config) {
    final font = config.alacritty.values['font'];
    return OmarchyTextStyleData(normal: _textStyle(font['normal']));
  }

  Future<void> loadFonts() {
    return OmarchyFonts.instance.load({normal.fontFamily!});
  }
}

TextStyle _textStyle(Map<String, dynamic> map) {
  return TextStyle(
    fontSize: 12,
    fontFamily: map['family'],
    fontWeight: switch (map['style']) {
      'Bold' => FontWeight.bold,
      _ => FontWeight.normal,
    },
    decoration: TextDecoration.none,
  );
}

class OmarchyFonts {
  static OmarchyFonts instance = OmarchyFonts();

  final Map<String, OmarchyFont> systemFonts = {};

  bool _initialized = false;

  Future<void> _initialize() async {
    if (!_initialized) {
      final list = await Process.run('fc-list', [
        "--format=%{file}:%{family}:%{style}\\n",
      ]);
      final lines = const LineSplitter().convert(list.stdout);

      for (var line in lines) {
        final parts = line.split(':');
        if (parts.length > 2) {
          final file = parts[0];
          final family = parts[1].split(',').first;
          final style = parts[2];

          print('$family $style $file');

          final systemFont = systemFonts.putIfAbsent(
            family,
            () => OmarchyFont(name: family, styles: []),
          );
          systemFonts[family] = OmarchyFont(
            name: family,
            styles: [
              ...systemFont.styles,
              OmarchyFontStyle(file: file, style: style),
            ],
          );
        }
      }
      print('Listed ${systemFonts.length} fonts');
      _initialized = true;
    }
  }

  Future<void> load(Set<String> families) async {
    await _initialize();
    for (var family in families) {
      print('Family $family');
      final systemFont = systemFonts[family];
      print(systemFont);
      if (systemFont != null && !systemFont.isLoaded) {
        await systemFont.load();
      }
    }
  }
}

class OmarchyFont {
  const OmarchyFont({
    required this.name,
    required this.styles,
    this.isLoaded = false,
  });
  final String name;
  final List<OmarchyFontStyle> styles;
  final bool isLoaded;

  Future<OmarchyFont> load() async {
    final loader = FontLoader(name);
    for (var style in styles) {
      final file = File(style.file);
      print('Load $file');
      if (file.existsSync()) {
        print('Exists $file');
        loader.addFont(
          file.readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
        );
      }
    }
    await loader.load();
    return OmarchyFont(name: name, styles: styles, isLoaded: true);
  }
}

class OmarchyFontStyle {
  const OmarchyFontStyle({required this.style, required this.file});
  final String? style;
  final String file;
}
