class Node<T> {
  final T value;
  Node? left;
  Node? right;

  Node(this.value, {this.left, this.right});

  void addChild(Node child) {
    if (left == null) {
      left = child;
    } else if (right == null) {
      right = child;
    } else {
      throw Exception('Node already has two children');
    }
  }

  List<Node> getChildren() {
    List<Node> children = [];
    if (left != null) children.add(left!);
    if (right != null) children.add(right!);
    return children;
  }

  bool hasChildren() => left != null && right != null;

  bool isLeaf() => left == null && right == null;

  // Node is operator if is of type Char and contains: +, -, *, /, &&, ||, !, == >=, <=, >, <,
  bool isOperator() =>
      value is String &&
      const ['+', '-', '*', '/', '&&', '||', '!', '==', '>=', '<=', '>', '<']
          .contains(value);

  // is numeric or boolean or 'variable'
  bool isOperand() =>
      value is num || value is bool || (value is String && !isOperator());

  // To Dart interpretable string
  String toDart() {
    return 'Node($value)';
  }
}
