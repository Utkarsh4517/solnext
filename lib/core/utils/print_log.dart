import 'package:logger/logger.dart';

class PrintLog {
  static void printLog(dynamic message) {
    Logger(printer: PrettyPrinter()).d(message);
  }
}
