import 'dart:convert';
import 'dart:io';

import 'package:makefile/makefile.dart';
import 'package:md/md.dart';
import 'package:stream_transform/stream_transform.dart';

extension on String {
  String capitalized() =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}

File get makefile => File('./Makefile');

File get makefileDocumentation => File('./documentation/markdown.md');

bool notPlatformImports(
  File file,
) =>
    file.uri.pathSegments.last != 'platform.mk';

bool notPhony(
  MakefileTarget event,
) =>
    event.info.name != '.PHONY';

Stream<List<int>> openRead(File file) => file.openRead();

List<MakefileTarget> sortTargets(List<MakefileTarget> targets) =>
    targets.toList(growable: false)
      ..sort((a, b) => a.info.name.compareTo(b.info.name));

Markdown indexEntry(MakefileTarget target) {
  final name = target.info.name;

  return Markdown.link(
    label: name.replaceAll('-', ' ').capitalized(),
    destination: '#$name',
  );
}

Markdown index(List<MakefileTarget> targets) => Markdown.section(
      header: 'Index',
      children: [
        Markdown.list(
          style: ListStyle.unordered,
          children: targets.map(indexEntry).toList(),
        ),
      ],
    );

Markdown targetEntry(MakefileTarget target) {
  final info = target.info;
  final comments = info.comments;
  final name = info.name;
  final prerequisites = target.prerequisites;
  final recipe = target.recipe;

  return Markdown.section(
    header: name.replaceAll('-', ' ').capitalized(),
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
      if (prerequisites.isNotEmpty)
        Markdown.section(
          header: 'Perquisites',
          children: [
            Markdown.list(
              style: ListStyle.unordered,
              children: prerequisites
                  .map(
                    (prerequisite) => Markdown.text(
                      data: prerequisite,
                      style: TextStyle.code,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
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

Markdown targets(List<MakefileTarget> targets) => Markdown.section(
      header: 'Targets',
      children: targets.map(targetEntry).toList(),
    );

Markdown documentation(List<MakefileTarget> targetsList) => Markdown.section(
      header: 'Makefile documentation',
      children: [
        Markdown.text(
          data: 'This file is auto-generated',
        ),
        index(targetsList),
        targets(targetsList),
      ],
    );

Future<void> main(List<String> arguments) => Directory('./automation/makefile')
    .list(recursive: true)
    .whereType<File>()
    .startWith(makefile)
    .where(notPlatformImports)
    .asyncExpand(openRead)
    .transform(utf8.decoder)
    .transform(const LineSplitter())
    .transform(const MakefileParser())
    .whereType<MakefileTarget>()
    .where(notPhony)
    .toList()
    .then(sortTargets)
    .then(documentation)
    .then(renderMarkdown)
    .then(makefileDocumentation.writeAsString);
