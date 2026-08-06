import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hirfati/features/Client/Home_client/domain_models/category_model.dart';
import 'package:hirfati/features/Client/Home_client/presentation/widgets/category_item_widget.dart';

void main() {
  const category = CategoryModel(
    id: 'plumbing',
    name: 'Plumbing',
    translations: [
      CategoryTranslationModel(
        categoryId: 'plumbing',
        locale: 'ar',
        name: 'السباكة',
      ),
      CategoryTranslationModel(
        categoryId: 'plumbing',
        locale: 'en',
        name: 'Plumbing',
      ),
    ],
  );

  testWidgets('saved Arabic cold start shows the Arabic filter immediately', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('ar', 'SA'),
        supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: CategoryItemWidget(category: category, isSelected: true),
        ),
      ),
    );

    expect(find.text('السباكة'), findsOneWidget);
    expect(find.text('Plumbing'), findsNothing);
    expect(
      tester
          .widget<CategoryItemWidget>(find.byType(CategoryItemWidget))
          .isSelected,
      isTrue,
    );
  });

  testWidgets('saved English cold start shows the English filter', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en', 'US'),
        supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: CategoryItemWidget(category: category)),
      ),
    );

    expect(find.text('Plumbing'), findsOneWidget);
    expect(find.text('السباكة'), findsNothing);
  });

  testWidgets('runtime locale changes rebuild labels and preserve selection', (
    tester,
  ) async {
    await tester.pumpWidget(const _LocaleHarness(category: category));
    expect(find.text('Plumbing'), findsOneWidget);

    await tester.tap(find.byKey(const Key('switch-ar')));
    await tester.pumpAndSettle();
    expect(find.text('السباكة'), findsOneWidget);
    expect(
      tester
          .widget<CategoryItemWidget>(find.byType(CategoryItemWidget))
          .isSelected,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('switch-en')));
    await tester.pumpAndSettle();
    expect(find.text('Plumbing'), findsOneWidget);
    expect(
      tester
          .widget<CategoryItemWidget>(find.byType(CategoryItemWidget))
          .isSelected,
      isTrue,
    );
  });
}

class _LocaleHarness extends StatefulWidget {
  const _LocaleHarness({required this.category});
  final CategoryModel category;

  @override
  State<_LocaleHarness> createState() => _LocaleHarnessState();
}

class _LocaleHarnessState extends State<_LocaleHarness> {
  Locale _locale = const Locale('en', 'US');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: Column(
          children: [
            CategoryItemWidget(category: widget.category, isSelected: true),
            TextButton(
              key: const Key('switch-ar'),
              onPressed: () => setState(() {
                _locale = const Locale('ar', 'SA');
              }),
              child: const Text('AR'),
            ),
            TextButton(
              key: const Key('switch-en'),
              onPressed: () => setState(() {
                _locale = const Locale('en', 'US');
              }),
              child: const Text('EN'),
            ),
          ],
        ),
      ),
    );
  }
}
