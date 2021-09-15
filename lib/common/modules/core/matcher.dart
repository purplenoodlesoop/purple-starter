mixin Matcher {
  static T _throw<T>(String text) => throw Exception(text);

  static B match<A, B>(
    A value, {
    required Map<A, B> to,
    B? orElse,
  }) =>
      to[value] ??
      (orElse ??
          _throw(
            'Non-exhaustive matching on types $A $B '
            'without orElse argument',
          ));

  static T matchBool<T>({
    required Map<bool, T> to,
    T? orElse,
  }) =>
      match(true, to: to, orElse: orElse);
}
