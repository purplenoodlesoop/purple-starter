import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:makefile/makefile.dart';
import 'package:md/md.dart';
import 'package:stream_transform/stream_transform.dart';

class Target {
  final String name;
  final String formattedName;
  final List<String> comments;
  final List<String> prerequisites;
  final List<String> recipe;

  Target({
    required this.name,
    required this.formattedName,
    required this.comments,
    required this.prerequisites,
    required this.recipe,
  });

  factory Target.fromMakefileTarget(
    MakefileTarget target,
  ) {
    final info = target.info;
    final name = info.name;

    return Target(
      name: name,
      formattedName: _formatName(name),
      comments: info.comments,
      prerequisites: target.prerequisites,
      recipe: target.recipe,
    );
  }

  static String _formatName(String name) {
    final spaced = name.replaceAll('-', ' ');

    return '${spaced[0].toUpperCase()}${spaced.substring(1).toLowerCase()}';
  }
}

Directory get makefilesDirectory => Directory('./automation/makefile');
File get rootMakefile => File('./Makefile');
File get makefileDocumentation => File('./documentation/makefile.md');

bool notPlatformImports(
  File file,
) =>
    file.uri.pathSegments.last != 'platform.mk';

Stream<Makefile> parseMakefile(File file) => file
    .openRead()
    .transform(utf8.decoder)
    .transform(const LineSplitter())
    .transform(const MakefileParser());

bool usableTarget(
  MakefileTarget event,
) =>
    !const ['.PHONY', '_echo_os'].contains(event.info.name);

List<Target> mapTargets(List<MakefileTarget> targets) =>
    targets.map(Target.fromMakefileTarget).toList();

Stream<List<int>> openRead(File file) => file.openRead();

List<Target> sortTargets(List<Target> targets) =>
    targets.toList(growable: false)..sort((a, b) => a.name.compareTo(b.name));

Future<A> withDocumentationSink<A>(
  FutureOr<A> Function(IOSink sink) body,
) async {
  final sink = makefileDocumentation.openWrite();
  try {
    return await body(sink);
  } finally {
    await sink.close();
  }
}

Future<void> writeLines(Iterable<String> lines) => withDocumentationSink(
      (sink) => sink.writeAll(lines),
    );

Markdown targetLink(Target target) => Markdown.link(
      label: target.formattedName,
      destination: '#${target.name}',
    );

Markdown codeText(String text) => Markdown.text(
      data: text,
      style: TextStyle.code,
    );

Markdown index(List<Target> targets) => Markdown.section(
      header: 'Index',
      children: [
        Markdown.list(
          style: ListStyle.unordered,
          children: targets.map(targetLink).toList(),
        ),
      ],
    );

Markdown unorderedListBuilder<T>(
  String header,
  Iterable<T> entries,
  Markdown Function(T text) builder,
) =>
    Markdown.section(
      header: header,
      children: [
        Markdown.list(
          style: ListStyle.unordered,
          children: entries.map(builder).toList(),
        ),
      ],
    );

Markdown targetEntry(List<Target> targets, Target target) {
  final comments = target.comments;
  final name = target.name;
  final prerequisites =
      target.prerequisites.where((element) => element.isNotEmpty);
  final usedBy = targets.where(
    (element) =>
        element.prerequisites.contains(name) ||
        element.recipe.any((line) => line.contains('make $name')),
  );
  final recipe = target.recipe;

  return Markdown.section(
    header: target.formattedName,
    children: [
      if (comments.isNotEmpty)
        Markdown.text(
          data: comments.join(' '),
        ),
      Markdown.section(
        header: 'Name',
        children: [
          Markdown.text(
            data: name,
            style: TextStyle.code,
          ),
        ],
      ),
      if (usedBy.isNotEmpty)
        unorderedListBuilder('Used by', usedBy, targetLink),
      if (prerequisites.isNotEmpty)
        unorderedListBuilder('Perquisites', prerequisites, codeText),
      if (recipe.isNotEmpty)
        Markdown.section(
          header: 'Recipe',
          children: [
            Markdown.code(
              language: 'Makefile',
              data: recipe,
            ),
          ],
        ),
    ],
  );
}

Markdown targets(List<Target> targets) => Markdown.section(
      header: 'Targets',
      children: targets.map((entry) => targetEntry(targets, entry)).toList(),
    );

Markdown documentation(List<Target> targetsList) => Markdown.section(
      header: 'Makefile documentation',
      children: [
        Markdown.text(
          data: 'This file is auto-generated',
        ),
        index(targetsList),
        targets(targetsList),
      ],
    );

Future<void> main(List<String> arguments) => makefilesDirectory
    .list(recursive: true)
    .whereType<File>()
    .startWith(rootMakefile)
    .where(notPlatformImports)
    .concurrentAsyncExpand(parseMakefile)
    .whereType<MakefileTarget>()
    .where(usableTarget)
    .toList()
    .then(mapTargets)
    .then(sortTargets)
    .then(documentation)
    .then(renderMarkdownByLine)
    .then(writeLines);
