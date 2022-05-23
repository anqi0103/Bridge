// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:bridge/app.dart';
import 'package:mockito/mockito.dart';
import 'widget_test.mocks.dart';

import '../lib/screens/home_screen_prompts.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  Query,
  QuerySnapshot,
  DocumentReference,
], customMocks: [
  MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>()
])
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App(
      title: '',
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  test('returns prompts if the http call completes successfully', () async {
    final client = MockFirebaseFirestore();
    final collectionReference = MockCollectionReference<Map<String, dynamic>>();
    final query = MockQuery<Map<String, dynamic>>();
    final querySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    final queryDocumentSnapshot = MockQueryDocumentSnapshot();
    final documentReference = MockDocumentReference<Map<String, dynamic>>();
    final collectionReference2 = MockCollectionReference<Map<String, dynamic>>();
    final querySnapshot2 = MockQuerySnapshot<Map<String, dynamic>>();

    when(client.collection('tempPrompts')).thenReturn(collectionReference);
    when(collectionReference.where('timestamp', isEqualTo: anything))
        .thenReturn(query);
    when(query.get()).thenAnswer((_) async => querySnapshot);
    when(querySnapshot.docs).thenReturn(List.from([queryDocumentSnapshot]));
    when(queryDocumentSnapshot.reference).thenReturn(documentReference);
    when(documentReference.collection('prompts')).thenReturn(collectionReference2);
    when(collectionReference2.get()).thenAnswer((_) async => querySnapshot2);
    when(querySnapshot2.docs).thenReturn(List.from([]));

    expect(await generatePromptsIfNone(client), List.from([]));
  });
}
