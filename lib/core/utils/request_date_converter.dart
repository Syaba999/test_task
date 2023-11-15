import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class RequestDateConverter implements JsonConverter<DateTime, String> {
  const RequestDateConverter();

  @override
  DateTime fromJson(String json) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.parse(json);
  }

  @override
  String toJson(DateTime date) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  }
}
