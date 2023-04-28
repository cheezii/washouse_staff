import 'package:flutter/material.dart';
import 'package:washouse_staff/resource/controller/order_controller.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../components/constants/color_constants.dart';
import '../../../../resource/model/order.dart';
import '../no_order.dart';

class CompletedOrderScreen extends StatefulWidget {
  const CompletedOrderScreen({super.key});

  @override
  State<CompletedOrderScreen> createState() => _CompletedOrderScreenState();
}

class _CompletedOrderScreenState extends State<CompletedOrderScreen> {
  List<Order> completedList = [];
  OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: orderController.getOrderList(
          1, 100, null, null, null, 'completed', null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.prograssiveDots(
                color: kPrimaryColor, size: 50),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          completedList = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: completedList.length,
                itemBuilder: ((context, index) {
                  return OrderCard(order: completedList[index]);
                }),
              ),
            ),
          );
        } else {
          return const NoOrderScreen();
        }
      },
    );
    // if (isLoading) {
    //   return Center(
    //       child: LoadingAnimationWidget.twistingDots(
    //     leftDotColor: const Color(0xFF1A1A3F),
    //     rightDotColor: const Color(0xFFEA3799),
    //     size: 200,
    //   ));
    // } else {
    //   if (completedList.isEmpty) {
    //     return const NoOrderScreen();
    //   } else {
    //     return SingleChildScrollView(
    //       child: Padding(
    //         padding: const EdgeInsets.all(16),
    //         child: ListView.builder(
    //           shrinkWrap: true,
    //           physics: const NeverScrollableScrollPhysics(),
    //           itemCount: completedList.length,
    //           itemBuilder: ((context, index) {
    //             return OrderCard(status: 'Hoàn tất', order: completedList[index]);
    //           }),
    //         ),
    //       ),
    //     );
    //   }
    // }
  }
}
