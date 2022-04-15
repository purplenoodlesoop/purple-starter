import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purple_starter/src/feature/settings/enum/app_theme.dart';
import 'package:purple_starter/src/feature/settings/repository/settings_repository.dart';
import 'package:stream_bloc/stream_bloc.dart';
import 'package:sum/sum.dart';

part 'settings_bloc.freezed.dart';

// --- States --- //

@freezed
class SettingsData with _$SettingsData {
  const factory SettingsData({
    required AppTheme theme,
  }) = _SettingsData;
}

typedef SettingsState = PersistentAsyncData<String, SettingsData>;

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
        super(_initialState(settingsRepository));

  static SettingsState _initialState(
    ISettingsRepository repository,
  ) =>
      SettingsState.idle(
        data: SettingsData(
          theme: repository.theme ?? AppTheme.system,
        ),
      );

  Stream<SettingsState> _performMutation(
    Future<SettingsData> Function() body,
  ) async* {
    yield state.toLoading();
    try {
      final newData = await body();
      yield SettingsState.idle(data: newData);
    } on Object catch (e) {
      yield state.toError(error: e.toString());
      rethrow;
    } finally {
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
