// @dart=2.17
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:washouse_staff/resource/provider/cart_provider.dart';
import 'package:washouse_staff/screen/started/login.dart';

import 'components/route/route_generator.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = MyHttpOverrides();
    return const MaterialApp(
      title: 'Washouse Staff',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      home: SafeArea(child: Login()),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        //Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
