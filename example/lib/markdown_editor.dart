import 'package:flutter/gestures.dart' show TapGestureRecognizer;
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
        trailing: [],
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
      child: OmarchySplitPanel(
        direction: TextDirection.rtl,
        panelInitialSize: PanelSize.ratio(0.5),
        panel: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return MarkdownPreview(markdown: _controller.text);
          },
        ),
        child: OmarchyTextInput(
          controller: _controller,
          padding: const EdgeInsets.all(24),
          maxLines: null,
        ),
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

    final parser = MarkdownParser();

    final md = parser.parse(text);

    for (final span in md) {
      TextStyle spanStyle = style ?? const TextStyle();
      for (final attr in span.attributes) {
        switch (attr) {
          case MarkdownAttribute.bold:
            spanStyle = spanStyle.merge(theme.text.bold);
          case MarkdownAttribute.italic:
            spanStyle = spanStyle.merge(theme.text.italic);
          case MarkdownAttribute.strikethrough:
            spanStyle = spanStyle.merge(
              const TextStyle(decoration: TextDecoration.lineThrough),
            );
          case MarkdownAttribute.code:
            spanStyle = spanStyle.merge(theme.text.italic);
          case MarkdownAttribute.link:
            spanStyle = spanStyle.merge(
              theme.text.normal.copyWith(
                color: theme.colors.bright.blue,
                decoration: TextDecoration.underline,
              ),
            );
          case MarkdownAttribute.image:
            spanStyle = spanStyle.merge(
              theme.text.normal.copyWith(color: theme.colors.bright.green),
            );
          case MarkdownAttribute.heading1:
            spanStyle = spanStyle.merge(
              theme.text.bold.copyWith(color: theme.colors.bright.magenta),
            );
          case MarkdownAttribute.heading2:
            spanStyle = spanStyle.merge(
              theme.text.bold.copyWith(color: theme.colors.bright.magenta),
            );
          case MarkdownAttribute.heading3:
            spanStyle = spanStyle.merge(
              theme.text.bold.copyWith(color: theme.colors.bright.magenta),
            );
          case MarkdownAttribute.heading4:
            spanStyle = spanStyle.merge(
              theme.text.bold.copyWith(color: theme.colors.bright.magenta),
            );
          case MarkdownAttribute.heading5:
            spanStyle = spanStyle.merge(
              theme.text.bold.copyWith(color: theme.colors.bright.magenta),
            );
          case MarkdownAttribute.heading6:
            spanStyle = spanStyle.merge(
              theme.text.bold.copyWith(color: theme.colors.bright.magenta),
            );
          case MarkdownAttribute.blockquote:
            spanStyle = spanStyle.merge(
              style?.copyWith(
                    color: theme.colors.bright.yellow,
                    fontStyle: FontStyle.italic,
                  ) ??
                  TextStyle(
                    color: theme.colors.bright.yellow,
                    fontStyle: FontStyle.italic,
                  ),
            );
          case MarkdownAttribute.codeblock:
            spanStyle = spanStyle.merge(
              theme.text.italic.copyWith(
                backgroundColor: theme.colors.normal.black.withValues(
                  alpha: 0.1,
                ),
              ),
            );
          case MarkdownAttribute.listItem:
            // No specific style for list items; handled in block parsing if needed
            break;
          case MarkdownAttribute.taskTodo:
            spanStyle = spanStyle.merge(
              style?.copyWith(
                    color: theme.colors.bright.red,
                    fontWeight: FontWeight.bold,
                  ) ??
                  TextStyle(
                    color: theme.colors.bright.red,
                    fontWeight: FontWeight.bold,
                  ),
            );
          case MarkdownAttribute.taskDone:
            spanStyle = spanStyle.merge(
              style?.copyWith(
                    color: theme.colors.bright.green,
                    fontWeight: FontWeight.bold,
                  ) ??
                  TextStyle(
                    color: theme.colors.bright.green,
                    fontWeight: FontWeight.bold,
                  ),
            );
        }
        spans.add(TextSpan(text: span.text, style: spanStyle));
      }
    }

    return spans;
  }
}

class MarkdownPreview extends StatelessWidget {
  final String markdown;

  const MarkdownPreview({super.key, required this.markdown});

  @override
  Widget build(BuildContext context) {
    final theme = OmarchyTheme.of(context);
    return Container(
      color: theme.colors.normal.black,
      margin: const EdgeInsets.only(right: 2, bottom: 2, top: 2),
      child: MarkdownWidget(data: markdown, padding: const EdgeInsets.all(24)),
    );
  }
}

// A simple GitHub‑flavored Markdown (GFM) tokenizer + parser implemented
// fully without regex for the core algorithm. It produces a flat sequence
// of Spans while preserving overlaps by computing active attribute ranges
// and coalescing adjacent runs with equal attribute sets.
//
// Scope covered:
// - Headings (# to ######)
// - Blockquotes (> )
// - Unordered list items (-, +, *)
// - Task list items (- [ ] / - [x])
// - Fenced code blocks (``` ... ```); no inline parsing inside
// - Inline: **bold**, *italic*, __bold__, _italic_, ~~strikethrough~~,
//   inline code `code`, links [text](url), images ![alt](src)
//
// Notes:
// - This is a pragmatic parser; it aims to be predictable and easy to extend
//   rather than 100% spec‑complete.
// - Links/images: only the visible text/alt contributes to output spans; URLs
//   are ignored as requested. If you want URLs later, add a metadata map.

enum MarkdownAttribute {
  bold,
  italic,
  strikethrough,
  code,
  link,
  image,
  heading1,
  heading2,
  heading3,
  heading4,
  heading5,
  heading6,
  blockquote,
  codeblock,
  listItem,
  taskTodo,
  taskDone,
}

class MarkdownSpan {
  final String text;
  final List<MarkdownAttribute> attributes;
  MarkdownSpan(this.text, [List<MarkdownAttribute> attrs = const []])
    : attributes = List.unmodifiable(List.of(attrs));
  @override
  String toString() =>
      'Span(text: "${text.replaceAll('\n', '\\n')}", attributes: $attributes)';
}

// ===== Tokenizer primitives =====
class _CharStream {
  final String s;
  int i = 0;
  _CharStream(this.s);
  bool get eof => i >= s.length;
  int get pos => i;
  String peek([int k = 0]) => (i + k < s.length) ? s[i + k] : '\u0000';
  String next() => (i < s.length) ? s[i++] : '\u0000';
  bool startsWith(String pat) {
    if (i + pat.length > s.length) return false;
    return s.substring(i, i + pat.length) == pat;
  }
}

// ===== Parser =====
class MarkdownParser {
  List<MarkdownSpan> parse(String input) {
    final lines = input.split('\n');
    final spans = <MarkdownSpan>[];

    var inFence = false; // fenced code block state
    int fenceStartLine = -1;

    for (var lineIdx = 0; lineIdx < lines.length; lineIdx++) {
      var line = lines[lineIdx];
      final baseAttrs = <MarkdownAttribute>[];

      // Check for fence markers ``` (no language inference needed for attrs)
      if (_isFence(line)) {
        inFence = !inFence;
        if (inFence) {
          fenceStartLine = lineIdx;
        }
        // Fence delimiter lines themselves are not emitted.
        continue;
      }

      if (inFence) {
        // Entire line is codeblock; do not interpret inline markdown.
        spans.addAll(_emitLine(line, const [MarkdownAttribute.codeblock]));
        if (lineIdx < lines.length - 1) spans.add(MarkdownSpan('\n'));
        continue;
      }

      // Blockquote prefix
      final blockquoteDepth = _consumeBlockquotePrefix(line);
      if (blockquoteDepth > 0) {
        baseAttrs.add(MarkdownAttribute.blockquote);
        line = line.substring(_blockquotePrefixLength(line));
      }

      // Heading prefix (# ...)
      final headingLevel = _headingLevel(line);
      if (headingLevel > 0) {
        baseAttrs.add(_headingAttr(headingLevel));
        line = line.replaceFirst(RegExp(r'^#{1,6}[ \t]+'), '');
      }

      // List / Task markers
      final taskState = _taskMarker(line);
      if (taskState != null) {
        baseAttrs.add(MarkdownAttribute.listItem);
        baseAttrs.add(
          taskState ? MarkdownAttribute.taskDone : MarkdownAttribute.taskTodo,
        );
        line = line.replaceFirst(RegExp(r'^\s*[-*+]\s+\[[ xX]\]\s*'), '');
      } else if (_isUnorderedList(line)) {
        baseAttrs.add(MarkdownAttribute.listItem);
        line = line.replaceFirst(RegExp(r'^\s*[-*+]\s+'), '');
      }

      // Inline parsing with a real scanner (no regex for core logic)
      spans.addAll(_parseInline(line, baseAttrs));
      if (lineIdx < lines.length - 1) spans.add(MarkdownSpan('\n'));
    }

    // Coalesce adjacent spans with identical attributes
    return _coalesce(spans);
  }

  // ===== Block helpers =====
  bool _isFence(String line) {
    var i = 0;
    while (i < line.length && (line[i] == ' ' || line[i] == '\t')) i++;
    if (i + 3 <= line.length && line.substring(i).startsWith('```'))
      return true;
    return false;
  }

  int _consumeBlockquotePrefix(String line) {
    var i = 0, depth = 0;
    while (i < line.length) {
      // optional leading whitespace
      while (i < line.length && (line[i] == ' ' || line[i] == '\t')) i++;
      if (i < line.length && line[i] == '>') {
        depth++;
        i++;
        if (i < line.length && line[i] == ' ') i++;
      } else {
        break;
      }
    }
    return depth;
  }

  int _blockquotePrefixLength(String line) {
    var i = 0;
    while (i < line.length) {
      while (i < line.length && (line[i] == ' ' || line[i] == '\t')) i++;
      if (i < line.length && line[i] == '>') {
        i++;
        if (i < line.length && line[i] == ' ') i++;
      } else {
        break;
      }
    }
    return i;
  }

  int _headingLevel(String line) {
    var i = 0;
    while (i < line.length && (line[i] == ' ' || line[i] == '\t')) i++;
    var j = i;
    while (j < line.length && line[j] == '#') j++;
    final level = j - i;
    if (level >= 1 && level <= 6) {
      // require following space
      if (j < line.length && (line[j] == ' ' || line[j] == '\t')) return level;
    }
    return 0;
  }

  MarkdownAttribute _headingAttr(int level) {
    switch (level) {
      case 1:
        return MarkdownAttribute.heading1;
      case 2:
        return MarkdownAttribute.heading2;
      case 3:
        return MarkdownAttribute.heading3;
      case 4:
        return MarkdownAttribute.heading4;
      case 5:
        return MarkdownAttribute.heading5;
      default:
        return MarkdownAttribute.heading6;
    }
  }

  bool? _taskMarker(String line) {
    // returns true for done, false for todo, null for not a task
    final trimmed = line.trimLeft();
    var i = 0;
    // bullet
    if (trimmed.isEmpty) return null;
    if (trimmed[0] != '-' && trimmed[0] != '*' && trimmed[0] != '+')
      return null;
    i++;
    if (i >= trimmed.length || trimmed[i] != ' ') return null;
    i++;
    if (i >= trimmed.length || trimmed[i] != '[') return null;
    i++;
    if (i >= trimmed.length) return null;
    final c = trimmed[i];
    final isBox = c == ' ' || c == 'x' || c == 'X';
    if (!isBox) return null;
    i++;
    if (i >= trimmed.length || trimmed[i] != ']') return null;
    return (c == 'x' || c == 'X');
  }

  bool _isUnorderedList(String line) {
    final trimmed = line.trimLeft();
    if (trimmed.isEmpty) return false;
    if (trimmed[0] != '-' && trimmed[0] != '*' && trimmed[0] != '+')
      return false;
    if (trimmed.length >= 2 && trimmed[1] == ' ') return true;
    return false;
  }

  // ===== Inline parsing =====
  List<MarkdownSpan> _parseInline(String line, List<MarkdownAttribute> base) {
    final spans = <MarkdownSpan>[];
    final buf = StringBuffer();
    final active = <MarkdownAttribute>{...base};

    // helpers
    void emit() {
      if (buf.isEmpty) return;
      spans.add(MarkdownSpan(buf.toString(), _sorted(active)));
      buf.clear();
    }

    void toggle(MarkdownAttribute a) {
      if (active.contains(a)) {
        emit();
        active.remove(a);
      } else {
        emit();
        active.add(a);
      }
    }

    // Process with a character stream
    final cs = _CharStream(line);

    while (!cs.eof) {
      // Inline code span
      if (cs.peek() == '`') {
        cs.next(); // consume opening backtick
        emit();
        active.add(MarkdownAttribute.code);
        while (!cs.eof && cs.peek() != '`') {
          buf.write(cs.next());
        }
        emit();
        active.remove(MarkdownAttribute.code);
        if (cs.peek() == '`') cs.next(); // consume closing backtick if present
        continue;
      }

      // Strong (** or __)
      if (cs.startsWith('**')) {
        cs.next();
        cs.next();
        toggle(MarkdownAttribute.bold);
        continue;
      }
      if (cs.startsWith('__')) {
        cs.next();
        cs.next();
        toggle(MarkdownAttribute.bold);
        continue;
      }

      // Emphasis (* or _)
      if (cs.peek() == '*') {
        cs.next();
        toggle(MarkdownAttribute.italic);
        continue;
      }
      if (cs.peek() == '_') {
        cs.next();
        toggle(MarkdownAttribute.italic);
        continue;
      }

      // Strikethrough ~~
      if (cs.startsWith('~~')) {
        cs.next();
        cs.next();
        toggle(MarkdownAttribute.strikethrough);
        continue;
      }

      // Link [text](url)
      if (cs.peek() == '[') {
        final saved = cs.pos;
        final inner = _scanBracketed(cs);
        if (inner != null && cs.peek() == '(') {
          // consume '(' url ')' but ignore the URL text in output
          _consumeParen(cs);
          // Recursively parse inner with same base, then add link attr
          final innerSpans = _parseInline(inner, base);
          for (final sp in innerSpans) {
            spans.add(
              MarkdownSpan(sp.text, [...sp.attributes, MarkdownAttribute.link]),
            );
          }
          continue;
        } else {
          // Not a valid link; revert and treat as text
          cs.i = saved;
        }
      }

      // Image ![alt](src) — emits alt text with image attr
      if (cs.peek() == '!' && cs.peek(1) == '[') {
        cs.next(); // '!'
        final inner = _scanBracketed(
          cs,
        ); // expects starting '[' already at stream
        if (inner != null && cs.peek() == '(') {
          _consumeParen(cs); // consume (src)
          // alt becomes text with image attribute
          final innerSpans = _parseInline(inner, base);
          for (final sp in innerSpans) {
            spans.add(
              MarkdownSpan(sp.text, [
                ...sp.attributes,
                MarkdownAttribute.image,
              ]),
            );
          }
          continue;
        } else {
          // Fallback to literal '!'
          buf.write('!');
          continue;
        }
      }

      // Default: literal char
      buf.write(cs.next());
    }

    emit();
    return spans;
  }

  // Reads "[ ... ]" content and returns the inner string, or null if not well‑formed.
  String? _scanBracketed(_CharStream cs) {
    if (cs.peek() != '[') return null;
    cs.next(); // consume '['
    final start = cs.pos;
    var depth = 1;
    while (!cs.eof) {
      final ch = cs.next();
      if (ch == '[') depth++;
      if (ch == ']') {
        depth--;
        if (depth == 0) {
          final end = cs.pos - 1; // position just before ']'
          return cs.s.substring(start, end);
        }
      }
      if (ch == '\\' && !cs.eof) cs.next(); // skip escaped char
    }
    return null; // malformed
  }

  // Consumes "( ... )" group; returns inside but we discard result here
  String _consumeParen(_CharStream cs) {
    if (cs.peek() != '(') return '';
    cs.next(); // '('
    final start = cs.pos;
    var depth = 1;
    while (!cs.eof) {
      final ch = cs.next();
      if (ch == '(') depth++;
      if (ch == ')') {
        depth--;
        if (depth == 0) {
          final end = cs.pos - 1;
          return cs.s.substring(start, end);
        }
      }
      if (ch == '\\' && !cs.eof) cs.next();
    }
    return '';
  }

  // Emit a whole line with a fixed attribute set
  List<MarkdownSpan> _emitLine(String line, List<MarkdownAttribute> attrs) {
    if (line.isEmpty) return [MarkdownSpan('', attrs)];
    return [
      MarkdownSpan(line, _sorted({...attrs})),
    ];
  }

  List<MarkdownSpan> _coalesce(List<MarkdownSpan> src) {
    if (src.isEmpty) return src;
    final out = <MarkdownSpan>[];
    final buf = StringBuffer();
    var curAttrs = src.first.attributes;
    for (final s in src) {
      if (_eqAttrs(curAttrs, s.attributes)) {
        buf.write(s.text);
      } else {
        out.add(MarkdownSpan(buf.toString(), curAttrs));
        buf.clear();
        buf.write(s.text);
        curAttrs = s.attributes;
      }
    }
    out.add(MarkdownSpan(buf.toString(), curAttrs));
    // Drop empty spans
    return out.where((s) => s.text.isNotEmpty).toList();
  }

  bool _eqAttrs(List<MarkdownAttribute> a, List<MarkdownAttribute> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) if (a[i] != b[i]) return false;
    return true;
  }

  List<MarkdownAttribute> _sorted(Iterable<MarkdownAttribute> it) {
    final l = it.toList();
    l.sort((x, y) => x.index.compareTo(y.index));
    return l;
  }
}
