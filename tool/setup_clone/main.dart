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
  static const String _originalPackageName = 'purple_starter';

  final String packageName;
  final String appTitle;

  const NameBundle({
    required this.packageName,
    required this.appTitle,
  });

  const NameBundle.original()
      : this(
          packageName: _originalPackageName,
          appTitle: 'An app created from `$_originalPackageName` app template.',
        );

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

Environment createEnvironment(List<String> args) {
  final packageName = args.first;

  return Environment(
    originalName: const NameBundle.original(),
    newName: NameBundle(
      packageName: packageName,
      appTitle: capitalized(packageName.replaceAll('_', ' ')),
    ),
    stats: SetupStats()..startTimer(),
  );
}

Future<void> replaceInCodebase(
  String Function(NameBundle nameBundle) select, {
  String path = './',
}) async {
  final environment = Environment.current();

  final originalName = select(environment.originalName);
  final newName = select(environment.newName);

  final files = Directory(path)
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

Future<void> renameAppTitle() => replaceInCodebase(
      (nameBundle) => nameBundle.appTitle,
      path: './lib/src/core/l10n/',
    );

Future<void> renameWidgetFile() async {}

Future<void> selfDestruct() async {}

Future<void> seq(List<FutureOr<void> Function()> actions) async {
  for (final action in actions) {
    await action();
  }
}

String assembleMessage(String newName, int replaced, Duration duration) =>
    'Setup complete! '
    'Replaced to $newName-derived names '
    '$replaced times. Took $duration.';

void printResultMessage() {
  final environment = Environment.current();
  final stats = environment.stats;

  stdout.write(
    assembleMessage(
      environment.newName.packageName,
      stats.replaced,
      stats.stopTimer(),
    ),
  );
}

Future<void> performRenaming() => seq(const [
      renamePackage,
      renameAppWidgetName,
      renameAppTitle,
      renameWidgetFile,
      selfDestruct,
      printResultMessage,
    ]);
