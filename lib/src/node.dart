class Node<T> {
  final T value;
  Node? left;
  Node? right;

  Node(this.value);

  bool isLeaf() => left == null && right == null;

  bool isOperator() =>
      value is String &&
      (value == '+' || value == '-' || value == '*' || value == '/');

  bool isOperand() => value is num || (value is String && !isOperator());
}
