// ignore_for_file: avoid-ignoring-return-values

import 'dart:io';

import 'package:grinder/grinder.dart';

void main(List<String> args) => grind(args);

extension on List<String> {
  String joinExecutables() => join(' && ');
}

@Task('Clean project.')
void cleanFlutter() {
  run('fvm flutter clean');
}

@Task('Clean iOS.')
@Depends(cleanFlutter)
Future<void> cleanIos() async {
  const directory = 'ios/';
  const xcodeCleanCommands = ['pod cache clean --all', 'xcodebuild clean'];
  const targetDirectories = ['.symlinks/', 'Pods'];
  const targetFiles = ['Podfile.lock'];

  Iterable<String> amendPaths(Iterable<String> paths) => paths.map(
        (path) => directory + path,
      );

  run(xcodeCleanCommands.joinExecutables(), workingDirectory: directory);

  amendPaths(targetDirectories)
      .map<FileSystemEntity>(getDir)
      .followedBy(amendPaths(targetFiles).map(getFile))
      .forEach(delete);
}
