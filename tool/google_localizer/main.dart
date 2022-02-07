import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pure/pure.dart';
import 'package:translator/translator.dart';

const languages = [
  "ru",
  "pt",
  "es",
  "it",
];

void main(List<String> args) => Environment.run(
      environment: createEnvironment(args),
      body: localize,
    );

typedef Arb = Map<String, dynamic>;
typedef Language = String;
typedef TranslationContents = Map<String, String>;
typedef TranslationEntry = MapEntry<String, String>;

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
  final TranslationContents contents;

  const Localization(this.language, this.contents);
}

class WritableLocalization {
  final Language language;
  final String fileContents;

  WritableLocalization(this.language, this.fileContents);
}

Environment createEnvironment(List<String> args) => Environment(
      args.first,
      GoogleTranslator(),
    );

String _localizationPath(Language language) =>
    "${Environment.current.localizationFolder}/app_$language.arb";

Arb readEnglishLocalizations() =>
    File(_localizationPath("en")).readAsStringSync().pipe<dynamic>(jsonDecode)
        as Arb;

TranslationContents extractLocalizations(
  Arb arb,
) =>
    Map.fromEntries(
      arb.entries
          .where((element) => element.value is String)
          .map((e) => MapEntry(e.key, e.value.toString())),
    );

Future<TranslationEntry> _translateEntry(
  Language language,
  TranslationEntry englishEntry,
) async {
  final translation = await Environment.current.translator.translate(
    englishEntry.value,
    from: 'en',
    to: language,
  );

  return MapEntry(englishEntry.key, translation.text);
}

Future<Localization> _translateTo(
  TranslationContents englishContents,
  Language language,
) =>
    _translateEntry
        .apply(language)
        .pipe(englishContents.entries.map)
        .pipe(Future.wait)
        .then((translated) => Map.fromEntries(translated))
        .then((contents) => Localization(language, contents));

Stream<Localization> translateAll(
  TranslationContents englishContents,
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
