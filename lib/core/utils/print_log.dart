import 'package:logger/logger.dart';

class PrintLog {
  static void printLog(String message) {
    Logger(printer: PrettyPrinter()).d(message);
  }
}
