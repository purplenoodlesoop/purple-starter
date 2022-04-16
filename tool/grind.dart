// ignore_for_file: avoid-ignoring-return-values

import 'dart:io';

import 'package:grinder/grinder.dart';

void main(List<String> args) => grind(args);

String _runFlutter(
  String command, {
  List<String> arguments = const [],
}) =>
    run('fvm', arguments: ['flutter', command, ...arguments]);

String _runPub(
  String command, {
  List<String> arguments = const [],
}) =>
    _runFlutter('pub', arguments: ['run', command, ...arguments]);

void _runMetrics(String actionDescription, String command) {
  const excludedFiles = '{'
      '/**.g.dart,'
      '/**.gr.dart,'
      '/**.gen.dart,'
      '/**.freezed.dart,'
      '/**.template.dart'
      '}';

  log('* $actionDescription using Dart Code Metrics *');

  _runPub(
    'dart_code_metrics:metrics',
    arguments: [command, 'lib', '--exclude=$excludedFiles'],
  );
}

void _runMetricsUnused(String type) {
  _runMetrics('Checking for unused $type', 'check-unused-$type');
}

@Task('Clean project.')
void cleanFlutter() {
  _runFlutter('clean');
}

@Task('Clean iOS.')
@Depends(cleanFlutter)
Future<void> cleanIos() async {
  const directory = 'ios/';
  const targetDirectories = ['.symlinks/', 'Pods'];
  const targetFiles = ['Podfile.lock'];

  Iterable<FileSystemEntity> entitiesFromPaths(
    Iterable<String> paths,
    FileSystemEntity Function(String path) getEntity,
  ) =>
      paths.map((path) => directory + path).map(getEntity);

  run('pod', arguments: const ['cache', 'clean', '--all']);

  run('xcodebuild', arguments: const ['clean']);

  entitiesFromPaths(targetDirectories, getDir)
      .followedBy(entitiesFromPaths(targetFiles, getFile))
      .forEach(delete);
}

@Task('Dart Code Metrics: analyze.')
void codeMetricsAnalyze() {
  _runMetrics('Analyzing the codebase', 'analyze');
}

@Task('Dart Code Metrics: check for unused files.')
void codeMetricsUnusedFiles() {
  _runMetricsUnused('files');
}

@Task('Dart Code Metrics: check for unused l10n.')
void codeMetricsUnusedL10n() {
  _runMetricsUnused('l10n');
}

@Task('Dart Code Metrics: check for unused code.')
void codeMetricsUnusedCode() {
  _runMetricsUnused('code');
}
