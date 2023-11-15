import 'package:isar/isar.dart';
import 'package:test_task/features/rates/domain/entities/currency.dart';
import 'package:test_task/features/rates/domain/entities/rate.dart';

part 'currency_db_entity.g.dart';
part 'rate_db_entity.dart';

@collection
class CurrencyDbEntity {
  final Id id;
  final String name;
  final String abbr;
  final RateDbEntity? rate;
  final RateDbEntity? nextDayRate;
  final RateDbEntity? previousDayRate;
  final int order;
  final bool enabled;

  CurrencyDbEntity({
    required this.id,
    required this.name,
    required this.abbr,
    this.rate,
    this.nextDayRate,
    this.previousDayRate,
    this.order = 0,
    this.enabled = false,
  });

  factory CurrencyDbEntity.fromCurrency(Currency currency) => CurrencyDbEntity(
        id: currency.id,
        name: currency.name,
        abbr: currency.abbr,
        rate: currency.rate == null
            ? null
            : RateDbEntity.fromRate(currency.rate!),
        nextDayRate: currency.nextDayRate == null
            ? null
            : RateDbEntity.fromRate(currency.nextDayRate!),
        previousDayRate: currency.previousDayRate == null
            ? null
            : RateDbEntity.fromRate(currency.previousDayRate!),
        order: currency.order,
        enabled: currency.enabled ?? false,
      );

  Currency toCurrency() => Currency(
        id: id,
        name: name,
        abbr: abbr,
        rate: rate?.toRate(),
        nextDayRate: nextDayRate?.toRate(),
        previousDayRate: previousDayRate?.toRate(),
        order: order,
        enabled: enabled,
      );
}
