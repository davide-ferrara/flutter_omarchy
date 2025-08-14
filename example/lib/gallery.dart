import 'package:flutter_omarchy/flutter_omarchy.dart';

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OmarchyApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget selected = sections.first.$2;

  List<(String, Widget)> sections = [('Theme', const ThemePage())];

  @override
  Widget build(BuildContext context) {
    return OmarchyScaffold(
      child: Row(
        children: [
          Menu(
            sections: sections,
            onSectionSelected: (value) {
              setState(() {
                selected = value;
              });
            },
          ),
          Expanded(child: selected),
        ],
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({
    super.key,
    required this.sections,
    required this.onSectionSelected,
  });

  final List<(String, Widget)> sections;
  final ValueChanged<Widget> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ListView(
        children: [
          for (var item in sections)
            OmarchyButton(
              onPressed: () {
                onSectionSelected(item.$2);
              },
              child: Text(item.$1),
            ),
        ],
      ),
    );
  }
}

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [Text('Colors'), const SizedBox(height: 12), Colors()],
    );
  }
}

class Colors extends StatelessWidget {
  const Colors({super.key});

  @override
  Widget build(BuildContext context) {
    final omarchy = Omarchy.of(context).theme.colors;
    final base = [
      ('background', omarchy.background),
      ('foreground', omarchy.foreground),
      ('border', omarchy.border),
      ('selectedText', omarchy.selectedText),
    ];
    final normal = [
      ('normal.black', omarchy.normal.black),
      ('normal.white', omarchy.normal.white),
      ('normal.red', omarchy.normal.red),
      ('normal.green', omarchy.normal.green),
      ('normal.blue', omarchy.normal.blue),
      ('normal.cyan', omarchy.normal.cyan),
      ('normal.magenta', omarchy.normal.magenta),
      ('normal.yellow', omarchy.normal.yellow),
    ];
    final bright = [
      ('bright.black', omarchy.bright.black),
      ('bright.white', omarchy.bright.white),
      ('bright.red', omarchy.bright.red),
      ('bright.green', omarchy.bright.green),
      ('bright.blue', omarchy.bright.blue),
      ('bright.cyan', omarchy.bright.cyan),
      ('bright.magenta', omarchy.bright.magenta),
      ('bright.yellow', omarchy.bright.yellow),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        for (var group in [base, normal, bright])
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var (name, color) in group)
                Container(width: 20, height: 20, color: color),
            ],
          ),
      ],
    );
  }
}
