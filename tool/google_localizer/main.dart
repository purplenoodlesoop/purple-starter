import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pure/pure.dart';
import 'package:translator/translator.dart';

const languages = [
  'pt',
  'es',
  'it',
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

  // ignore: avoid-non-null-assertion
  static Environment get current => (Zone.current[_key] as Environment?)!;

  static T run<T>({
    required Environment environment,
    required T Function() body,
  }) =>
      runZoned(
        body,
        zoneValues: {_key: environment},
      );
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
    '${Environment.current.localizationFolder}/app_$language.arb';

Arb readEnglishLocalizations() =>
    File(_localizationPath('en')).readAsStringSync().pipe<dynamic>(jsonDecode)
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

extension on StringBuffer {
  void writeEntry(TranslationEntry entry) {
    write('\t"');
    write(entry.key);
    write('": "');
    write(entry.value);
    write('"');
  }
}

WritableLocalization formatLocalization(
  Localization localization,
) {
  final buffer = StringBuffer('{\n');
  final iterator = localization.contents.entries.iterator..moveNext();

  buffer.writeEntry(iterator.current);
  while (iterator.moveNext()) {
    buffer
      ..writeln(',')
      ..writeEntry(iterator.current);
  }

  buffer.write('\n}');

  return WritableLocalization(localization.language, buffer.toString());
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
