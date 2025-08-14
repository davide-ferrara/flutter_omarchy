import 'package:example/counter.dart';
import 'package:example/gallery.dart';
import 'package:flutter_omarchy/flutter_omarchy.dart';

enum App { counter, gallery }

Future<void> main() async {
  await Omarchy.initialize();
  final app = App.gallery;
  runApp(switch (app) {
    App.counter => const CounterApp(),
    App.gallery => const GalleryApp(),
  });
}
