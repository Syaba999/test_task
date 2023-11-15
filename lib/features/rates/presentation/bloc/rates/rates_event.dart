part of 'rates_bloc.dart';

@freezed
class RatesEvent with _$RatesEvent {
  factory RatesEvent.init() = InitRates;
  factory RatesEvent.updateData() = UpdateData;
}
