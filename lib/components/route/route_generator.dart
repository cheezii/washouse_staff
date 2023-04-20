import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/home/home_screen.dart';
import 'package:washouse_staff/screen/order/create_order_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
          builder: (context) => HomeScreen(centerId: args),
        );
      case '/createOrder':
        return MaterialPageRoute(
          builder: (context) => CreateOrderScreen(categoryData: args),
        );
      // case '/listCategory':
      //   return MaterialPageRoute(
      //     builder: (context) => ListCategoryScreen(categoryData: args),
      //   );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Không tìm thấy trang!'),
        ),
      );
    });
  }
}
