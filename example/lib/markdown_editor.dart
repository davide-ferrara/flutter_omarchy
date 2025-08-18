import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_omarchy/flutter_omarchy.dart';

import 'package:markdown_widget/widget/all.dart';

class MarkdownEditorApp extends StatelessWidget {
  const MarkdownEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OmarchyApp(
      debugShowCheckedModeBanner: false,
      home: const MarkdownEditorPage(),
    );
  }
}

class MarkdownEditorPage extends StatefulWidget {
  const MarkdownEditorPage({super.key});

  @override
  State<MarkdownEditorPage> createState() => _MarkdownEditorPageState();
}

class _MarkdownEditorPageState extends State<MarkdownEditorPage> {
  final MarkdownEditingController _controller = MarkdownEditingController();
  bool _showPreview = false;
  final _previewKey = GlobalKey();
  var _previewWidth = 400.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OmarchyScaffold(
      navigationBar: OmarchyNavigationBar(
        title: const Text('Markdown Editor'),
        trailing: [
          OmarchyButton(
            onPressed: () {
              setState(() {
                _showPreview = !_showPreview;
              });
            },
            child: Text(_showPreview ? 'Edit' : 'Preview'),
          ),
        ],
      ),
      status: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return OmarchyStatusBar(
            trailing: [
              OmarchyStatus(
                child: Text('${_controller.text.length} characters'),
              ),
            ],
          );
        },
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: OmarchyTextInput(
              controller: _controller,
              padding: const EdgeInsets.all(24),
              maxLines: null,
            ),
          ),
          if (_showPreview) ...[
            OmarchyResizeDivider(
              size: _previewWidth,
              min: 150,
              max: 700,
              onSizeChanged: (v) {
                setState(() {
                  _previewWidth = v;
                });
              },
            ),
            SizedBox(
              key: _previewKey,
              width: _previewWidth,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return MarkdownPreview(markdown: _controller.text);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MarkdownEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final spans = buildSpans(text, context, style);
    return TextSpan(children: spans);
  }

  List<TextSpan> buildSpans(
    String text,
    BuildContext context,
    TextStyle? style,
  ) {
    final theme = OmarchyTheme.of(context);
    final spans = <TextSpan>[];

    if (text.isEmpty) {
      return spans;
    }

    // Track the current position in the text
    int currentPosition = 0;

    // Define regex patterns for markdown elements
    final headerPattern = RegExp(r'^(#{1,6})\s+(.+?)$', multiLine: true);
    final boldPattern = RegExp(r'\*\*(.+?)\*\*');
    final italicPattern = RegExp(r'\*(.+?)\*');
    final codePattern = RegExp(r'`(.+?)`');
    final linkPattern = RegExp(r'\[(.+?)\]\((.+?)\)');
    final listItemPattern = RegExp(r'^(\s*[-*+]\s+)(.+?)$', multiLine: true);
    final blockquotePattern = RegExp(r'^(>\s+)(.+?)$', multiLine: true);

    // Find all matches for each pattern
    final allMatches = <RegExpMatch>[];

    headerPattern.allMatches(text).forEach((match) => allMatches.add(match));
    boldPattern.allMatches(text).forEach((match) => allMatches.add(match));
    italicPattern.allMatches(text).forEach((match) => allMatches.add(match));
    codePattern.allMatches(text).forEach((match) => allMatches.add(match));
    linkPattern.allMatches(text).forEach((match) => allMatches.add(match));
    listItemPattern.allMatches(text).forEach((match) => allMatches.add(match));
    blockquotePattern
        .allMatches(text)
        .forEach((match) => allMatches.add(match));

    // Sort matches by start position
    allMatches.sort((a, b) => a.start.compareTo(b.start));

    // Process matches in order
    for (final match in allMatches) {
      // Add plain text before the match
      if (match.start > currentPosition) {
        spans.add(
          TextSpan(
            text: text.substring(currentPosition, match.start),
            style: style,
          ),
        );
      }

      // Process the match based on its pattern
      if (match.pattern == headerPattern) {
        final headerLevel = match.group(1)!.length;
        final headerText = match.group(2)!;

        // Add the header markers
        spans.add(
          TextSpan(
            text: match.group(1)! + ' ',
            style: style?.copyWith(
              color: theme.colors.bright.magenta,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

        // Add the header text
        spans.add(
          TextSpan(
            text: headerText,
            style: style?.copyWith(
              color: theme.colors.bright.magenta,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (match.pattern == boldPattern) {
        // Add the bold markers and text
        spans.add(
          TextSpan(
            text: '**',
            style: style?.copyWith(fontWeight: FontWeight.bold),
          ),
        );

        spans.add(
          TextSpan(
            text: match.group(1),
            style: style?.copyWith(fontWeight: FontWeight.bold),
          ),
        );

        spans.add(
          TextSpan(
            text: '**',
            style: style?.copyWith(fontWeight: FontWeight.bold),
          ),
        );
      } else if (match.pattern == italicPattern) {
        // Add the italic markers and text
        spans.add(
          TextSpan(
            text: '*',
            style: style?.copyWith(fontStyle: FontStyle.italic),
          ),
        );

        spans.add(
          TextSpan(
            text: match.group(1),
            style: style?.copyWith(fontStyle: FontStyle.italic),
          ),
        );

        spans.add(
          TextSpan(
            text: '*',
            style: style?.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      } else if (match.pattern == codePattern) {
        // Add the code markers and text
        spans.add(TextSpan(text: '`'));

        spans.add(TextSpan(text: match.group(1), style: style?.copyWith()));

        spans.add(TextSpan(text: '`'));
      } else if (match.pattern == linkPattern) {
        // Add the link text and URL
        spans.add(
          TextSpan(
            text: '[',
            style: style?.copyWith(color: theme.colors.bright.blue),
          ),
        );

        spans.add(
          TextSpan(
            text: match.group(1),
            style: style?.copyWith(
              color: theme.colors.bright.blue,
              decorationColor: theme.colors.bright.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Link tap handling could be added here
              },
          ),
        );

        spans.add(
          TextSpan(
            text: '](',
            style: style?.copyWith(color: theme.colors.bright.blue),
          ),
        );

        spans.add(
          TextSpan(
            text: match.group(2),
            style: style?.copyWith(
              color: theme.colors.bright.blue,
              fontStyle: FontStyle.italic,
            ),
          ),
        );

        spans.add(
          TextSpan(
            text: ')',
            style: style?.copyWith(color: theme.colors.bright.blue),
          ),
        );
      } else if (match.pattern == listItemPattern) {
        // Add the list item marker
        spans.add(
          TextSpan(
            text: match.group(1),
            style: style?.copyWith(fontWeight: FontWeight.bold),
          ),
        );

        // Add the list item text
        spans.add(TextSpan(text: match.group(2), style: style));
      } else if (match.pattern == blockquotePattern) {
        // Add the blockquote marker
        spans.add(
          TextSpan(
            text: match.group(1),
            style: style?.copyWith(fontWeight: FontWeight.bold),
          ),
        );

        // Add the blockquote text
        spans.add(
          TextSpan(
            text: match.group(2),
            style: style?.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      }

      // Update current position
      currentPosition = match.end;
    }

    // Add any remaining text
    if (currentPosition < text.length) {
      spans.add(TextSpan(text: text.substring(currentPosition), style: style));
    }

    return spans;
  }
}

class MarkdownPreview extends StatelessWidget {
  final String markdown;

  const MarkdownPreview({super.key, required this.markdown});

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: Localizations.localeOf(context),
      delegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: MarkdownWidget(data: markdown, padding: const EdgeInsets.all(24)),
    );
  }
}
