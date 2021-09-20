extension AExtensions<A extends Object?> on A {
  bool get isNull => this == null;
  bool get isNotNull => this != null;
}
