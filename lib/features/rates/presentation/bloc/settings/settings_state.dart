part of 'settings_bloc.dart';

@freezed
class SettingsState {
  const factory SettingsState.inProgress() = SettingsInProgress;
  const factory SettingsState.success({
    @Default([]) List<Currency> currencies,
  }) = SettingsSuccess;
  const factory SettingsState.failure({required String message}) =
      SettingsFailure;

  factory SettingsState.initial() => const SettingsSuccess();
}
