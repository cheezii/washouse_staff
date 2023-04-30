import 'package:flutter/material.dart';
import 'package:washouse_staff/resource/controller/order_controller.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../components/constants/color_constants.dart';
import '../../../../resource/model/order.dart';
import '../no_order.dart';

class CancelledOrderScreen extends StatefulWidget {
  const CancelledOrderScreen({super.key});

  @override
  State<CancelledOrderScreen> createState() => _CancelledOrderScreenState();
}

class _CancelledOrderScreenState extends State<CancelledOrderScreen> {
  List<Order> cancelledList = [];
  OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: orderController.getOrderList(
          1, 100, null, null, null, 'cancelled', null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.prograssiveDots(
                color: kPrimaryColor, size: 50),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          cancelledList = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cancelledList.length,
                itemBuilder: ((context, index) {
                  return OrderCard(order: cancelledList[index]);
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
    //   if (cancelledList.isEmpty) {
    //     return const NoOrderScreen();
    //   } else {
    //     return SingleChildScrollView(
    //       child: Padding(
    //         padding: const EdgeInsets.all(16),
    //         child: ListView.builder(
    //           shrinkWrap: true,
    //           physics: const NeverScrollableScrollPhysics(),
    //           itemCount: cancelledList.length,
    //           itemBuilder: ((context, index) {
    //             return OrderCard(order: cancelledList[index]);
    //           }),
    //         ),
    //       ),
    //     );
    //   }
    // }
  }
}
