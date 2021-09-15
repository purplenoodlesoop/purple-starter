extension AExtensions<A extends Object?> on A {
  B pipe<B>(B Function(A a) f) => f(this);
  bool get isNull => this == null;
  bool get isNotNull => this != null;
}
