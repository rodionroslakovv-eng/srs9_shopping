import 'package:flutter/material.dart';

import '../logic/cart_logic.dart';

/// Второй экран: сводка по покупкам со скидкой 10%.
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, required this.items});

  final List<Product> items;
  static const discountPercent = 10;

  @override
  Widget build(BuildContext context) {
    const calc = CartCalculator();
    final total = calc.total(items);
    final top = calc.mostExpensive(items);
    return Scaffold(
      appBar: AppBar(title: const Text('Сводка')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Позиций: ${items.length}', key: const Key('positions')),
            Text('Единиц товара: ${calc.itemCount(items)}'),
            Text('Сумма: ${total.toStringAsFixed(2)} ₽'),
            Text(
              'Со скидкой $discountPercent%: '
              '${calc.applyDiscount(total, discountPercent).toStringAsFixed(2)} ₽',
              key: const Key('discounted'),
            ),
            Text('Самая дорогая: ${top?.name ?? '—'}'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                key: const Key('backButton'),
                onPressed: () => Navigator.pop(context),
                child: const Text('Назад'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
