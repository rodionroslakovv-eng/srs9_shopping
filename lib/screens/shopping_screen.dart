import 'package:flutter/material.dart';

import '../logic/cart_logic.dart';
import 'summary_screen.dart';

/// Главный экран: ввод товара, список покупок и итоговая сумма.
class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _qty = TextEditingController(text: '1');
  final _items = <Product>[];
  static const _calc = CartCalculator();

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _qty.dispose();
    super.dispose();
  }

  void _add() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _items.add(Product(
        name: _name.text.trim(),
        price: InputValidator.parsePrice(_price.text)!,
        quantity: int.parse(_qty.text.trim()),
      ));
      _name.clear();
      _price.clear();
      _qty.text = '1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Список покупок')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('nameField'),
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Название'),
                    validator: InputValidator.validateName,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: const Key('priceField'),
                          controller: _price,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Цена, ₽'),
                          validator: InputValidator.validatePrice,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          key: const Key('qtyField'),
                          controller: _qty,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Кол-во'),
                          validator: InputValidator.validateQuantity,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        key: const Key('addButton'),
                        onPressed: _add,
                        child: const Text('Добавить'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        key: const Key('clearButton'),
                        onPressed: _items.isEmpty
                            ? null
                            : () => setState(_items.clear),
                        child: const Text('Очистить'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('Список пуст'))
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, i) {
                      final p = _items[i];
                      return ListTile(
                        title: Text(p.name),
                        subtitle: Text('${p.quantity} × ${p.price.toStringAsFixed(2)} ₽'),
                        trailing: Text('${p.total.toStringAsFixed(2)} ₽'),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Итого: ${_calc.total(_items).toStringAsFixed(2)} ₽',
                  key: const Key('totalText'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                FilledButton(
                  key: const Key('summaryButton'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SummaryScreen(items: List.of(_items))),
                  ),
                  child: const Text('Сводка'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
