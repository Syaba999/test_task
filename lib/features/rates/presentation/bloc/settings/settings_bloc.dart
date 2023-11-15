import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:test_task/features/rates/domain/entities/currency.dart';
import 'package:test_task/features/rates/domain/repositories/rates_database_repository.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(
    this._databaseRepository,
  ) : super(SettingsState.initial()) {
    on<InitSettings>(_onInit);
    on<ToggleEnabled>(_onToggleEnabled);
    on<ChangeOrder>(_onChangeOrder);
  }

  final RatesDatabaseRepository _databaseRepository;

  void _onInit(InitSettings event, Emitter<SettingsState> emit) async {
    emit(const SettingsInProgress());
    final currencies = await _databaseRepository.getCurrencies();
    emit(SettingsSuccess(currencies: currencies));
  }

  Future<void> _onToggleEnabled(
      ToggleEnabled event, Emitter<SettingsState> emit) async {
    if (state is SettingsSuccess) {
      final s = state as SettingsSuccess;
      final index = s.currencies.indexOf(event.currency);
      final currency = event.currency.copyWith(
        enabled: !(event.currency.enabled ?? true),
      );
      final list = [...s.currencies];
      list[index] = currency;
      emit(s.copyWith(currencies: list));
      _databaseRepository.putCurrencies([currency]);
    }
  }

  Future<void> _onChangeOrder(
      ChangeOrder event, Emitter<SettingsState> emit) async {
    if (state is SettingsSuccess) {
      final s = state as SettingsSuccess;
      final list = [...s.currencies];
      final item = list.removeAt(event.oldIndex);
      list.insert(event.newIndex, item);
      for (var i = 0; i < list.length; i++) {
        list[i] = list[i].copyWith(order: i);
      }
      emit(s.copyWith(currencies: list));
      _databaseRepository.putCurrencies(list);
    }
  }
}
