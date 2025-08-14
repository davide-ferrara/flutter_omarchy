import 'dart:io';

class WalkerConfig {
  const WalkerConfig(this.colors);
  final Map<String, String> colors;

  static WalkerConfig read() {
    final config = file.readAsStringSync();

    final colors = <String, String>{};
    final regex = RegExp(
      r'\@define-color\s+([a-zA-Z0-9-_+]+)\s+\#([a-fA-F0-9]+)',
    );

    for (final match in regex.allMatches(config)) {
      colors[match[1]!] = match[2]!;
    }

    return WalkerConfig(colors);
  }

  static File get file {
    final home = Platform.environment['HOME'];
    return File('$home/.config/omarchy/current/theme/walker.css');
  }

  static Stream<WalkerConfig> watch() async* {
    await for (final _ in file.watch()) {
      yield read();
    }
  }
}
