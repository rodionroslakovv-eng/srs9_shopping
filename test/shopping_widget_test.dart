import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:srs9_shopping/main.dart';

Future<void> addItem(WidgetTester tester, String name, String price,
    [String qty = '1']) async {
  await tester.enterText(find.byKey(const Key('nameField')), name);
  await tester.enterText(find.byKey(const Key('priceField')), price);
  await tester.enterText(find.byKey(const Key('qtyField')), qty);
  await tester.tap(find.byKey(const Key('addButton')));
  await tester.pump();
}

void main() {
  testWidgets('главный экран: заголовок, поля, кнопки и пустой список', (tester) async {
    await tester.pumpWidget(const ShoppingApp());

    expect(find.text('Список покупок'), findsOneWidget); // заголовок
    expect(find.byKey(const Key('nameField')), findsOneWidget);
    expect(find.byKey(const Key('priceField')), findsOneWidget);
    expect(find.text('Добавить'), findsOneWidget); // кнопка
    expect(find.text('Список пуст'), findsOneWidget);
    expect(find.text('Итого: 0.00 ₽'), findsOneWidget);
    // «Очистить» неактивна, пока список пуст
    expect(
      tester.widget<OutlinedButton>(find.byKey(const Key('clearButton'))).onPressed,
      isNull,
    );
  });

  testWidgets('нажатие «Добавить» меняет интерфейс: позиция и итог', (tester) async {
    await tester.pumpWidget(const ShoppingApp());

    await addItem(tester, 'Хлеб', '40', '2');

    expect(find.text('Список пуст'), findsNothing);
    expect(find.text('Хлеб'), findsOneWidget);
    expect(find.text('80.00 ₽'), findsOneWidget);
    expect(find.text('Итого: 80.00 ₽'), findsOneWidget);
    // поля очистились
    expect(tester.widget<TextFormField>(find.byKey(const Key('nameField'))).controller!.text, '');
  });

  testWidgets('некорректный ввод показывает ошибки и ничего не добавляет', (tester) async {
    await tester.pumpWidget(const ShoppingApp());

    await addItem(tester, '', 'abc', '0');

    expect(find.text('Введите название'), findsOneWidget);
    expect(find.text('Введите число'), findsOneWidget);
    expect(find.text('От 1 до 999'), findsOneWidget);
    expect(find.text('Список пуст'), findsOneWidget);
    expect(find.text('Итого: 0.00 ₽'), findsOneWidget);
  });

  testWidgets('взаимодействие нескольких элементов: добавление, сумма, очистка', (tester) async {
    await tester.pumpWidget(const ShoppingApp());

    await addItem(tester, 'Молоко', '90,5');
    await addItem(tester, 'Сыр', '300');
    expect(find.text('Молоко'), findsOneWidget);
    expect(find.text('Сыр'), findsOneWidget);
    expect(find.text('Итого: 390.50 ₽'), findsOneWidget);

    await tester.tap(find.byKey(const Key('clearButton')));
    await tester.pump();
    expect(find.text('Список пуст'), findsOneWidget);
    expect(find.text('Итого: 0.00 ₽'), findsOneWidget);
  });

  testWidgets('переход между двумя экранами и возврат назад', (tester) async {
    await tester.pumpWidget(const ShoppingApp());
    await addItem(tester, 'Сыр', '200', '2'); // 400 ₽

    await tester.tap(find.byKey(const Key('summaryButton')));
    await tester.pumpAndSettle();

    expect(find.text('Сводка'), findsWidgets);
    expect(find.text('Позиций: 1'), findsOneWidget);
    expect(find.text('Сумма: 400.00 ₽'), findsOneWidget);
    expect(find.text('Со скидкой 10%: 360.00 ₽'), findsOneWidget);
    expect(find.text('Самая дорогая: Сыр'), findsOneWidget);

    await tester.tap(find.byKey(const Key('backButton')));
    await tester.pumpAndSettle();

    expect(find.text('Список покупок'), findsOneWidget);
    expect(find.text('Итого: 400.00 ₽'), findsOneWidget);
  });
}
