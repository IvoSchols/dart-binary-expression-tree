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
    _toPrefix(root, prefix);
    return prefix;
  }

  void _toPrefix(Node? node, List<dynamic> prefix) {
    if (node == null) return;

    prefix.add(node.value);
    _toPrefix(node.left, prefix);
    _toPrefix(node.right, prefix);
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
    _toPostFix(root, postfix);
    return postfix;
  }

  void _toPostFix(Node? node, List<dynamic> postfix) {
    if (node == null) return;

    _toPostFix(node.left, postfix);
    _toPostFix(node.right, postfix);
    postfix.add(node.value);
  }
}
