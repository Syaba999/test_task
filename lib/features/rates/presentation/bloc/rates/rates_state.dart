part of 'rates_bloc.dart';

@freezed
class RatesState with _$RatesState {
  const factory RatesState.inProgress() = RatesInProgress;
  const factory RatesState.failure({required String message}) = RatesFailure;
  const factory RatesState.success({
    @Default([]) List<Currency> currencies,
    @Default(false) bool hasNextDayCurrencies,
  }) = RatesSuccess;

  factory RatesState.initial() => const RatesSuccess();
}
