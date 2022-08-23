import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:test/test.dart';

void main() {
  //TODO: add tests

  // Test single node binary tree
  test('singleNodeTree', () {
    Node root = Node(null);
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    expect(tree.root, equals(root));
    expect(tree.root.left, equals(null));
    expect(tree.root.right, equals(null));
  });

  // Test binary tree with a root and a single leaf node.
  test('singleLeafNodeTree', () {
    Node root = Node(null);
    Node leaf = Node(1);
    root.left = leaf;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    expect(tree.root, equals(root));
    expect(tree.root.left, equals(leaf));
    expect(tree.root.right, equals(null));
    expect(tree.root.left!.isLeaf(), isTrue);
  });
}
