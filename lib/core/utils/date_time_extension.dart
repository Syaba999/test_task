import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String format(String formatter) => DateFormat(formatter).format(this);
}
