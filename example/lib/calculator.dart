import 'package:flutter_omarchy/flutter_omarchy.dart';
import 'dart:math' show sqrt, pow, sin, cos, tan, pi;

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  static const buttonSpacing = 4.0;

  @override
  Widget build(BuildContext context) {
    return OmarchyApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final engine = CalculatorEngine();

  @override
  Widget build(BuildContext context) {
    const rows = <List<CalculatorAction>>[
      [
        MemoryClear(),
        OpenParenthesis(),
        CloseParenthesis(),
        ClearEntry(),
        Backspace(),
        ClearAll(),
        Operator.divide(),
      ],
      [
        MemoryRecall(),
        Sine(),
        Power(),
        Digit(7),
        Digit(8),
        Digit(9),
        Operator.multiply(),
      ],

      [
        MemoryAdd(),
        Cosine(),
        Square(),
        Digit(4),
        Digit(5),
        Digit(6),
        Operator.minus(),
      ],
      [
        MemorySubtract(),
        Tangent(),
        Percent(),
        Digit(1),
        Digit(2),
        Digit(3),
        Operator.plus(),
      ],
      [Pi(), SquareRoot(), ToggleSign(), Digit(0), DecimalPoint(), Equals()],
    ];

    return OmarchyScaffold(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: LayoutBuilder(
          builder: (context, layout) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    spacing: CalculatorApp.buttonSpacing,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Display(
                        history: layout.maxHeight > 500
                            ? engine.historyDisplay
                            : null,
                        display: engine.display,
                      ),
                      const SizedBox(height: 8),
                      for (final row in rows)
                        Expanded(
                          child: Row(
                            spacing: CalculatorApp.buttonSpacing,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: row.map((action) {
                              return CalculatorButton(
                                action,
                                onPressed: () {
                                  setState(() {
                                    engine.execute(action);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Display extends StatelessWidget {
  const Display({super.key, required this.history, required this.display});
  final String? history;
  final String display;

  @override
  Widget build(BuildContext context) {
    final theme = OmarchyTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (history case final history?)
          Text(
            history,
            style: theme.text.italic.copyWith(
              fontSize: 12,
              color: theme.colors.bright.black,
            ),
            maxLines: 1,
            textAlign: TextAlign.right,
          ),
        FittedBox(
          child: Text(
            display,
            style: TextStyle(fontSize: 48),
            maxLines: 1,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton(this.action, {super.key, required this.onPressed});

  final CalculatorAction action;
  final VoidCallback onPressed;
  AnsiColor get color => switch (action) {
    ClearAll() => AnsiColor.red,
    ClearEntry() => AnsiColor.red,
    Backspace() => AnsiColor.red,
    ToggleSign() => AnsiColor.blue,
    Percent() => AnsiColor.cyan,
    SquareRoot() => AnsiColor.cyan,
    Square() => AnsiColor.cyan,
    Power() => AnsiColor.cyan,
    Pi() => AnsiColor.cyan,
    OpenParenthesis() => AnsiColor.blue,
    CloseParenthesis() => AnsiColor.blue,
    Trigonometric() => AnsiColor.magenta,
    Equals() => AnsiColor.green,
    Digit() => AnsiColor.white,
    DecimalPoint() => AnsiColor.white,
    Operator() => AnsiColor.yellow,
    Memory() => AnsiColor.magenta,
  };

  Widget symbol(bool isSmall) => switch (action) {
    Backspace() => Icon(
      OmarchyIcons.mdBackspaceOutline,
      size: isSmall ? 30 : 48,
    ),
    final other => Text(
      other.toString(),
      style: TextStyle(fontSize: isSmall ? 20 : 32),
    ),
  };
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, layout) {
          final isSmall = layout.maxHeight < 80 || layout.maxWidth < 80;
          return OmarchyButton(
            style: OmarchyButtonStyle.filled(color, padding: EdgeInsets.zero),
            onPressed: onPressed,
            child: Center(child: symbol(isSmall)),
          );
        },
      ),
    );
  }
}

/// A lightweight calculator engine that records every action and
/// derives the current result from that history.
///
/// Usage example:
/// ```dart
/// final calc = CalculatorEngine();
/// calc.execute(Digit(1));
/// calc.execute(Digit(2));
/// calc.execute(Operator.plus());
/// calc.execute(Digit(7));
/// calc.execute(Operator.multiply());
/// calc.execute(Digit(3));
/// calc.execute(Equals());
/// print(calc.display);          // "33"
/// print(calc.historyDisplay);   // "12 + 7 × 3 = 33"
/// ```

// -----------------------------
// Actions (user intents)
// -----------------------------

/// Base class for calculator actions.
sealed class CalculatorAction {
  const CalculatorAction();
}

/// 0–9 digit input
class Digit extends CalculatorAction {
  final int value; // must be 0..9
  const Digit(this.value) : assert(value >= 0 && value <= 9);

  @override
  String toString() {
    return value.toString();
  }
}

/// Decimal point input (".")
class DecimalPoint extends CalculatorAction {
  const DecimalPoint();

  @override
  String toString() {
    return '.';
  }
}

/// Binary operators: +, -, ×, ÷
class Operator extends CalculatorAction {
  final OperatorType type;
  const Operator(this.type);

  const Operator.plus() : type = OperatorType.plus;
  const Operator.minus() : type = OperatorType.minus;
  const Operator.multiply() : type = OperatorType.multiply;
  const Operator.divide() : type = OperatorType.divide;
  const Operator.power() : type = OperatorType.power;

  @override
  String toString() {
    return type.toSymbol();
  }
}

enum OperatorType {
  plus,
  minus,
  multiply,
  divide,
  power;

  String toSymbol() {
    switch (this) {
      case OperatorType.plus:
        return '+';
      case OperatorType.minus:
        return '-';
      case OperatorType.multiply:
        return '×';
      case OperatorType.divide:
        return '÷';
      case OperatorType.power:
        return '^';
    }
  }
}

/// Evaluate the current expression
class Equals extends CalculatorAction {
  const Equals();
  @override
  String toString() {
    return '=';
  }
}

/// Clear everything (AC)
class ClearAll extends CalculatorAction {
  const ClearAll();
  @override
  String toString() {
    return 'AC';
  }
}

/// Clear only the current entry (CE)
class ClearEntry extends CalculatorAction {
  const ClearEntry();
  @override
  String toString() {
    return 'CE';
  }
}

/// Delete last character of the current entry
class Backspace extends CalculatorAction {
  const Backspace();

  @override
  String toString() {
    return 'CE';
  }
}

/// Toggle sign of the current entry (±)
class ToggleSign extends CalculatorAction {
  const ToggleSign();

  @override
  String toString() {
    return '±';
  }
}

/// Convert current entry to a percentage (divide by 100)
class Percent extends CalculatorAction {
  const Percent();

  @override
  String toString() {
    return '%';
  }
}

/// Calculate square root of the current entry
class SquareRoot extends CalculatorAction {
  const SquareRoot();

  @override
  String toString() {
    return '√';
  }
}

/// Calculate square of the current entry
class Square extends CalculatorAction {
  const Square();

  @override
  String toString() {
    return 'x²';
  }
}

/// Memory operations
sealed class Memory extends CalculatorAction {
  const Memory();
}

/// Memory store (M+)
class MemoryAdd extends Memory {
  const MemoryAdd();

  @override
  String toString() {
    return 'M+';
  }
}

/// Memory subtract (M-)
class MemorySubtract extends Memory {
  const MemorySubtract();

  @override
  String toString() {
    return 'M-';
  }
}

/// Memory recall (MR)
class MemoryRecall extends Memory {
  const MemoryRecall();

  @override
  String toString() {
    return 'MR';
  }
}

/// Memory clear (MC)
class MemoryClear extends Memory {
  const MemoryClear();

  @override
  String toString() {
    return 'MC';
  }
}

/// Power operation (x^y)
class Power extends CalculatorAction {
  const Power();

  @override
  String toString() {
    return 'x^y';
  }
}

/// Open parenthesis
class OpenParenthesis extends CalculatorAction {
  const OpenParenthesis();

  @override
  String toString() {
    return '(';
  }
}

/// Close parenthesis
class CloseParenthesis extends CalculatorAction {
  const CloseParenthesis();

  @override
  String toString() {
    return ')';
  }
}

/// Trigonometric operations
sealed class Trigonometric extends CalculatorAction {
  const Trigonometric();
}

/// Sine function
class Sine extends Trigonometric {
  const Sine();

  @override
  String toString() {
    return 'sin';
  }
}

/// Cosine function
class Cosine extends Trigonometric {
  const Cosine();

  @override
  String toString() {
    return 'cos';
  }
}

/// Tangent function
class Tangent extends Trigonometric {
  const Tangent();

  @override
  String toString() {
    return 'tan';
  }
}

/// Pi constant (π)
class Pi extends CalculatorAction {
  const Pi();

  @override
  String toString() {
    return 'π';
  }
}

// -----------------------------
// Engine
// -----------------------------

class CalculatorEngine {
  final List<CalculatorAction> _history = <CalculatorAction>[];

  // Internal state derived by replaying history
  String _currentEntry = ""; // textual buffer for the number being typed
  final List<_Token> _tokens = <_Token>[]; // committed numbers & operators
  bool _justEvaluated = false; // last action was Equals
  String? _error; // non-null if an error occurred during evaluation
  double _memoryValue = 0.0; // value stored in memory
  bool _hasMemory = false; // whether memory has a value
  int _parenthesisCount = 0; // count of open parentheses
  bool _expectingPowerOperand =
      false; // whether we're expecting the second operand for power

  // --- Public API ---

  /// Append an action to the history and update the state by replaying it.
  void execute(CalculatorAction action) {
    _apply(action, record: true);
  }

  /// All actions so far (immutable copy)
  List<CalculatorAction> get history => List.unmodifiable(_history);

  /// The text to show on the calculator main display.
  /// If an error occurred, this returns a message like "Error" or "Division by zero".
  String get display =>
      _error ??
      (_currentEntry.isEmpty
          ? _formatNumber(_evaluateTokens())
          : _currentEntry);

  /// A human-friendly one-line history like: "12 + 7 × 3 = 33".
  String get historyDisplay {
    if (_history.isEmpty) return "";
    final sb = StringBuffer();

    // Reconstruct by walking tokens and entry
    for (final t in _tokens) {
      if (t is _NumberTok) {
        sb.write(_trimTrailingZeros(t.value));
      } else if (t is _OpTok) {
        sb.write(" ${t.type.toSymbol()} ");
      } else if (t is _ParenTok) {
        sb.write(t.isOpen ? "(" : ")");
      } else if (t is _FuncTok) {
        sb.write("${t.name}(");
      }
    }
    if (_currentEntry.isNotEmpty) {
      if (sb.isNotEmpty) sb.write(" ");
      sb.write(_currentEntry);
    }

    // If last action was Equals, append "= result"
    if (_history.isNotEmpty && _history.last is Equals) {
      final res = _error ?? _formatNumber(_evaluateTokens());
      if (sb.isNotEmpty) sb.write(" ");
      sb.write("= $res");
    }

    return sb.toString();
  }

  /// True if the engine is currently in an error state.
  bool get hasError => _error != null;

  /// Erases everything and clears history. Does not add a history entry.
  void reset() {
    _history.clear();
    _currentEntry = "";
    _tokens.clear();
    _justEvaluated = false;
    _error = null;
  }

  // --- Internals ---

  void _apply(CalculatorAction action, {bool record = false}) {
    if (record) _history.add(action);

    if (action is ClearAll) {
      _currentEntry = "";
      _tokens.clear();
      _justEvaluated = false;
      _error = null;
      return;
    }

    if (action is ClearEntry) {
      _currentEntry = "";
      _error = null;
      return;
    }

    if (action is Backspace) {
      if (_currentEntry.isNotEmpty) {
        _currentEntry = _currentEntry.substring(0, _currentEntry.length - 1);
      }
      return;
    }

    if (action is Digit) {
      if (_justEvaluated) {
        // Start a new entry after equals if user types a digit
        _tokens.clear();
        _currentEntry = "";
        _justEvaluated = false;
      }
      // Prevent leading zeros like 00012 unless after decimal
      if (_currentEntry == "0") _currentEntry = "";
      _currentEntry += action.value.toString();
      return;
    }

    if (action is DecimalPoint) {
      if (_justEvaluated) {
        _tokens.clear();
        _currentEntry = "";
        _justEvaluated = false;
      }
      if (_currentEntry.isEmpty) {
        _currentEntry = "0.";
      } else if (!_currentEntry.contains('.')) {
        _currentEntry += ".";
      }
      return;
    }

    if (action is ToggleSign) {
      if (_currentEntry.isEmpty) {
        // Toggle last number token if no active entry
        for (int i = _tokens.length - 1; i >= 0; i--) {
          final t = _tokens[i];
          if (t is _NumberTok) {
            _tokens[i] = _NumberTok(-t.value);
            break;
          }
        }
      } else {
        if (_currentEntry.startsWith("-")) {
          _currentEntry = _currentEntry.substring(1);
        } else {
          _currentEntry = "-$_currentEntry";
        }
      }
      return;
    }

    if (action is Percent) {
      if (_currentEntry.isEmpty) return;
      final v = double.tryParse(_currentEntry);
      if (v != null) {
        _currentEntry = _trimTrailingZeros(v / 100.0);
      }
      return;
    }

    if (action is SquareRoot) {
      if (_currentEntry.isEmpty) return;
      final v = double.tryParse(_currentEntry);
      if (v != null) {
        if (v < 0) {
          _error = "Invalid input";
          return;
        }
        _currentEntry = _trimTrailingZeros(sqrt(v));
      }
      return;
    }

    if (action is Square) {
      if (_currentEntry.isEmpty) return;
      final v = double.tryParse(_currentEntry);
      if (v != null) {
        _currentEntry = _trimTrailingZeros(v * v);
      }
      return;
    }

    if (action is MemoryAdd) {
      if (_currentEntry.isEmpty) {
        // Use last result if no current entry
        final value = _evaluateTokens();
        _memoryValue += value;
      } else {
        final v = double.tryParse(_currentEntry);
        if (v != null) {
          _memoryValue += v;
        }
      }
      _hasMemory = true;
      return;
    }

    if (action is MemorySubtract) {
      if (_currentEntry.isEmpty) {
        // Use last result if no current entry
        final value = _evaluateTokens();
        _memoryValue -= value;
      } else {
        final v = double.tryParse(_currentEntry);
        if (v != null) {
          _memoryValue -= v;
        }
      }
      _hasMemory = true;
      return;
    }

    if (action is MemoryRecall) {
      if (!_hasMemory) return;
      if (_justEvaluated) {
        _tokens.clear();
        _justEvaluated = false;
      }
      _currentEntry = _trimTrailingZeros(_memoryValue);
      return;
    }

    if (action is MemoryClear) {
      _memoryValue = 0.0;
      _hasMemory = false;
      return;
    }

    if (action is Power) {
      _commitEntryIfAny();
      _tokens.add(_OpTok(OperatorType.power));
      return;
    }

    if (action is OpenParenthesis) {
      if (_currentEntry.isNotEmpty && double.tryParse(_currentEntry) != null) {
        // Implicit multiplication: 2(3+4) means 2*(3+4)
        _commitEntryIfAny();
        _tokens.add(_OpTok(OperatorType.multiply));
      }
      _tokens.add(_ParenTok(true));
      _parenthesisCount++;
      return;
    }

    if (action is CloseParenthesis) {
      if (_parenthesisCount <= 0)
        return; // Ignore if no matching open parenthesis
      _commitEntryIfAny();
      _tokens.add(_ParenTok(false));
      _parenthesisCount--;
      return;
    }

    if (action is Sine) {
      if (_currentEntry.isEmpty) return;
      final v = double.tryParse(_currentEntry);
      if (v != null) {
        // Convert to radians if needed
        final radians = v * pi / 180.0;
        _currentEntry = _trimTrailingZeros(sin(radians));
      }
      return;
    }

    if (action is Cosine) {
      if (_currentEntry.isEmpty) return;
      final v = double.tryParse(_currentEntry);
      if (v != null) {
        // Convert to radians if needed
        final radians = v * pi / 180.0;
        _currentEntry = _trimTrailingZeros(cos(radians));
      }
      return;
    }

    if (action is Tangent) {
      if (_currentEntry.isEmpty) return;
      final v = double.tryParse(_currentEntry);
      if (v != null) {
        // Check for invalid input (90, 270, etc. degrees)
        final degrees = v % 360;
        if (degrees == 90 || degrees == 270) {
          _error = "Invalid input";
          return;
        }
        // Convert to radians
        final radians = v * pi / 180.0;
        _currentEntry = _trimTrailingZeros(tan(radians));
      }
      return;
    }

    if (action is Pi) {
      if (_justEvaluated) {
        _tokens.clear();
        _justEvaluated = false;
      }

      // If there's a number entry, treat pi as multiplication (e.g., 2π = 2*π)
      if (_currentEntry.isNotEmpty && double.tryParse(_currentEntry) != null) {
        _commitEntryIfAny();
        _tokens.add(_OpTok(OperatorType.multiply));
      }

      _currentEntry = _trimTrailingZeros(pi);
      return;
    }

    if (action is Operator) {
      _commitEntryIfAny();
      _error = null;
      // Replace operator if previous token is an operator
      if (_tokens.isNotEmpty && _tokens.last is _OpTok) {
        _tokens[_tokens.length - 1] = _OpTok(action.type);
      } else {
        _tokens.add(_OpTok(action.type));
      }
      _justEvaluated = false;
      return;
    }

    if (action is Equals) {
      _commitEntryIfAny();
      final res = _safeEvaluate();
      if (res == null) {
        // keep tokens as-is; _error populated
        _justEvaluated = true; // still consider as evaluated for UI flow
        return;
      }
      _tokens
        ..clear()
        ..add(_NumberTok(res));
      _currentEntry = "";
      _error = null;
      _justEvaluated = true;
      return;
    }
  }

  void _commitEntryIfAny() {
    if (_currentEntry.isEmpty) return;
    final parsed = double.tryParse(_currentEntry);
    if (parsed != null) {
      _tokens.add(_NumberTok(parsed));
    }
    _currentEntry = "";
  }

  String _formatNumber(double value) => _trimTrailingZeros(value);

  String _trimTrailingZeros(double value) {
    final s = value.toStringAsFixed(12); // avoid floating noise
    // Trim trailing zeros and possibly the decimal point
    String out = s;
    while (out.contains('.') && (out.endsWith('0') || out.endsWith('.'))) {
      out = out.substring(0, out.length - 1);
      if (out.endsWith('.')) {
        out = out.substring(0, out.length - 1);
        break;
      }
    }
    if (out.isEmpty) return "0";
    return out;
  }

  /// Evaluate tokens with operator precedence using a simple shunting-yard.
  double _evaluateTokens() {
    final rpn = <_Token>[];
    final ops = <_Token>[];

    int prec(OperatorType t) {
      switch (t) {
        case OperatorType.plus:
        case OperatorType.minus:
          return 1;
        case OperatorType.multiply:
        case OperatorType.divide:
          return 2;
        case OperatorType.power:
          return 3;
      }
    }

    for (final t in _tokens) {
      if (t is _NumberTok) {
        rpn.add(t);
      } else if (t is _OpTok) {
        while (ops.isNotEmpty &&
            ops.last is _OpTok &&
            prec((ops.last as _OpTok).type) >= prec(t.type)) {
          rpn.add(ops.removeLast());
        }
        ops.add(t);
      } else if (t is _ParenTok) {
        if (t.isOpen) {
          // Opening parenthesis
          ops.add(t);
        } else {
          // Closing parenthesis
          while (ops.isNotEmpty && ops.last is! _ParenTok) {
            rpn.add(ops.removeLast());
          }
          if (ops.isNotEmpty && ops.last is _ParenTok) {
            ops.removeLast(); // Remove the opening parenthesis
          }
        }
      } else if (t is _FuncTok) {
        ops.add(t);
      }
    }

    // Pop any remaining operators
    while (ops.isNotEmpty) {
      final op = ops.removeLast();
      if (op is! _ParenTok) {
        // Skip any unmatched parentheses
        rpn.add(op);
      }
    }

    final stack = <double>[];
    for (final t in rpn) {
      if (t is _NumberTok) {
        stack.add(t.value);
      } else if (t is _OpTok) {
        if (stack.length < 2) return double.nan;
        final b = stack.removeLast();
        final a = stack.removeLast();
        switch (t.type) {
          case OperatorType.plus:
            stack.add(a + b);
            break;
          case OperatorType.minus:
            stack.add(a - b);
            break;
          case OperatorType.multiply:
            stack.add(a * b);
            break;
          case OperatorType.divide when b == 0.0:
            return double.infinity; // will be handled by _safeEvaluate
          case OperatorType.divide:
            stack.add(a / b);
            break;
          case OperatorType.power:
            stack.add(pow(a, b) as double);
            break;
        }
      } else if (t is _FuncTok) {
        if (stack.isEmpty) return double.nan;
        final a = stack.removeLast();
        switch (t.name) {
          case 'sin':
            stack.add(sin(a * pi / 180.0));
            break;
          case 'cos':
            stack.add(cos(a * pi / 180.0));
            break;
          case 'tan':
            if (a % 180 == 90) return double.infinity;
            stack.add(tan(a * pi / 180.0));
            break;
        }
      }
    }
    return stack.isEmpty ? 0.0 : stack.single;
  }

  double? _safeEvaluate() {
    final res = _evaluateTokens();
    if (res.isNaN) {
      _error = "Error";
      return null;
    }
    if (res.isInfinite) {
      _error = "Division by zero";
      return null;
    }
    return res;
  }
}

// -----------------------------
// Token model
// -----------------------------

abstract class _Token {
  const _Token();
}

class _NumberTok extends _Token {
  final double value;
  const _NumberTok(this.value);
}

class _OpTok extends _Token {
  final OperatorType type;
  const _OpTok(this.type);
}

class _ParenTok extends _Token {
  final bool isOpen;
  const _ParenTok(this.isOpen);
}

class _FuncTok extends _Token {
  final String name;
  const _FuncTok(this.name);
}
