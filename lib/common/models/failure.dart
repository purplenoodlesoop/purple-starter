class Failure {
  final StackTrace stackTrace;
  final Object exception;

  Failure(this.stackTrace, this.exception);

  static Failure n(Object exception, StackTrace stackTrace) =>
      Failure(stackTrace, exception);
}
