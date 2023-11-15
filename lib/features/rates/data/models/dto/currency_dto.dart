import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_dto.freezed.dart';
part 'currency_dto.g.dart';

@freezed
class CurrencyDTO with _$CurrencyDTO {
  const factory CurrencyDTO({
    @JsonKey(name: 'Cur_ID') required int id,
    @JsonKey(name: 'Date') required DateTime date,
    @JsonKey(name: 'Cur_Abbreviation') required String abbr,
    @JsonKey(name: 'Cur_Scale') required int scale,
    @JsonKey(name: 'Cur_Name') required String name,
    @JsonKey(name: 'Cur_OfficialRate') required double rate,
  }) = _CurrencyDTO;

  factory CurrencyDTO.fromJson(Map<String, dynamic> json) =>
      _$CurrencyDTOFromJson(json);
}
