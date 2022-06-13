// ignore_for_file: avoid-ignoring-return-values

import 'dart:async';

import 'dart:io';

Future<void> main(List<String> args) => Environment.run(
      environment: createEnvironment(args),
      body: performRenaming,
    );

String capitalized(String source) =>
    source[0].toUpperCase() + source.substring(1);

class NameBundle {
  final String packageName;

  const NameBundle({required this.packageName});
  const NameBundle.original() : this(packageName: 'purple_starter');

  String get _appFileName => packageName + '_app';

  String get appWidgetPath => _appFileName + '.dart';
  String get appWidgetName => _appFileName.split('_').map(capitalized).join();
}

class SetupStats {
  late final Stopwatch _stopwatch = Stopwatch();

  int _replaced = 0;

  int get replaced => _replaced;

  void incrementReplaced() {
    _replaced++;
  }

  void startTimer() {
    _stopwatch.start();
  }

  Duration stopTimer() {
    _stopwatch.stop();

    return _stopwatch.elapsed;
  }
}

class Environment {
  static final _key = Object();

  final NameBundle originalName;
  final NameBundle newName;
  final SetupStats stats;

  Environment({
    required this.originalName,
    required this.newName,
    required this.stats,
  });

  factory Environment.current() => Zone.current[_key] as Environment;

  static R run<R>({
    required Environment environment,
    required R Function() body,
  }) =>
      runZoned(
        body,
        zoneValues: {_key: environment},
      );
}

Environment createEnvironment(List<String> args) => Environment(
      originalName: const NameBundle.original(),
      newName: NameBundle(packageName: args.first),
      stats: SetupStats()..startTimer(),
    );

Future<void> replaceInCodebase(
  String Function(NameBundle nameBundle) select,
) async {
  final environment = Environment.current();

  final originalName = select(environment.originalName);
  final newName = select(environment.newName);

  final files = Directory('./')
      .list(recursive: true)
      .where((event) => event is File)
      .cast<File>();

  await for (final file in files) {
    try {
      final contents = await file.readAsString();
      final replaced = contents.replaceAll(originalName, newName);
      if (contents != replaced) {
        await file.writeAsString(replaced);
        environment.stats.incrementReplaced();
      }
    } on Object {
      // ignore
    }
  }
}

Future<void> renamePackage() => replaceInCodebase(
      (nameBundle) => nameBundle.packageName,
    );

Future<void> renameAppWidgetName() => replaceInCodebase(
      (nameBundle) => nameBundle.appWidgetName,
    );

Future<void> renameWidgetFile() async {}

Future<void> selfDestruct() async {}

Future<void> seq(List<FutureOr<void> Function()> actions) async {
  for (final action in actions) {
    await action();
  }
}

void printResultMessage() {
  final environment = Environment.current();
  final stats = environment.stats;
  final replaced = stats.replaced;
  final duration = stats.stopTimer();

  stdout.write(
    'Setup complete! '
    'Replaced to ${environment.newName}-derived names '
    '$replaced times. Took $duration.',
  );
}

Future<void> performRenaming() => seq(const [
      renamePackage,
      renameAppWidgetName,
      renameWidgetFile,
      selfDestruct,
      printResultMessage,
    ]);
