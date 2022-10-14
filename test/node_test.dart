import 'package:binary_expression_tree/src/node.dart';
import 'package:test/test.dart';

void main() {
  group('node', () {
    test('addChildEmpty', () {
      Node root = Node(null);
      Node leaf = Node(1);
      root.addChild(leaf);
      expect(root.left, equals(leaf));
      expect(root.right, equals(null));
    });

    test('addChildOne', () {
      Node root = Node(null);
      Node leaf = Node(1);
      root.addChild(leaf);
      Node leaf2 = Node(2);
      root.addChild(leaf2);
      expect(root.left, equals(leaf));
      expect(root.right, equals(leaf2));
    });

    test('addChildFull', () {
      Node root = Node(null);
      Node leaf = Node(1);
      root.addChild(leaf);
      Node leaf2 = Node(2);
      root.addChild(leaf2);
      Node leaf3 = Node(3);
      expect(root.left, equals(leaf));
      expect(root.right, equals(leaf2));
      expect(() => root.addChild(leaf3), throwsException);
    });

    test('getChildrenEmpty', () {
      Node root = Node(null);
      expect(root.getChildren(), isEmpty);
    });

    test('getChildrenOne', () {
      Node root = Node(null);
      Node leaf = Node(1);
      root.addChild(leaf);
      expect(root.getChildren(), equals([leaf]));
    });

    test('getChildrenFull', () {
      Node root = Node(null);
      Node leaf = Node(1);
      root.addChild(leaf);
      Node leaf2 = Node(2);
      root.addChild(leaf2);
      expect(root.getChildren(), equals([leaf, leaf2]));
    });

    test('hasChildrenEmpty', () {
      Node root = Node(null);
      expect(root.hasChildren(), isFalse);
    });

    test('hasChildrenOne', () {
      Node root = Node(null);
      Node leaf = Node(1);
      root.addChild(leaf);
      expect(root.hasChildren(), isFalse);
    });

    test('hasChildrenFull', () {
      Node root = Node(null);
      Node leaf = Node(1);
      root.addChild(leaf);
      Node leaf2 = Node(2);
      root.addChild(leaf2);
      expect(root.hasChildren(), isTrue);
    });

    test('isOperatorFalse', () {
      Node root = Node(null);
      Node leaf = Node('+');
      root.addChild(leaf);
      expect(root.isOperator(), isFalse);
      expect(root.getChildren()[0].isOperator(), isTrue);
    });

    test('isOperatorTrue', () {
      Node root = Node('+');
      Node leaf = Node(1);
      root.addChild(leaf);
      expect(root.isOperator(), isTrue);
      expect(root.getChildren()[0].isOperator(), isFalse);
    });

    test('isOperandFalse', () {
      Node root = Node(null);
      expect(root.isOperand(), isFalse);
    });

    test('isOperandTrue', () {
      Node root = Node(1);
      expect(root.isOperand(), isTrue);
    });

    test('invertUnsupportedOperator', () {
      Node root = Node(null);
      expect(() => root.invert(), throwsException);
    });

    test('invertInequality', () {
      String startingOperator = '>';
      Node root = Node(startingOperator);
      Node leaf = Node(1);
      root.addChild(leaf);
      root.invert();
      expect(root.value, equals('<='));
      expect(root.getChildren()[0].value, equals(1));
      root.invert();
      expect(root.value, equals('>'));
      expect(root.getChildren()[0].value, equals(1));
    });

    test('invertEqualityRegressionLess', () {
      Node less = Node('<');
      less.invert();
      expect(less.value, equals('>='));
    });

    test('invertEqualityRegressionGreaterEqual', () {
      Node greaterEqual = Node('>=');
      greaterEqual.invert();
      expect(greaterEqual.value, equals('<'));
    });

    test('invertEquality', () {
      String startingOperator = '==';
      Node root = Node(startingOperator);
      Node leaf = Node(1);
      root.addChild(leaf);
      root.invert();
      expect(root.value, equals('!='));
      expect(root.getChildren()[0].value, equals(1));
      root.invert();
      expect(root.value, equals('=='));
      expect(root.getChildren()[0].value, equals(1));
    });

    test('invertAnd', () {
      String startingOperator = '&&';
      Node root = Node(startingOperator);
      Node leaf = Node(1);
      Node leaf2 = Node(2);
      root.addChild(leaf);
      root.addChild(leaf2);
      root.invert();
      expect(root.value, equals('||'));
      expect(root.left!.value, equals('!'));
      expect(root.right!.value, equals('!'));
      expect(root.left!.left!.value, equals(1));
      expect(root.right!.left!.value, equals(2));
    });

    //The invert implementation can obviously be improved, seeing this case.
    test('invertAndOr', () {
      String startingOperator = '&&';
      Node root = Node(startingOperator);
      Node leaf = Node(1);
      Node leaf2 = Node(2);
      root.addChild(leaf);
      root.addChild(leaf2);
      root.invert();
      expect(root.value, equals('||'));
      expect(root.left!.value, equals('!'));
      expect(root.right!.value, equals('!'));
      expect(root.left!.left!.value, equals(1));
      expect(root.right!.left!.value, equals(2));
      root.invert();
      expect(root.value, equals('&&'));
      expect(root.left!.value, equals('!'));
      expect(root.left!.left!.value, equals('!'));
      expect(root.left!.left!.left!.value, equals(1));
      expect(root.left!.right, isNull);
      expect(root.left!.left!.right, isNull);

      expect(root.right!.value, equals('!'));
      expect(root.right!.left!.value, equals('!'));
      expect(root.right!.left!.left!.value, equals(2));
      expect(root.right!.right, isNull);
      expect(root.right!.left!.right, isNull);
    });

    test('invertOr', () {
      String startingOperator = '||';
      Node root = Node(startingOperator);
      Node leaf = Node(1);
      Node leaf2 = Node(2);
      root.addChild(leaf);
      root.addChild(leaf2);
      root.invert();
      expect(root.value, equals('&&'));
      expect(root.left!.value, equals('!'));
      expect(root.right!.value, equals('!'));
      expect(root.left!.left!.value, equals(1));
      expect(root.right!.left!.value, equals(2));
    });

    test('invertNot', () {
      Node root = Node('!');
      Node leaf = Node(1);
      root.addChild(leaf);
      root.invert();
      expect(root.value, equals(1));
    });

    test('invertNotNot', () {
      Node root = Node('!');
      Node leaf = Node('!');
      Node leaf2 = Node(1);
      root.addChild(leaf);
      leaf.addChild(leaf2);
      root.invert();
      expect(root.value, equals('!'));
      expect(root.left!.value, equals(1));
    });

    test('toDartNodeOperator', () {
      Node root = Node('&&');
      String result = root.toDart();
      expect(result, equals("Node('&&');"));
    });

    test('toDartNodeNumeric', () {
      Node root = Node(1);
      String result = root.toDart();
      expect(result, equals("Node(1);"));
    });
  });
}
