part of 'settings_bloc.dart';

@freezed
class SettingsEvent {
  factory SettingsEvent.init() = InitSettings;
  factory SettingsEvent.toggleEnabled({required Currency currency}) =
      ToggleEnabled;
  factory SettingsEvent.changeOrder(
      {required int oldIndex, required int newIndex}) = ChangeOrder;
}
