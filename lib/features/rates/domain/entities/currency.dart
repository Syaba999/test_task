import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_task/features/rates/data/models/dto/currency_dto.dart';

import 'rate.dart';

part 'currency.freezed.dart';

@freezed
class Currency with _$Currency {
  const Currency._();

  const factory Currency({
    required int id,
    required String name,
    required String abbr,
    Rate? rate,
    Rate? nextDayRate,
    Rate? previousDayRate,
    @Default(0) int order,
    bool? enabled,
  }) = _Currency;

  CurrencyType get type {
    switch (id) {
      case 431:
        return CurrencyType.usd;
      case 451:
        return CurrencyType.eur;
      case 456:
        return CurrencyType.rub;
      default:
        return CurrencyType.other;
    }
  }

  factory Currency.fromDTO(CurrencyDTO dto) =>
      Currency(id: dto.id, name: dto.name, abbr: dto.abbr);
}

enum CurrencyType {
  usd,
  eur,
  rub,
  other,
}
