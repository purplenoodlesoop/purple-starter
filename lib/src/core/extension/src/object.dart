extension NullableObjectExtension<A extends Object?> on A {
  B? maybeCast<B>() {
    final self = this;

    return self is B ? self : null;
  }
}
