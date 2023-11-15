import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_task/features/rates/data/models/db/currency_db_entity.dart';
import 'package:test_task/features/rates/domain/entities/currency.dart';
import 'package:test_task/features/rates/domain/repositories/rates_database_repository.dart';

@preResolve
@LazySingleton(as: RatesDatabaseRepository)
class RatesDatabaseRepositoryImpl implements RatesDatabaseRepository {
  const RatesDatabaseRepositoryImpl._(this._isar);

  @factoryMethod
  static Future<RatesDatabaseRepositoryImpl> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [CurrencyDbEntitySchema],
      directory: dir.path,
    );
    return RatesDatabaseRepositoryImpl._(isar);
  }

  final Isar _isar;

  @override
  Future<List<Currency>> getCurrencies() async {
    return await _isar.writeTxn(() async {
      final list =
          await _isar.currencyDbEntitys.where().sortByOrder().findAll();
      return list.map((e) => e.toCurrency()).toList();
    });
  }

  @override
  Future<void> putCurrencies(List<Currency> currencies) async {
    await _isar.writeTxn(() async {
      final list =
          currencies.map((e) => CurrencyDbEntity.fromCurrency(e)).toList();
      await _isar.currencyDbEntitys.putAll(list);
    });
  }

  @override
  Future<void> deleteCurrencies(List<Currency> list) async {
    await _isar.writeTxn(() async {
      await _isar.currencyDbEntitys.deleteAll(list.map((e) => e.id).toList());
    });
  }

  @override
  Future<void> clearCurrencies() async {
    await _isar.writeTxn(() async {
      await _isar.clear();
    });
  }
}
