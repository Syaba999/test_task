import 'package:test_task/features/rates/domain/entities/currency.dart';

abstract class RatesDatabaseRepository {
  Future<List<Currency>> getCurrencies();
  Future<void> putCurrencies(List<Currency> list);
  Future<void> deleteCurrencies(List<Currency> list);
  Future<void> clearCurrencies();
}
