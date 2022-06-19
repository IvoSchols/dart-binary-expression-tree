import 'dart:ffi';

class Node<T> {
  final T value;
  Node? left;
  Node? right;

  Node(this.value);

  bool isLeaf() => left == null && right == null;

  // Node is operator if is of type Char and contains: +, -, *, /, &&, ||
  bool isOperator() =>
      value is String &&
      (value == '+' ||
          value == '-' ||
          value == '*' ||
          value == '/' ||
          value == '&&' ||
          value == '||');

  // is numeric or boolean or 'variable'
  bool isOperand() =>
      value is num || value is bool || (value is String && !isOperator());
}
