import 'package:flutter_omarchy/src/config/alacritty.dart';
import 'package:flutter_omarchy/src/config/walker.dart';

class OmarchyConfigData {
  const OmarchyConfigData({required this.alacritty, required this.walker});

  final AlacrittyConfig alacritty;
  final WalkerConfig walker;

  static OmarchyConfigData read() {
    return OmarchyConfigData(
      alacritty: AlacrittyConfig.read(),
      walker: WalkerConfig.read(),
    );
  }

  static Stream<OmarchyConfigData> watch() async* {
    await for (final _ in AlacrittyConfig.file.watch()) {
      yield read();
    }
  }
}
