import 'package:test/test.dart';

import '../bin/peg_solitaire.dart' as main_file;

void main() {
  test('From 4.3. sample test case 1 (w/ "O" value).', () {
    // Arrange.
    const input = [
      'xx...xx',
      'xxo..xx',
      '..o....',
      '..oO...',
      '.......',
      'xx...xx',
      'xx...xx',
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('YES'));
  });

  test('From 4.3. sample test case 2 (w/ "E" value).', () {
    // Arrange.
    const input = [
      '...xE.o',
      '...oo..',
      '...oo..',
      '.......',
      '.......',
      '.......',
      '.......',
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('YES'));
  });

  test('From 4.3. Modified test code 1 (w/ "O" value).', () {
    // Arrange.
    const input = [
      'xx...xx',
      'xxo..xx',
      '..O....',
      '..oo...',
      '.......',
      'xx...xx',
      'xx...xx',
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('NO'));
  });
  test('From 4.3. Modified test code 2 (w/ "E" value).', () {
    // Arrange.
    const input = [
      'xx...xx',
      'xxo..xx',
      '..o....',
      '..oo...',
      '.......',
      'xx.E.xx',
      'xx...xx',
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('NO'));
  });

  test('From 4.1. modified test case 1 (w/ "E" value).', () {
    // Arrange.
    const input = [
      'xx...xx',
      'xxo..xx',
      '..o....',
      'E.oo...',
      '.......',
      'xx...xx',
      'xx...xx',
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('YES'));
  });

  test('When there is only one E-value.', () {
    // Arrange.
    const input = [
      '.......',
      '.......',
      '.......',
      '...E...',
      '.......',
      '.......',
      '.......',
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('NO'));
  });

  test('When there is only one O-value.', () {
    // Arrange.
    const input = [
      '.......',
      '.......',
      '.......',
      '.......',
      '.......',
      '.......',
      '.....O.',
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('YES'));
  });

  test('When no pegs can be moved and the board is not solved.', () {
    // Arrange.
    const input = [
      'xx...xx',
      'xx...xx',
      '...o...',
      '...E...',
      '...o...',
      'xx...xx',
      'xx...xx',
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('NO'));
  });

  test('When pegs can be moved but no sequence leads to a solved board.', () {
    // Arrange.
    const input = [
      'xx...xx',
      'xx...xx',
      '..Oo...',
      '..o....',
      '.......',
      'xx...xx',
      'xx...xx',
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('NO'));
  });

  test(
    'Tests for movement overflow which might happen if only one index is used '
    'to access tiles. (board[3][3] VS board[24])',
    () {
      // Arrange.
      const input = [
        'xx...xx',
        'xx...xx',
        '......o',
        'O......',
        '.......',
        'xx...xx',
        'xx...xx',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('NO'));
    },
  );

  test(
    'Test case for boards with different `x` placement.',
    () {
      // Arrange.
      const input = [
        'Oo...xx',
        'o.o..xx',
        '.o...xx',
        '.....xx',
        'xxxxxxx',
        'xxxxxxx',
        'xxxxxxx',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('YES'));
    },
  );

  test(
    'Test case for board made unsolvable due to an `x`. ',
    () {
      // Arrange.
      const input = [
        '.......',
        '.x.....',
        '.o...E.',
        '..oo...',
        'xx.....',
        '.......',
        '.......',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('NO'));
    },
  );

  test(
    'Test case for 5 pegs.',
    () {
      // Arrange.
      const input = [
        ' xx...xx',
        'xxo..xx',
        '..o....',
        '....E..',
        '..o.o..',
        'xx.o.xx',
        'xx...xx',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('YES'));
    },
  );

  test(
    'Test case for 6 pegs.',
    () {
      // Arrange.
      const input = [
        'xx...xx',
        'xx...xx',
        '....o..',
        '.....oo',
        '..E....',
        'xxo.oxx',
        'xx.o.xx',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('YES'));
    },
  );

  test(
    'Test case for 7 pegs.',
    () {
      // Arrange.
      const input = [
        'xx.o.xx',
        'xxO.oxx',
        '..oo...',
        '...oo..',
        '.......',
        'xx...xx',
        'xx...xx',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('YES'));
    },
  );

  test(
    'Test case for 7 pegs. (1)',
    () {
      // Arrange.
      const input = [
        'xx.o.xx',
        'xxo.oxx',
        '..oo...',
        '...oo..',
        '..E....',
        'xx...xx',
        'xx...xx',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('YES'));
    },
  );

  test(
    'Test case for 7 pegs. (2)',
    () {
      // Arrange.
      const input = [
        'xx.o.xx',
        'xxo.oxx',
        '..oo...',
        '...oo..',
        '.....E.',
        'xx...xx',
        'xx...xx',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('YES'));
    },
  );

  test(
    'Test case for 8 pegs.',
    () {
      // Arrange.
      const input = [
        'xx.o.xx',
        'xxooOxx',
        '..oo...',
        '...oo..',
        '.......',
        'xx...xx',
        'xx...xx',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('YES'));
    },
  );

  test(
    'Test case for 8 pegs. (1)',
    () {
      // Arrange.
      const input = [
        'xx.o.xx',
        'xxoooxx',
        '..ooE..',
        '...oo..',
        '.......',
        'xx...xx',
        'xx...xx',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('NO'));
    },
  );

  test(
    'Test case for 8 pegs. (2)',
    () {
      // Arrange.
      const input = [
        '.......',
        'xx...xx',
        'xx...xx',
        'xx.o.xx',
        'xxoooxx',
        '..ooE..',
        '...oo..',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('NO'));
    },
  );

  test(
    'Test case for 8 pegs. (3)',
    () {
      // Arrange.
      const input = [
        '.......',
        '.......',
        '...o...',
        '..ooo..',
        '..ooE..',
        '...oo..',
        '.......',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('NO'));
    },
  );

  test(
    'Test case for 8 pegs. (4)',
    () {
      // Arrange.
      const input = [
        '.......',
        '.......',
        '.......',
        '...o...',
        '..ooo..',
        '..ooE..',
        '...oo..',
      ];

      // Act.
      final List<String> output = main_file.main(input);

      // Assert.
      expect(output[0], equals('NO'));
    },
  );

  test('Other sample test case 1.', () {
    // Arrange.
    const input = [
      '...xx.x',
      '...xE.o',
      '...oo..',
      'x..oo..',
      '..xxx..',
      '...x...',
      'o..x...',
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('NO'));
  });

  test('Other sample test case 2.', () {
    // Arrange.
    const input = [
      'xx...xx',
      'xx...xx',
      '...oo..',
      '..o.o..',
      '..o.o..',
      'xx..Exx',
      'xx...xx'
    ];

    // Act.
    final List<String> output = main_file.main(input);

    // Assert.
    expect(output[0], equals('YES'));
  });
}
