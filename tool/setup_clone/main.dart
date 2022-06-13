// ignore_for_file: avoid-ignoring-return-values

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

  static Environment get current => Zone.current[_key] as Environment;

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
    );

Future<void> replaceInFile({
  required String inDirectory,
  required String Function(NameBundle nameBundle) select,
}) async {
  final environment = Environment.current;

  final originalName = select(environment.originalName);
  final newName = select(environment.newName);

  final files = Directory(inDirectory)
      .list(recursive: true)
      .where((event) => event is File)
      .cast<File>();

  await for (final file in files) {
    try {
      final contents = await file.readAsString();
      await file.writeAsString(contents.replaceAll(originalName, newName));
    } on Object {
      // ignore
    }
  }
}

Future<void> renamePackage() => replaceInFile(
      inDirectory: './lib',
      select: (nameBundle) => nameBundle.packageName,
    );

Future<void> renameAppWidgetName() => replaceInFile(
      inDirectory: './lib/feature/app/',
      select: (nameBundle) => nameBundle.appWidgetName,
    );

Future<void> renameWidgetFile() async {}

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
      selfDestruct,
    ]);
