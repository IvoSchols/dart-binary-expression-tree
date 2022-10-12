import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:test/test.dart';

void main() {
  test('emptyFromPrefix', () {
    expect(
        () => BinaryExpressionTree.fromPrefix([]), throwsA(isA<Exception>()));
  });

  test('invalidFromPrefix', () {
    expect(() => BinaryExpressionTree.fromPrefix([null]),
        throwsA(isA<Exception>()));
  });

  test('fromPrefixNotationListSimple', () {
    BinaryExpressionTree tree = BinaryExpressionTree.fromPrefix(['+', 1, 2]);
    expect(tree.root!.value, '+');
    expect(tree.root!.isLeaf(), false);

    expect(tree.root!.left?.value, 1);
    expect(tree.root!.left?.isLeaf(), true);
    expect(tree.root!.left?.left, null);
    expect(tree.root!.left?.right, null);

    expect(tree.root!.right?.value, 2);
    expect(tree.root!.right?.isLeaf(), true);
    expect(tree.root!.right?.left, null);
    expect(tree.root!.right?.right, null);
  });

  test('toPrefixNotationListSimple', () {
    final prefixNotation = ['+', 1, 2];
    BinaryExpressionTree tree = BinaryExpressionTree.fromPrefix(prefixNotation);
    expect(tree.toPreFix(), prefixNotation);
  });

  test('fromPrefixNotationListComplex', () {
    BinaryExpressionTree tree = BinaryExpressionTree.fromPrefix(
        ['+', '+', 'a', '*', 'b', 'c', '*', 'd', '+', 'e', 'f']);

    expect(tree.root!.value, '+');
    expect(tree.root!.isLeaf(), false);

    expect(tree.root!.left?.value, '+');
    expect(tree.root!.left?.isLeaf(), false);

    expect(tree.root!.left?.left?.value, 'a');
    expect(tree.root!.left?.left?.isLeaf(), true);

    expect(tree.root!.left?.right?.value, '*');
    expect(tree.root!.left?.right?.isLeaf(), false);

    expect(tree.root!.left?.right?.left?.value, 'b');
    expect(tree.root!.left?.right?.left?.isLeaf(), true);

    expect(tree.root!.left?.right?.right?.value, 'c');
    expect(tree.root!.left?.right?.right?.isLeaf(), true);

    expect(tree.root!.right?.value, '*');
    expect(tree.root!.right?.isLeaf(), false);

    expect(tree.root!.right?.left?.value, 'd');
    expect(tree.root!.right?.left?.isLeaf(), true);

    expect(tree.root!.right?.right?.value, '+');
    expect(tree.root!.right?.right?.isLeaf(), false);

    expect(tree.root!.right?.right?.left?.value, 'e');
    expect(tree.root!.right?.right?.left?.isLeaf(), true);

    expect(tree.root!.right?.right?.right?.value, 'f');
    expect(tree.root!.right?.right?.right?.isLeaf(), true);
  });

  test('toPrefixNotationComplex', () {
    final prefixNotation = [
      '+',
      '+',
      'a',
      '*',
      'b',
      'c',
      '*',
      'd',
      '+',
      'e',
      'f'
    ];
    BinaryExpressionTree tree = BinaryExpressionTree.fromPrefix(prefixNotation);
    expect(tree.toPreFix(), prefixNotation);
  });

  test('toPrefixWithNegation', () {
    List<String> prefixNotation =
        ['-', '+', 'a', 'b', '*', 'b', '!', 'a'].toList();
    BinaryExpressionTree tree = BinaryExpressionTree.fromPrefix(prefixNotation);

    expect(tree.root!.value, equals('-'));
    expect(tree.root!.left!.value, equals('+'));
    expect(tree.root!.right!.value, equals('*'));
    expect(tree.root!.left!.left!.value, equals('a'));
    expect(tree.root!.left!.right!.value, equals('b'));
    expect(tree.root!.right!.left!.value, equals('b'));
    expect(tree.root!.right!.right!.value, equals('!'));
    expect(tree.root!.right!.right!.left!.value, equals('a'));

    expect(tree.toPreFix(), prefixNotation);
  });
}
