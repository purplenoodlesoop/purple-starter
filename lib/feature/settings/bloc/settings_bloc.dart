import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purple_starter/feature/settings/enum/app_theme.dart';
import 'package:purple_starter/feature/settings/repository/settings_repository.dart';
import 'package:stream_bloc/stream_bloc.dart';

part 'settings_bloc.freezed.dart';

// --- States --- //

@freezed
class SettingsData with _$SettingsData {
  const factory SettingsData({
    AppTheme? theme,
  }) = _SettingsData;

  static const SettingsData initial = SettingsData();
}

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.idle({
    required SettingsData data,
  }) = _SettingsStateIdle;

  const factory SettingsState.loading({
    required SettingsData data,
  }) = _SettingsStateLoading;

  const factory SettingsState.error({
    required SettingsData data,
    required String description,
  }) = _SettingsStateError;
}

extension on SettingsState {
  SettingsState toLoading() => SettingsState.loading(data: data);

  SettingsState toIdle() => SettingsState.idle(data: data);

  SettingsState toError({
    required String description,
  }) =>
      SettingsState.error(data: data, description: description);
}

// --- Events --- //

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.setTheme({
    required AppTheme theme,
  }) = _SettingsEventSetTheme;
}

// --- BLoC --- //

class SettingsBloc extends StreamBloc<SettingsEvent, SettingsState> {
  final ISettingsRepository _settingsRepository;

  SettingsBloc({
    required ISettingsRepository settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(const SettingsState.idle(data: SettingsData.initial));

  Stream<SettingsState> _performMutation(
    Future<SettingsData> Function() body,
  ) async* {
    yield state.toLoading();
    try {
      final newData = await body();
      yield SettingsState.idle(data: newData);
    } on Object catch (e) {
      yield state.toError(description: e.toString());
      yield state.toIdle();
    }
  }

  Stream<SettingsState> _setTheme(AppTheme theme) => _performMutation(() async {
        await _settingsRepository.setTheme(theme);

        return state.data.copyWith(theme: theme);
      });

  @override
  Stream<SettingsState> mapEventToStates(SettingsEvent event) => event.when(
        setTheme: _setTheme,
      );
}
