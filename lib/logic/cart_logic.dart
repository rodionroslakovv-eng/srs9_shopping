/// Позиция в списке покупок.
class Product {
  const Product({required this.name, required this.price, this.quantity = 1});

  final String name;
  final double price;
  final int quantity;

  double get total => price * quantity;
}

/// Вычисления над списком покупок (то, что проверяют Unit Test).
class CartCalculator {
  const CartCalculator();

  /// Общая стоимость всех позиций.
  double total(List<Product> items) =>
      items.fold(0.0, (sum, p) => sum + p.total);

  /// Общее количество единиц товара.
  int itemCount(List<Product> items) =>
      items.fold(0, (sum, p) => sum + p.quantity);

  /// Стоимость со скидкой [percent] (0..100).
  double applyDiscount(double amount, int percent) {
    if (percent < 0 || percent > 100) {
      throw ArgumentError('Скидка должна быть от 0 до 100%');
    }
    return amount * (100 - percent) / 100;
  }

  /// Самая дорогая позиция (по сумме) или null, если список пуст.
  Product? mostExpensive(List<Product> items) {
    if (items.isEmpty) return null;
    return items.reduce((a, b) => a.total >= b.total ? a : b);
  }
}

/// Проверка введённых пользователем данных.
class InputValidator {
  const InputValidator._();

  static String? validateName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Введите название';
    if (v.length > 50) return 'Слишком длинное название';
    return null;
  }

  /// Принимает и точку, и запятую: «12.5» и «12,5».
  static double? parsePrice(String? value) =>
      double.tryParse((value ?? '').trim().replaceAll(',', '.'));

  static String? validatePrice(String? value) {
    final price = parsePrice(value);
    if (price == null) return 'Введите число';
    if (price <= 0) return 'Цена должна быть больше нуля';
    return null;
  }

  static String? validateQuantity(String? value) {
    final q = int.tryParse((value ?? '').trim());
    if (q == null) return 'Введите целое число';
    if (q < 1 || q > 999) return 'От 1 до 999';
    return null;
  }
}
