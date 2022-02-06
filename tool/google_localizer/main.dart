import 'dart:async';
import 'dart:io';

import 'package:pure/pure.dart';
import 'package:translator/translator.dart';

void main(List<String> args) => Environment.run(
      environment: createEnvironment(args),
      body: localize,
    );

const languages = [
  "ru",
  "pt",
  "es",
  "it",
];

typedef Language = String;
typedef ArbContents = Map<String, String>;
typedef ArbEntry = MapEntry<String, String>;

class Environment {
  static const _key = Object();

  final String localizationFolder;
  final GoogleTranslator translator;

  Environment(this.localizationFolder, this.translator);

  static T run<T>({
    required Environment environment,
    required T Function() body,
  }) =>
      runZoned(
        body,
        zoneValues: {_key: environment},
      );

  static Environment get current => (Zone.current[_key] as Environment?)!;
}

class Localization {
  final Language language;
  final ArbContents contents;

  const Localization(this.language, this.contents);
}

class WritableLocalization {
  final Language language;
  final String fileContents;

  WritableLocalization(this.language, this.fileContents);

  @override
  String toString() => fileContents;
}

Environment createEnvironment(List<String> args) => Environment(
      args.first,
      GoogleTranslator(),
    );

String _localizationPath(Language language) =>
    "${Environment.current.localizationFolder}/app_$language.arb";

List<String> readEnglishLocalizations() =>
    File(_localizationPath("en")).readAsLinesSync();

String _trimLine(String source) => source.trim().replaceAll(RegExp(',|"'), "");

ArbEntry _lineToEntry(String line) {
  final split = line.split(": ");

  return MapEntry(split[0], split[1]);
}

ArbContents extractLocalizations(
  List<String> rawStrings,
) =>
    rawStrings
        .sublist(1, rawStrings.length - 1)
        .map(_trimLine)
        .map(_lineToEntry)
        .pipe((entries) => Map.fromEntries(entries));

Future<ArbEntry> _translateEntry(
  Language language,
  ArbEntry englishEntry,
) async {
  final translation = await Environment.current.translator.translate(
    englishEntry.value,
    from: 'en',
    to: language,
  );

  return MapEntry(englishEntry.key, translation.text);
}

Future<Localization> _translateTo(
  ArbContents englishContents,
  Language language,
) =>
    _translateEntry
        .apply(language)
        .pipe(englishContents.entries.map)
        .pipe(Future.wait)
        .then((translated) => Map.fromEntries(translated))
        .then((contents) => Localization(language, contents));

Stream<Localization> translateAll(
  ArbContents englishContents,
) async* {
  final translated = await _translateTo
      .apply(englishContents)
      .pipe(languages.map)
      .toList()
      .pipe(Future.wait);

  yield* Stream.fromIterable(translated);
}

WritableLocalization formatLocalization(
  Localization localization,
) {
  final entries = localization.contents.entries
      .map((entry) => '\t"${entry.key}": "${entry.value}"')
      .join(",\n");

  return WritableLocalization(localization.language, "{\n$entries\n}");
}

Future<File> writeLocalization(
  WritableLocalization localization,
) =>
    File(_localizationPath(localization.language))
        .writeAsString(localization.fileContents);

Future<dynamic> localize() => readEnglishLocalizations()
    .pipe(extractLocalizations)
    .pipe(translateAll)
    .map(formatLocalization)
    .forEach(writeLocalization);
