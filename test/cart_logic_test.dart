import 'package:flutter_test/flutter_test.dart';
import 'package:srs9_shopping/logic/cart_logic.dart';

void main() {
  group('CartCalculator (Unit Test)', () {
    const calc = CartCalculator();
    const items = [
      Product(name: 'Хлеб', price: 40, quantity: 2), // 80
      Product(name: 'Молоко', price: 90.5), // 90.5
      Product(name: 'Сыр', price: 300, quantity: 1), // 300
    ];

    test('общая стоимость списка', () {
      expect(calc.total(items), closeTo(470.5, 0.001));
    });

    test('стоимость пустого списка равна нулю', () {
      expect(calc.total([]), 0);
    });

    test('количество единиц товара', () {
      expect(calc.itemCount(items), 4);
    });

    test('скидка 10% и 0%', () {
      expect(calc.applyDiscount(200, 10), 180);
      expect(calc.applyDiscount(200, 0), 200);
      expect(calc.applyDiscount(200, 100), 0);
    });

    test('некорректная скидка вызывает ArgumentError', () {
      expect(() => calc.applyDiscount(100, -1), throwsArgumentError);
      expect(() => calc.applyDiscount(100, 101), throwsArgumentError);
    });

    test('самая дорогая позиция', () {
      expect(calc.mostExpensive(items)!.name, 'Сыр');
      expect(calc.mostExpensive([]), isNull);
    });
  });

  group('InputValidator: некорректные входные данные', () {
    test('название: пустое и слишком длинное', () {
      expect(InputValidator.validateName(''), isNotNull);
      expect(InputValidator.validateName('   '), isNotNull);
      expect(InputValidator.validateName(null), isNotNull);
      expect(InputValidator.validateName('a' * 51), isNotNull);
      expect(InputValidator.validateName('Яблоки'), isNull);
    });

    test('цена: текст, ноль, отрицательная, запятая', () {
      expect(InputValidator.validatePrice('abc'), isNotNull);
      expect(InputValidator.validatePrice(''), isNotNull);
      expect(InputValidator.validatePrice('0'), isNotNull);
      expect(InputValidator.validatePrice('-5'), isNotNull);
      expect(InputValidator.validatePrice('12,5'), isNull);
      expect(InputValidator.parsePrice('12,5'), 12.5);
    });

    test('количество: не число, 0 и больше 999', () {
      expect(InputValidator.validateQuantity('x'), isNotNull);
      expect(InputValidator.validateQuantity('1.5'), isNotNull);
      expect(InputValidator.validateQuantity('0'), isNotNull);
      expect(InputValidator.validateQuantity('1000'), isNotNull);
      expect(InputValidator.validateQuantity('3'), isNull);
    });
  });
}
