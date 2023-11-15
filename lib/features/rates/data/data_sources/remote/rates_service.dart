import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:test_task/features/rates/data/models/dto/currency_dto.dart';
import 'package:test_task/features/rates/data/models/rates_request.dart';

part 'rates_service.g.dart';

@RestApi()
@lazySingleton
abstract class RatesService {
  @factoryMethod
  factory RatesService(Dio dio) = _RatesService;

  @GET('exrates/rates')
  Future<List<CurrencyDTO>> fetchRates(@Queries() RatesRequest ratesRequest);
}
