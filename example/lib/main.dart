import 'dart:io';

import 'package:example/counter.dart';
import 'package:example/gallery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_omarchy/flutter_omarchy.dart';

enum App { counter, gallery }

Future<void> main() async {
  await Omarchy.initialize();
  final app = App.gallery;
  Widget result = switch (app) {
    App.counter => const CounterApp(),
    App.gallery => const GalleryApp(),
  };
  if (kIsWeb || !Platform.isLinux) {
    result = SimulatedOmarchy(result: result);
  }
  runApp(result);
}

class SimulatedOmarchy extends StatelessWidget {
  const SimulatedOmarchy({super.key, required this.result});

  final Widget result;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/wallpaper.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(14.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0x88000000), width: 0.5),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF33ccff), width: 2),
          ),
          child: Opacity(opacity: 0.98, child: result),
        ),
      ),
    );
  }
}
