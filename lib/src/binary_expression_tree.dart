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

  BinaryExpressionTree zip(Node binaryOperator, BinaryExpressionTree tree) {
    BinaryExpressionTree thisTree = copy();
    BinaryExpressionTree otherTree = tree.copy();
    BinaryExpressionTree zipTree = BinaryExpressionTree();
    zipTree.root = binaryOperator;
    zipTree.root!.left = thisTree.root;
    zipTree.root!.right = otherTree.root;
    return zipTree;
  }
}
