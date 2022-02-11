import 'dart:async';

Future<void> main(List<String> args) => Environment.run(
      environment: createEnvironment(args),
      body: performRenaming,
    );

String capitalized(String source) =>
    "${source[0].toUpperCase()}${source.substring(1)}";

class NameBundle {
  final String packageName;

  const NameBundle({required this.packageName});

  String get appTitle => "An app created from `$packageName` app template.";
  String get appWidgetName =>
      packageName.split("_").map(capitalized).followedBy(const ["App"]).join();
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
      originalName: const NameBundle(packageName: "purple_starter"),
      newName: NameBundle(packageName: args.first),
    );

Future<void> _renamePackage() async {}
Future<void> _renameAppTitle() async {}
Future<void> _renameAppWidgetName() async {}

Future<void> performRenaming() async {
  await _renamePackage();
  await _renameAppTitle();
  await _renameAppWidgetName();
}
