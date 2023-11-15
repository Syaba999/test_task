import 'package:injectable/injectable.dart';
import 'package:test_task/features/rates/data/data_sources/remote/rates_service.dart';
import 'package:test_task/features/rates/data/models/dto/currency_dto.dart';
import 'package:test_task/features/rates/data/models/rates_request.dart';
import 'package:test_task/features/rates/domain/repositories/rates_api_repository.dart';

@LazySingleton(as: RatesApiRepository)
class RatesApiRepositoryImpl implements RatesApiRepository {
  const RatesApiRepositoryImpl(this._api);

  final RatesService _api;

  @override
  Future<List<CurrencyDTO>> fetchCurrencies(DateTime date) async {
    try {
      return await _api.fetchRates(RatesRequest(onDate: date, periodicity: 0));
    } catch (e) {
      rethrow;
    }
  }
}
