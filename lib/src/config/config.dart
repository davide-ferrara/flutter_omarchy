import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_omarchy/src/config/alacritty.dart';
import 'package:flutter_omarchy/src/config/walker.dart';

class OmarchyConfigData {
  const OmarchyConfigData({required this.alacritty, required this.walker});

  final AlacrittyConfig? alacritty;
  final WalkerConfig? walker;

  static OmarchyConfigData read() {
    if (kIsWeb || !Platform.isLinux) {
      return OmarchyConfigData(alacritty: null, walker: null);
    }
    return OmarchyConfigData(
      alacritty: AlacrittyConfig.read(),
      walker: WalkerConfig.read(),
    );
  }

  static Stream<OmarchyConfigData> watch() async* {
    if (AlacrittyConfig.file.existsSync()) {
      await for (final _ in AlacrittyConfig.file.watch()) {
        yield read();
      }
    }
  }
}
