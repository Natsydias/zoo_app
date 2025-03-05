import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/main.dart';
import 'package:zoo_app/screens/dashboard_screen.dart';
import 'package:zoo_app/screens/login_screen.dart';

void main() {
  testWidgets('Verificar pantalla inicial dependiendo del estado de sesión', (WidgetTester tester) async {
    // Simular preferencia compartida sin usuario logueado
    SharedPreferences.setMockInitialValues({});

    // Construir la aplicación
    await tester.pumpWidget(const MyApp(isLogged: false));

    // Verificar que la pantalla de Login aparece
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(DashboardScreen), findsNothing);

    // Simular preferencia compartida con usuario logueado
    SharedPreferences.setMockInitialValues({'usuario_nombre': 'PruebaUsuario'});

    // Volver a construir la aplicación con usuario logueado
    await tester.pumpWidget(const MyApp(isLogged: true));

    // Verificar que la pantalla de Dashboard aparece
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });
}
