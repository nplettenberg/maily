import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maily/components/account/account.dart';

void main() {
  testWidgets('should build tile for google account', (tester) async {
    final account = Account(
      id: 'test',
      address: 'test@gmail.com',
      accountType: AccountType.google,
    );

    final widget = AccountTile(account: account);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    );

    expect(find.byType(GoogleMailLogo), findsOneWidget);
    expect(find.text(account.address), findsOneWidget);
  });

  testWidgets('should build tile for manual account', (tester) async {
    final account = Account(
      id: 'test',
      address: 'test@test.com',
      accountType: AccountType.manual,
    );

    final widget = AccountTile(account: account);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    );

    expect(find.byType(DefaultMailLogo), findsOneWidget);
    expect(find.text(account.address), findsOneWidget);
  });
}
