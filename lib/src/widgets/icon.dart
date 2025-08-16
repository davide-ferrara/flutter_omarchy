import 'package:flutter/widgets.dart';

const _font = 'CaskaydiaMono Nerd Font';
const _package = 'flutter_omarchy';

abstract class OmarchyIcons {
  static const dev = OmarchyDevIcons();
}

class OmarchyDevIcons {
  const OmarchyDevIcons();
  final facebook = const IconData(
    0xe7d4,
    fontFamily: _font,
    fontPackage: _package,
  );
}
