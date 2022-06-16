// ignore_for_file: avoid-ignoring-return-values

import 'dart:async';

import 'dart:io';

Future<void> main(List<String> args) => Environment.run(
      environment: createEnvironment(args),
      body: performSetup,
    );

String capitalized(String source) =>
    source[0].toUpperCase() + source.substring(1);

class NameBundle {
  static const String _originalPackageName = 'purple_starter';

  final String packageName;
  final String appTitle;
  final String packageDescription;

  const NameBundle({
    required this.packageName,
    required this.appTitle,
    required this.packageDescription,
  });

  const NameBundle.original()
      : this(
          packageName: _originalPackageName,
          appTitle: 'An app created from `$_originalPackageName` app template.',
          packageDescription:
              'A fresh Flutter project created using Purple Starter.',
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
  final appTitle = capitalized(packageName.replaceAll('_', ' '));

  return Environment(
    originalName: const NameBundle.original(),
    newName: NameBundle(
      packageName: packageName,
      appTitle: appTitle,
      packageDescription: '$appTitle Flutter app',
    ),
    stats: SetupStats()..startTimer(),
  );
}

Future<void> replaceInCodebase(
  String Function(NameBundle nameBundle) select,
  Stream<File> files,
) async {
  final environment = Environment.current();

  final originalName = select(environment.originalName);
  final newName = select(environment.newName);

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

Future<void> replaceInDirectory(
  String Function(NameBundle nameBundle) select, {
  String path = './',
}) =>
    replaceInCodebase(
      select,
      Directory(path)
          .list(recursive: true)
          .where((event) => event is File)
          .cast(),
    );

Future<void> replaceInFile(
  String path,
  String Function(NameBundle nameBundle) select,
) =>
    replaceInCodebase(
      select,
      Stream.value(
        File(path),
      ),
    );

Future<void> renameAppTitle() => replaceInFile(
      './lib/src/core/l10n/app_en.arb',
      (nameBundle) => nameBundle.appTitle,
    );

Future<void> renamePackageDescription() => replaceInFile(
      './pubspec.yaml',
      (nameBundle) => nameBundle.packageDescription,
    );

Future<void> renamePackage() => replaceInDirectory(
      (nameBundle) => nameBundle.packageName,
    );

Future<void> renameAppWidgetName() => replaceInDirectory(
      (nameBundle) => nameBundle.appWidgetName,
    );

String appWidgetPath(
  NameBundle bundle,
) =>
    './lib/src/feature/app/${bundle.appWidgetPath}';

Future<void> renameWidgetFile() async {
  final environment = Environment.current();

  await File(appWidgetPath(environment.originalName)).rename(
    appWidgetPath(environment.newName),
  );
}

Future<void> renameReadmeFile() async {
  await File('./README.md').rename('./STARTER.md');
}

Future<void> createEmptyReadme() async {
  final file = File('./README.md');

  await file.create();

  final sink = file.openWrite()
    ..write('# ')
    ..writeln(Environment.current().newName.packageName);

  await sink.close();
}

Future<bool> runProcessConcealing(
  String command,
  List<String> arguments,
) async {
  try {
    await Process.run(command, arguments);

    return true;
  } on Object {
    return false;
  }
}

Future<void> createFlutterRunners() async {
  final packageName = Environment.current().newName.packageName;
  final sharedCommands = [
    'create',
    '--project-name',
    packageName,
    '--org',
    'com.$packageName',
    '.',
  ];

  final hasRunFvm = await runProcessConcealing(
    'fvm',
    ['flutter', ...sharedCommands],
  );

  if (!hasRunFvm) {
    final hasRunFlutter = await runProcessConcealing('flutter', sharedCommands);
    if (!hasRunFlutter) {
      throw Exception('Failed to create Flutter runners.');
    }
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

Future<void> seq(List<FutureOr<void> Function()> actions) async {
  for (final action in actions) {
    await action();
  }
}

Future<void> performSetup() => seq(const [
      renameAppTitle,
      renamePackageDescription,
      renamePackage,
      renameAppWidgetName,
      renameWidgetFile,
      renameReadmeFile,
      createEmptyReadme,
      createFlutterRunners,
      printResultMessage,
    ]);
