// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:example/calculator.dart';
import 'package:example/counter.dart';
import 'package:example/file_explorer.dart';
import 'package:example/gallery.dart';
import 'package:example/markdown_editor.dart';
import 'package:example/pomodoro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_omarchy/flutter_omarchy.dart';

enum App {
  gallery,
  counter,
  calculator,
  file_explorer,
  markdown_editor,
  pomodoro;

  Widget build() {
    return switch (this) {
      App.counter => const CounterApp(),
      App.gallery => const GalleryApp(),
      App.calculator => const CalculatorApp(),
      App.file_explorer => const FileExplorerApp(),
      App.markdown_editor => const MarkdownEditorApp(),
      App.pomodoro => const PomodoroApp(),
    };
  }
}

Future<void> main() async {
  final demo = kIsWeb || !Platform.isLinux;
  await Omarchy.initialize();
  if (demo) {
    return runApp(OmarchyDemo());
  }
  final app = App.gallery;
  runApp(app.build());
}

class OmarchyDemo extends StatefulWidget {
  const OmarchyDemo({super.key});

  @override
  State<OmarchyDemo> createState() => _OmarchyDemoState();
}

class _OmarchyDemoState extends State<OmarchyDemo> {
  var app = 0;
  @override
  Widget build(BuildContext context) {
    final colors = OmarchyColorThemes.tokyoNight;
    const text = OmarchyTextStyleData.fallback();
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Container(
            height: 24,
            decoration: BoxDecoration(color: colors.background),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              scrollDirection: Axis.horizontal,
              children: [
                PointerArea(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Icon(
                        OmarchyIcons.devGithub,
                        color: colors.normal.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                for (final app in App.values)
                  PointerArea(
                    onTap: () {
                      setState(() {
                        this.app = app.index;
                      });
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          app.name.toUpperCase(),
                          style: text.normal.copyWith(
                            fontSize: 11,
                            color: app.index == this.app
                                ? colors.selectedText
                                : colors.foreground,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
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
                    border: Border.all(color: colors.border, width: 2),
                  ),
                  child: Opacity(
                    opacity: 0.98,
                    child: IndexedStack(
                      index: app,
                      children: [for (final app in App.values) app.build()],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
