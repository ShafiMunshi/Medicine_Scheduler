import 'package:logger/logger.dart';

final logger =
    (Type type) => Logger(printer: SimpleLogPrinter(type.toString()));

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  // @override
  // Future<List<String>> log(LogEvent event) async {
  //   return [event.message];
  // }
  @override
  List<String> log(event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;
    return [color!('$emoji $className - $message')];
  }
}
