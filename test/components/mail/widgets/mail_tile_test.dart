import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maily/components/components.dart';

void main() {
  testWidgets('should build with full content', (tester) async {
    final receivedAt = DateTime.now();

    final mail = Mail(
      sender: Sender(
        address: 'test@test.de',
        clearName: 'Max Mustermann',
      ),
      content: MailContent(
        content: 'Test content',
      ),
      receivedAt: receivedAt,
      seen: true,
      subject: 'Test subject',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MailTile(mail: mail),
        ),
      ),
    );

    expect(
      find.textContaining(
        'test@test.de',
        skipOffstage: false,
      ),
      findsOneWidget,
    );

    expect(
      find.textContaining(
        'Max Mustermann',
        skipOffstage: false,
      ),
      findsOneWidget,
    );

    expect(find.byType(MailSubjectRow), findsOneWidget);
    expect(find.text('Test subject'), findsOneWidget);

    expect(find.byType(MailContentPreview), findsOneWidget);
    expect(find.text('Test content'), findsOneWidget);

    expect(
      tester.widget(find.byType(MailHeaderDate)),
      isA<MailHeaderDate>().having(
        (p0) => p0.date,
        'receivedAt date',
        equals(receivedAt),
      ),
    );
  });

  testWidgets('should be marked as seen', (tester) async {
    final mail = Mail(
      sender: Sender(
        address: 'test@test.de',
        clearName: 'Max Mustermann',
      ),
      content: MailContent(
        content: 'Test content',
      ),
      receivedAt: DateTime.now(),
      seen: true,
      subject: 'Test subject',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MailTile(mail: mail),
        ),
      ),
    );

    expect(
      tester.widget(find.byType(MailyCard)),
      isA<MailyCard>().having(
        (p0) => p0.gradient,
        'is seen gradient',
        isNull,
      ),
    );
  });

  testWidgets('should be marked as unseen', (tester) async {
    final mail = Mail(
      sender: Sender(
        address: 'test@test.de',
        clearName: 'Max Mustermann',
      ),
      content: MailContent(
        content: 'Test content',
      ),
      receivedAt: DateTime.now(),
      seen: false,
      subject: 'Test subject',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MailTile(mail: mail),
        ),
      ),
    );

    expect(
      tester.widget(find.byType(MailyCard)),
      isA<MailyCard>().having(
        (p0) => p0.gradient,
        'is seen gradient',
        isNotNull,
      ),
    );
  });

  testWidgets('should build no content preview', (tester) async {
    final receivedAt = DateTime.now();

    final mail = Mail(
      sender: Sender(
        address: 'test@test.de',
      ),
      receivedAt: receivedAt,
      seen: true,
      subject: 'Test subject',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MailTile(mail: mail),
        ),
      ),
    );

    expect(
      find.textContaining(
        'test@test.de',
        skipOffstage: false,
      ),
      findsOneWidget,
    );

    expect(find.byType(MailSubjectRow), findsOneWidget);
    expect(find.text('Test subject'), findsOneWidget);

    expect(find.byType(MailContentPreview), findsNothing);

    expect(
      tester.widget(find.byType(MailHeaderDate)),
      isA<MailHeaderDate>().having(
        (p0) => p0.date,
        'receivedAt date',
        equals(receivedAt),
      ),
    );
  });
}
