import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:test/test.dart';

void main() {
  // Test single node binary tree
  test('singleNodeTree', () {
    Node root = Node(null);
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    expect(tree.root, equals(root));
    expect(tree.root!.left, equals(null));
    expect(tree.root!.right, equals(null));
  });

  // Test binary tree with a root and a single leaf node.
  test('singleLeafNodeTree', () {
    Node root = Node(null);
    Node leaf = Node(1);
    root.left = leaf;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    expect(tree.root, equals(root));
    expect(tree.root!.left, equals(leaf));
    expect(tree.root!.right, equals(null));
    expect(tree.root!.left!.isLeaf(), isTrue);
  });

  test('isOperand', () {
    Node root = Node(null);
    Node leaf = Node(1);
    root.left = leaf;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    expect(tree.root!.left!.isOperand(), isTrue);
  });

  test('isOperator', () {
    Node root = Node(null);
    Node leaf = Node('+');
    root.left = leaf;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    expect(tree.root!.left!.isOperator(), isTrue);
  });

  test('isLeaf', () {
    Node root = Node(null);
    Node leaf = Node(1);
    root.left = leaf;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    expect(tree.root!.isLeaf(), isFalse);
    expect(tree.root!.left!.isLeaf(), isTrue);
  });

  test('zip', () {
    Node root = Node('+');
    Node zero = Node(0);
    Node one = Node(1);
    root.left = zero;
    root.right = one;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    Node root2 = Node('||');
    Node a = Node('a');
    Node b = Node('b');
    root2.left = a;
    root2.right = b;
    BinaryExpressionTree tree2 = BinaryExpressionTree(root: root2);
    Node operator = Node('&&');
    BinaryExpressionTree zippedTree = tree.zip(tree2, operator);

    expect(zippedTree.root!.value, equals('&&'));
    expect(zippedTree.root!.left!.value, equals('+'));
    expect(zippedTree.root!.right!.value, equals('||'));
    expect(zippedTree.root!.left!.left!.value, equals(0));
    expect(zippedTree.root!.left!.right!.value, equals(1));
    expect(zippedTree.root!.right!.left!.value, equals('a'));
    expect(zippedTree.root!.right!.right!.value, equals('b'));
  });

  test('negate', () {
    Node root = Node('&&');
    Node zero = Node(0);
    Node one = Node(1);
    root.left = zero;
    root.right = one;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    tree.negate();
    expect(tree.root!.value, equals('!'));
    expect(tree.root!.left!.value, equals('&&'));
    expect(tree.root!.left!.left!.value, equals(0));
    expect(tree.root!.left!.right!.value, equals(1));
    tree.negate();
    expect(tree.root!.value, equals('&&'));
    expect(tree.root!.left!.value, equals(0));
    expect(tree.root!.right!.value, equals(1));
  });

  test('invertedTreeAnd', () {
    Node root = Node('&&');
    Node zero = Node(0);
    Node one = Node(1);
    root.left = zero;
    root.right = one;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    BinaryExpressionTree invertedTree = tree.invertedTree();
    expect(invertedTree.root!.value, equals('||'));

    expect(invertedTree.root!.left!.value, equals('!'));
    expect(invertedTree.root!.right!.value, equals('!'));

    expect(invertedTree.root!.left!.left!.value, equals(0));
    expect(invertedTree.root!.left!.right, isNull);

    expect(invertedTree.root!.right!.left!.value, equals(1));
    expect(invertedTree.root!.right!.right, isNull);

    expect(invertedTree.root!.left!.left!.left, isNull);
    expect(invertedTree.root!.left!.left!.right, isNull);

    expect(invertedTree.root!.right!.left!.left, isNull);
    expect(invertedTree.root!.right!.left!.right, isNull);
  });

  test('invertedTreeInequality', () {
    Node root = Node('>');
    Node zero = Node(0);
    Node one = Node(1);
    root.left = zero;
    root.right = one;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    BinaryExpressionTree invertedTree = tree.invertedTree();
    expect(invertedTree.root!.value, equals('<='));
    expect(invertedTree.root!.left!.value, equals(0));
    expect(invertedTree.root!.right!.value, equals(1));
    expect(invertedTree.root!.left!.left, isNull);
    expect(invertedTree.root!.left!.right, isNull);
    expect(invertedTree.root!.right!.left, isNull);
    expect(invertedTree.root!.right!.right, isNull);
  });

  test('invertedTreeEquality', () {
    Node root = Node('==');
    Node zero = Node(0);
    Node one = Node(1);
    root.left = zero;
    root.right = one;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    BinaryExpressionTree invertedTree = tree.invertedTree();
    expect(invertedTree.root!.value, equals('!='));
    expect(invertedTree.root!.left!.value, equals(0));
    expect(invertedTree.root!.right!.value, equals(1));
  });

  test('invertedTreeOr', () {
    Node root = Node('||');
    Node zero = Node(0);
    Node one = Node(1);
    root.left = zero;
    root.right = one;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    BinaryExpressionTree invertedTree = tree.invertedTree();
    expect(invertedTree.root!.value, equals('&&'));
    expect(invertedTree.root!.left!.value, equals('!'));
    expect(invertedTree.root!.right!.value, equals('!'));
    expect(invertedTree.root!.left!.left!.value, equals(0));
    expect(invertedTree.root!.left!.right, isNull);

    expect(invertedTree.root!.right!.left!.value, equals(1));
    expect(invertedTree.root!.right!.right, isNull);

    expect(invertedTree.root!.left!.left!.left, isNull);
    expect(invertedTree.root!.left!.left!.right, isNull);

    expect(invertedTree.root!.right!.left!.left, isNull);
    expect(invertedTree.root!.right!.left!.right, isNull);
  });

  test('invertedTreeNot', () {
    Node root = Node('!');
    Node zero = Node(0);
    root.left = zero;
    BinaryExpressionTree tree = BinaryExpressionTree(root: root);
    BinaryExpressionTree invertedTree = tree.invertedTree();
    expect(invertedTree.root!.value, equals(0));
    expect(invertedTree.root!.left?.value, equals(null));
    expect(invertedTree.root!.right?.value, equals(null));
  });

  test('simpleDeepCopy', () {
    Node root = Node('&&');
    Node zero = Node(0);
    Node one = Node(1);
    root.left = zero;
    root.right = one;
    Node copy = root.deepCopy();
    expect(root.hashCode, isNot(equals(copy.hashCode)));
    expect(copy.value, equals('&&'));
    expect(copy.left!.value, equals(0));
    expect(root.left!.hashCode, isNot(equals(copy.left!.hashCode)));
    expect(copy.right!.value, equals(1));
    expect(root.right!.hashCode, isNot(equals(copy.right!.hashCode)));
    expect(copy.left!.left, isNull);
    expect(copy.left!.right, isNull);
    expect(copy.right!.left, isNull);
    expect(copy.right!.right, isNull);
  });
}
