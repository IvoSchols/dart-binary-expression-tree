import 'package:binary_expression_tree/binary_expression_tree.dart';
import 'package:test/test.dart';

void main() {
  test('emptyFromPostfix', () {
    expect(
        () => BinaryExpressionTree.fromPostfix([]), throwsA(isA<Exception>()));
  });

  test('invalidFromPostfixSimple', () {
    expect(() => BinaryExpressionTree.fromPostfix([null]),
        throwsA(isA<Exception>()));
  });

  test('invalidFromPostfixSimple', () {
    expect(() => BinaryExpressionTree.fromPostfix([null]),
        throwsA(isA<Exception>()));
  });

  test('invalidFromPostfixOperatorCount', () {
    expect(() => BinaryExpressionTree.fromPostfix(["+", 1]),
        throwsA(isA<Exception>()));
  });

  test('fromPostfixNotationListSimple', () {
    BinaryExpressionTree tree = BinaryExpressionTree.fromPostfix([1, 2, '+']);
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

  test('toPostfixNotationListSimple', () {
    BinaryExpressionTree tree = BinaryExpressionTree.fromPostfix([1, 2, '+']);
    expect(tree.toPostFix(), [1, 2, '+']);
  });

  test('fromPostfixNotationListComplex', () {
    BinaryExpressionTree tree = BinaryExpressionTree.fromPostfix(
        ['a', 'b', 'c', '*', '+', 'd', 'e', 'f', '+', '*', '+']);

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

  test('toPostfixNotationComplex', () {
    final postfixNotation = [
      'a',
      'b',
      'c',
      '*',
      '+',
      'd',
      'e',
      'f',
      '+',
      '*',
      '+'
    ];
    BinaryExpressionTree tree =
        BinaryExpressionTree.fromPostfix(postfixNotation);
    expect(tree.toPostFix(), postfixNotation);
  });

  test('toPostfixWithNegation', () {
    List<String> postfixNotation = ['a', 'b', '+', 'b', 'a', '!', '*', '-'];
    BinaryExpressionTree tree =
        BinaryExpressionTree.fromPostfix(postfixNotation);

    expect(tree.root!.value, equals('-'));
    expect(tree.root!.left!.value, equals('+'));
    expect(tree.root!.right!.value, equals('*'));
    expect(tree.root!.left!.left!.value, equals('a'));
    expect(tree.root!.left!.right!.value, equals('b'));
    expect(tree.root!.right!.left!.value, equals('b'));
    expect(tree.root!.right!.right!.value, equals('!'));
    expect(tree.root!.right!.right!.left!.value, equals('a'));

    expect(tree.toPostFix(), postfixNotation);
  });
}
