
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('La aplicación Biblioteca ITSPR inicia correctamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BibliotecaApp());

    expect(find.text('Biblioteca ITSPR'), findsOneWidget);
    expect(find.text('Inicia sesión institucional'), findsOneWidget);
  });
}
