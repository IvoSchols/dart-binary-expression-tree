import 'dart:collection';

import 'node.dart';

class BinaryExpressionTree {
  Node? root;

  BinaryExpressionTree({this.root});

  // Construct an expression tree from a prefix notation list.
  BinaryExpressionTree.fromPrefix(List<dynamic> prefix) {
    if (prefix.isEmpty) {
      throw Exception('Prefix notation list is empty.');
    }

    Iterator<dynamic> iterator = prefix.iterator;
    Node? prefixNode = _fromPrefix(prefix, iterator);

    if (prefixNode == null) {
      throw Exception('Invalid prefix notation');
    }

    root = prefixNode;
  }

  Node? _fromPrefix(List<dynamic> prefix, Iterator<dynamic> iterator) {
    if (!iterator.moveNext()) {
      return null;
    }

    Node? current = Node(iterator.current);

    if (!current.isOperand() && !current.isOperator()) {
      throw Exception('Invalid prefix notation');
    }

    if (current.isOperator()) {
      current.left = _fromPrefix(prefix, iterator);
      if (current.value != "!") current.right = _fromPrefix(prefix, iterator);
    }

    return current;
  }

  // Convert the expression tree to a prefix notation list.
  List<dynamic> toPreFix() {
    List<dynamic> prefix = [];

    callFunctionPreOrder(root, (Node node) => prefix.add(node.value));
    return prefix;
  }

  void callFunctionPreOrder(Node? node, Function function) {
    if (node == null) return;

    function(node);
    callFunctionPreOrder(node.left, function);
    callFunctionPreOrder(node.right, function);
  }

  // Construct an expression tree from a postfix notation list.
  BinaryExpressionTree.fromPostfix(List<dynamic> postfix) {
    if (postfix.isEmpty) {
      throw Exception('Postfix notation list is empty.');
    }

    ListQueue<Node> listQueue = ListQueue();

    Node? postfixNode = _fromPostfix(postfix, listQueue);

    if (postfixNode == null) {
      throw Exception('Invalid postfix notation');
    }
    root = postfixNode;
  }

  Node? _fromPostfix(List<dynamic> postfix, ListQueue<Node> listQueue) {
    for (int i = 0; i < postfix.length; i++) {
      Node current = Node(postfix[i]);

      if (!current.isOperator() && !current.isOperand()) {
        throw Exception('Invalid postfix notation');
      }

      if (current.isOperand()) {
        listQueue.add(current);
      } else if (current.isOperator()) {
        if (listQueue.length < 2) {
          throw Exception('Invalid postfix notation');
        }
        if (current.value != "!") current.right = listQueue.removeLast();
        current.left = listQueue.removeLast();
        listQueue.add(current);
      }
    }

    if (listQueue.length != 1) {
      throw Exception('Invalid postfix notation');
    }

    return listQueue.removeLast();
  }

  // Convert the expression tree to a postfix notation list.
  List<dynamic> toPostFix() {
    List<dynamic> postfix = [];

    callFunctionPostOrder(root, (Node node) => postfix.add(node.value));
    return postfix;
  }

  void callFunctionPostOrder(Node? node, Function function) {
    if (node == null) return;

    callFunctionPostOrder(node.left, function);
    callFunctionPostOrder(node.right, function);
    function(node);
  }

  /// Deep copy of the expression tree.
  BinaryExpressionTree copy() {
    BinaryExpressionTree copyTree = BinaryExpressionTree();
    copyTree.root = _copy(root);
    return copyTree;
  }

  Node? _copy(Node? node) {
    if (node == null) return null;

    Node? copyNode = Node(node.value);
    copyNode.left = _copy(node.left);
    copyNode.right = _copy(node.right);
    return copyNode;
  }

  /// Zip the expression tree with another expression tree using the given operator and return a new expression tree.
  BinaryExpressionTree zip(BinaryExpressionTree tree, Node binaryOperator) {
    BinaryExpressionTree thisTree = copy();
    BinaryExpressionTree otherTree = tree.copy();
    BinaryExpressionTree zipTree = BinaryExpressionTree();
    zipTree.root = binaryOperator;
    zipTree.root!.left = thisTree.root;
    zipTree.root!.right = otherTree.root;
    return zipTree;
  }

  negate() {
    if (root?.value == '!') {
      root = root!.left;
    } else {
      Node negation = Node('!');
      negation.left = root;
      root = negation;
    }
  }

  //Invert the condition tree operators
  BinaryExpressionTree invertedTree() {
    BinaryExpressionTree invertedTree = BinaryExpressionTree();

    // Perform a breadth first search on the tree, and invert the operators
    // and add the inverted nodes to the inverted tree.
    Queue<Node> queue = Queue();
    queue.add(root!);
    while (queue.isNotEmpty) {
      Node node = queue.removeFirst();

      if (node.value == '&&' || node.value == '||') {
        Node invertedNode = Node(node.value);
        if (invertedNode.value == '&&') {
          invertedNode.value = '||';
          Node temp = node.left!;
          invertedNode.left = Node('!');
          invertedNode.left!.left = temp;
          temp = node.right!;
          invertedNode.right = Node('!');
          invertedNode.right!.left = temp;
        } else if (invertedNode.value == '||') {
          invertedNode.value = '&&';
          Node temp = node.left!;
          invertedNode.left = Node('!');
          invertedNode.left!.left = temp;
          temp = node.right!;
          invertedNode.right = Node('!');
          invertedNode.right!.left = temp;
        }
        invertedTree.root = invertedNode;
      } else if (node.isOperator()) {
        Node invertedNode = Node(node.value);

        // Invert the operator.
        if (invertedNode.value == '!') {
          invertedNode = node.left!;
          invertedTree.root = invertedNode;
          continue;
        } else if (invertedNode.value == '>=') {
          invertedNode.value = '<';
        } else if (invertedNode.value == '<=') {
          invertedNode.value = '>';
        } else if (invertedNode.value == '<') {
          invertedNode.value = '>=';
        } else if (invertedNode.value == '>') {
          invertedNode.value = '<=';
        } else if (invertedNode.value == '==') {
          invertedNode.value = '!=';
        } else if (invertedNode.value == '!=') {
          invertedNode.value = '==';
        } else {
          throw Exception('Invalid operator');
        }
        invertedNode.left = node.left;
        invertedNode.right = node.right;
        queue.add(invertedNode.left!);
        if (invertedNode.value != '!') queue.add(invertedNode.right!);
        invertedTree.root = invertedNode;
      }
    }
    return invertedTree;
  }
}
