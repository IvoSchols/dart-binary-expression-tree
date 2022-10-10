class Node<T> {
  T value;
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

  // Node is operator if is of type Char and contains: +, -, *, /, &&, ||, !, ==, !=, >=, <=, >, <,
  bool isOperator() =>
      value is String &&
      const [
        '+',
        '-',
        '*',
        '/',
        '&&',
        '||',
        '!',
        '==',
        '!=',
        '>=',
        '<=',
        '>',
        '<'
      ].contains(value);

  // is numeric or boolean or 'variable'
  bool isOperand() =>
      value is num || value is bool || (value is String && !isOperator());

  /// Invert the operator of the node
  void invertOperator() {
    if (value == '&&') {
      value = '||' as T;
      Node temp = left!;
      left = Node('!');
      left!.left = temp;
      temp = right!;
      right = Node('!');
      right!.left = temp;
    } else if (value == '||') {
      value = '&&' as T;
      Node temp = left!;
      left = Node('!');
      left!.left = temp;
      temp = right!;
      right = Node('!');
      right!.left = temp;
    } else if (value == '==') {
      value = '!=' as T;
    } else if (value == '!=') {
      value = '==' as T;
    } else if (value == '>') {
      value = '<=' as T;
    } else if (value == '<') {
      value = '>=' as T;
    } else if (value == '>=') {
      value = '<' as T;
    } else if (value == '<=') {
      value = '>' as T;
    } else if (value == '!' && left != null) {
      value = left!.value;
      left = left!.left;
      right = left?.right;
    } else {
      throw Exception('Invalid operator');
    }
  }

  // To Dart interpretable string
  String toDart() {
    if (value is String) return "Node('$value');";
    return 'Node($value);';
  }

  // Deep copy of the node and its children
  Node deepCopy() {
    Node copy = Node(value);
    if (left != null) copy.left = left!.deepCopy();
    if (right != null) copy.right = right!.deepCopy();
    return copy;
  }
}
