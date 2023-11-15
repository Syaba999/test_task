import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_task/core/utils/request_date_converter.dart';

part 'rates_request.freezed.dart';
part 'rates_request.g.dart';

@freezed
class RatesRequest with _$RatesRequest {
  factory RatesRequest({
    @RequestDateConverter() @JsonKey(name: 'ondate') required DateTime onDate,
    required int periodicity,
  }) = _RatesRequest;

  factory RatesRequest.fromJson(Map<String, dynamic> json) =>
      _$RatesRequestFromJson(json);
}
