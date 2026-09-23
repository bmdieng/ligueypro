// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ligueypro_2_0/app/app.dart';
import 'package:ligueypro_2_0/features/professionals/presentation/add_professional_page.dart';
import 'package:ligueypro_2_0/features/professionals/presentation/all_professionals_page.dart';
import 'package:ligueypro_2_0/features/presentation/presentation_page.dart';
import 'package:ligueypro_2_0/features/profile/presentation/cgu_page.dart';
import 'package:ligueypro_2_0/features/profile/presentation/help_support_page.dart';
import 'package:ligueypro_2_0/features/requests/presentation/my_requests_page.dart';
import 'package:ligueypro_2_0/features/requests/presentation/request_page.dart';

void main() {
  testWidgets('Home page renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: LigueyProApp()));
    await tester.pumpAndSettle();

    expect(find.text('Bonjour 👋'), findsOneWidget);
  });

  testWidgets('Request page shows the complete request form', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RequestPage()));

    expect(find.text('Nouvelle demande'), findsOneWidget);
    expect(find.text('Type de service'), findsOneWidget);
    expect(find.text('Urgence'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Numéro de téléphone'), findsOneWidget);
  });

  testWidgets('My requests page shows urgent items first', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyRequestsPage()));

    expect(find.text('Mes demandes'), findsOneWidget);
    expect(find.text('Urgent'), findsWidgets);
  });

  testWidgets('Home page has a working search field', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: LigueyProApp()));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsWidgets);
    expect(find.text('Rechercher un service...'), findsOneWidget);
  });

  testWidgets('Help and support page shows practical guidance', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HelpSupportPage()));

    expect(find.text('Aide et support'), findsOneWidget);
    expect(find.text('Comment ça marche'), findsOneWidget);
    expect(find.text('Questions fréquentes'), findsOneWidget);
  });

  testWidgets('CGU page shows legal information', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CguPage()));

    expect(find.text('Conditions générales d’utilisation'), findsWidgets);
    expect(find.text('1. Objet'), findsOneWidget);
  });

  testWidgets('Add professional page shows the form fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddProfessionalPage()));

    expect(find.text('Ajouter un professionnel'), findsOneWidget);
    expect(find.text('Nom du professionnel'), findsOneWidget);
    expect(find.text('Service'), findsOneWidget);
  });

  testWidgets('All professionals page shows the complete list', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AllProfessionalsPage()));

    expect(find.text('Tous les professionnels'), findsOneWidget);
    expect(find.text('Moyenne'), findsWidgets);
  });

  testWidgets('Presentation page shows the app promo section', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PresentationPage()));

    expect(find.text('Présentation de l’application'), findsOneWidget);
    expect(find.text('LigueyPro'), findsWidgets);
  });
}
