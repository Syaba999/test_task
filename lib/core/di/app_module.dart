import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:test_task/core/data/models/network_configuration.dart';

@module
abstract class AppModule {
  @lazySingleton
  NetworkConfiguration get networkConfiguration =>
      NetworkConfiguration(baseUrl: 'https://api.nbrb.by/');

  @lazySingleton
  Dio dio(NetworkConfiguration networkConfiguration) => Dio(BaseOptions(
      baseUrl: networkConfiguration.baseUrl, contentType: 'application/json'));
}
