typedef VoidUnaryFunction<A> = void Function(A a);

extension VoidUnaryFunctionX<A> on VoidUnaryFunction<A> {
  VoidUnaryFunction<A> amend(VoidUnaryFunction<A> other) {
    final thisSnapshot = this;

    return (a) {
      other(a);
      thisSnapshot(a);
    };
  }
}
