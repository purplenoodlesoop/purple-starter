import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purple_starter/src/feature/settings/enum/app_theme.dart';
import 'package:purple_starter/src/feature/settings/model/settings_data.dart';
import 'package:purple_starter/src/feature/settings/repository/settings_repository.dart';
import 'package:stream_bloc/stream_bloc.dart';

part 'settings_bloc.freezed.dart';

// --- States --- //

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.idle({
    required SettingsData data,
  }) = SettingsStateIdle;

  const factory SettingsState.loading({
    required SettingsData data,
  }) = SettingsStateLoading;

  const factory SettingsState.updatedSuccessfully({
    required SettingsData data,
  }) = SettingsStateUpdatedSuccessfully;

  const factory SettingsState.error({
    required SettingsData data,
    required String description,
  }) = SettingsStateError;
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
        super(
          SettingsState.idle(
            data: settingsRepository.currentData(),
          ),
        );

  SettingsData get _data => state.data;

  Stream<SettingsState> _performMutation(
    Future<void> Function() body,
  ) async* {
    yield SettingsState.loading(data: _data);
    try {
      await body();
      yield SettingsState.updatedSuccessfully(
        data: _settingsRepository.currentData(),
      );
    } on Object catch (e) {
      yield SettingsState.error(
        data: _data,
        description: e.toString(),
      );
      rethrow;
    } finally {
      yield SettingsState.idle(data: _data);
    }
  }

  Stream<SettingsState> _setTheme(AppTheme theme) => _performMutation(
        () => _settingsRepository.setTheme(theme),
      );

  @override
  Stream<SettingsState> mapEventToStates(SettingsEvent event) => event.when(
        setTheme: _setTheme,
      );
}
