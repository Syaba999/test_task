import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:test_task/features/rates/domain/entities/currency.dart';
import 'package:test_task/features/rates/domain/entities/rate.dart';
import 'package:test_task/features/rates/domain/repositories/rates_api_repository.dart';
import 'package:test_task/features/rates/domain/repositories/rates_database_repository.dart';
import 'package:test_task/generated/l10n.dart';

part 'rates_bloc.freezed.dart';
part 'rates_event.dart';
part 'rates_state.dart';

@injectable
class RatesBloc extends Bloc<RatesEvent, RatesState> {
  RatesBloc(
    this._apiRepository,
    this._databaseRepository,
  ) : super(RatesState.initial()) {
    on<InitRates>(_onInit);
    on<UpdateData>(_onUpdateData);
  }

  final RatesApiRepository _apiRepository;
  final RatesDatabaseRepository _databaseRepository;

  Future<void> _onInit(InitRates event, Emitter<RatesState> emit) async {
    try {
      emit(const RatesInProgress());
      final savedCurrencies = await _databaseRepository.getCurrencies();
      final currentResult =
          await _apiRepository.fetchCurrencies(DateTime.now());
      final removedCurrencies = savedCurrencies
          .where((currencyEntity) => !currentResult
              .any((currencyDto) => currencyDto.id == currencyEntity.id))
          .toList();
      if (removedCurrencies.isNotEmpty) {
        await _databaseRepository.deleteCurrencies(removedCurrencies);
      }
      final currentCurrencies = <Currency>[];
      for (var i = 0; i < currentResult.length; i++) {
        final currentCurrencyDto = currentResult[i];
        currentCurrencies.add(
          savedCurrencies.firstWhere(
            (element) => element.id == currentCurrencyDto.id,
            orElse: () {
              final currency = Currency.fromDTO(currentCurrencyDto);
              final enabled = currency.type != CurrencyType.other;
              final order = switch (currency.type) {
                CurrencyType.usd => 0,
                CurrencyType.eur => 1,
                CurrencyType.rub => 2,
                CurrencyType.other => savedCurrencies.length + i + 3,
              };
              return currency.copyWith(enabled: enabled, order: order);
            },
          ).copyWith(
            name: currentCurrencyDto.name,
            abbr: currentCurrencyDto.abbr,
            rate: Rate.fromDTO(currentCurrencyDto),
          ),
        );
      }
      final nextDayResponse = await _apiRepository.fetchCurrencies(
        DateTime.now().add(
          const Duration(days: 1),
        ),
      );
      final hasNextDateRates = nextDayResponse.isNotEmpty;
      final list = <Currency>[];
      if (hasNextDateRates) {
        list.addAll(currentCurrencies.map((e) {
          final nextDayDto =
              nextDayResponse.firstWhereOrNull((dto) => dto.id == e.id);
          return nextDayDto != null
              ? e.copyWith(nextDayRate: Rate.fromDTO(nextDayDto))
              : e;
        }));
      } else {
        final previousDayResponse = await _apiRepository.fetchCurrencies(
          DateTime.now().subtract(
            const Duration(days: 1),
          ),
        );
        list.addAll(currentCurrencies.map((e) {
          final previousDayDto =
              previousDayResponse.firstWhereOrNull((dto) => dto.id == e.id);
          return previousDayDto != null
              ? e.copyWith(previousDayRate: Rate.fromDTO(previousDayDto))
              : e;
        }));
      }
      list.sort((a, b) => a.order.compareTo(b.order));
      await _databaseRepository.putCurrencies(list);
      emit(
        RatesSuccess(
          currencies: list,
          hasNextDayCurrencies: hasNextDateRates,
        ),
      );
    } catch (e) {
      emit(RatesFailure(message: S.current.currenciesError));
    }
  }

  Future<void> _onUpdateData(UpdateData event, Emitter<RatesState> emit) async {
    if (state is RatesSuccess) {
      final s = state as RatesSuccess;
      emit(const RatesInProgress());
      final currencies = await _databaseRepository.getCurrencies();
      emit(s.copyWith(currencies: currencies));
    }
  }
}
