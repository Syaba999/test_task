import 'package:test_task/features/rates/data/models/dto/currency_dto.dart';

class Rate {
  Rate({this.date, this.value});

  final DateTime? date;
  final double? value;

  factory Rate.fromDTO(CurrencyDTO dto) =>
      Rate(date: dto.date, value: dto.rate);
}
