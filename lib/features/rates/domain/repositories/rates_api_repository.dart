import 'package:test_task/features/rates/data/models/dto/currency_dto.dart';

abstract class RatesApiRepository {
  Future<List<CurrencyDTO>> fetchCurrencies(DateTime date);
}
