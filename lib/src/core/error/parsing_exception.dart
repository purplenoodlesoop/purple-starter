class ParsingException<From, To> implements Exception {
  final From from;

  ParsingException(this.from);

  @override
  String toString() => '$runtimeType ocurred when parsing from $from';
}
