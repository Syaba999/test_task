part of 'currency_db_entity.dart';

@embedded
class RateDbEntity {
  RateDbEntity({this.date, this.value});

  final DateTime? date;
  final double? value;

  factory RateDbEntity.fromRate(Rate rate) =>
      RateDbEntity(date: rate.date, value: rate.value);

  Rate toRate() => Rate(date: date, value: value);
}
