class ParsingException<From, To> implements Exception {
  final From from;

  ParsingException(this.from);

  @override
  String toString() => '$this ocurred when parsing from $from';
}
