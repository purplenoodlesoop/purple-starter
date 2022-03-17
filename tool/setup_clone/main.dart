import 'dart:async';

import 'dart:io';

Future<void> main(List<String> args) => Environment.run(
      environment: createEnvironment(args),
      body: performRenaming,
    );

String capitalized(String source) =>
    '${source[0].toUpperCase()}${source.substring(1)}';

class NameBundle {
  final String packageName;

  const NameBundle({required this.packageName});
  const NameBundle.original() : this(packageName: 'purple_starter');

  String get _appFileName => packageName + '_app';

  String get appWidgetPath => _appFileName + '.dart';
  String get appWidgetName => _appFileName.split('_').map(capitalized).join();
}

class Environment {
  static const _key = Object();

  final NameBundle originalName;
  final NameBundle newName;

  Environment({
    required this.originalName,
    required this.newName,
  });

  static R run<R>({
    required Environment environment,
    required R Function() body,
  }) =>
      runZoned(
        body,
        zoneValues: {_key: environment},
      );

  static Environment get current => (Zone.current[_key] as Environment?)!;
}

Environment createEnvironment(List<String> args) => Environment(
      originalName: const NameBundle.original(),
      newName: NameBundle(packageName: args.first),
    );

Future<void> rename({
  required String inDirectory,
  required String Function(NameBundle nameBundle) select,
}) async {
  final environment = Environment.current;

  final from = select(environment.originalName);
  final to = select(environment.newName);

  await Process.run('find', [
    inDirectory,
    '( -type d -name .git -prune )',
    '-o',
    '-type',
    'f',
    '-print0',
    '|',
    'xargs',
    '-0',
    'sed',
    '-i',
    "''",
    "'s/$from/$to/g'",
  ]);
}

Future<void> renamePackage() => rename(
      inDirectory: './',
      select: (nameBundle) => nameBundle.packageName,
    );

Future<void> renameAppWidgetName() => rename(
      inDirectory: './lib/feature/app/',
      select: (nameBundle) => nameBundle.appWidgetName,
    );

Future<void> renameWidgetFile() async {}

Future<void> moveReadmeToSetup() async {}
Future<void> createEmptyReadme() async {}
Future<void> selfDestruct() async {}

Future<void> seq(List<Future<void> Function()> actions) async {
  for (final action in actions) {
    await action();
  }
}

Future<void> performRenaming() => seq(const [
      renamePackage,
      renameAppWidgetName,
      renameWidgetFile,
      moveReadmeToSetup,
      createEmptyReadme,
      selfDestruct,
    ]);
