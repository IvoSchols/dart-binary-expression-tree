import 'dart:collection';

import 'node.dart';

class BinaryExpressionTree {
  late Node root;

  BinaryExpressionTree();

  // Construct an expression tree from a postfix notation list.
  BinaryExpressionTree.fromPostfix(List<dynamic> postfix) {
    ListQueue<BinaryExpressionTree> listQueue = ListQueue();

    Node? postfixNode = _fromPostfix(postfix, listQueue);

    if (postfixNode == null) {
      throw Exception('Invalid postfix notation');
    }
    root = postfixNode;
  }

  Node? _fromPostfix(
      List<dynamic> postfix, ListQueue<BinaryExpressionTree> listQueue) {
    if (postfix.isEmpty) {
      return null;
    }

    for (int i = 0; i < postfix.length; i++) {
      Node current = Node(postfix[i]);

      if (!current.isOperator() && !current.isOperand()) {
        throw Exception('Invalid postfix notation');
      }

      if (current.isOperand()) {
        BinaryExpressionTree currentTree = BinaryExpressionTree();
        currentTree.root = current;
        listQueue.add(currentTree);
      } else if (current.isOperator()) {
        if (listQueue.length < 2) {
          throw Exception('Invalid postfix notation');
        }
        BinaryExpressionTree currentTree = BinaryExpressionTree();
        currentTree.root = current;
        current.right = listQueue.removeLast().root;
        current.left = listQueue.removeLast().root;
        listQueue.add(currentTree);
      }
    }

    if (listQueue.length != 1) {
      throw Exception('Invalid postfix notation');
    }

    return listQueue.removeLast().root;
  }

  // Convert the expression tree to a postfix notation list.
  List<dynamic> toPostFix() {
    List<dynamic> postfix = [];
    _toPostFix(root, postfix);
    return postfix;
  }

  void _toPostFix(Node? node, List<dynamic> postfix) {
    if (node == null) {
      return;
    }

    _toPostFix(node.left, postfix);
    _toPostFix(node.right, postfix);

    if (node.isOperand()) {
      postfix.add(node.value);
    } else {
      postfix.add(node.value);
    }
  }

  // Construct a expression tree from a prefix notation list.
  // The list must be a list of numbers or operators.
  // The list must be a valid prefix notation list.
  // BinaryExpressionTree.fromPrefix(List<dynamic> prefix) {
  //   if (prefix.isEmpty) {
  //     throw Exception('Prefix notation list is empty.');
  //   }

  //   if (prefix.length % 2 != 0) {
  //     throw Exception('Prefix notation list has an odd number of elements.');
  //   }
  // }

  // BinaryExpressionTree._fromPrefix(List<dynamic> prefix) {}
}
