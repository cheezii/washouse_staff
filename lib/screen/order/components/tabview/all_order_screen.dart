import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';
import 'package:washouse_staff/utils/order_util.dart';

import '../../../../components/constants/color_constants.dart';
import '../../../../resource/controller/order_controller.dart';
import '../../../../resource/model/order.dart';
import '../no_order.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  List<Order> orderList = [];
  OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          orderController.getOrderList(1, 100, null, null, null, null, null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.prograssiveDots(
                color: kPrimaryColor, size: 50),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          orderList = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderList.length,
                itemBuilder: ((context, index) {
                  return OrderCard(order: orderList[index]);
                }),
              ),
            ),
          );
        } else {
          return const NoOrderScreen();
        }
      },
    );
    //   if (isLoading) {
    //     return Center(
    //         child: LoadingAnimationWidget.twistingDots(
    //       leftDotColor: const Color(0xFF1A1A3F),
    //       rightDotColor: const Color(0xFFEA3799),
    //       size: 200,
    //     ));
    //   } else {
    //     if (orderList.isEmpty) {
    //       return const NoOrderScreen();
    //     } else {
    //       return SingleChildScrollView(
    //         child: Padding(
    //           padding: const EdgeInsets.all(16),
    //           child: ListView.builder(
    //             shrinkWrap: true,
    //             physics: const NeverScrollableScrollPhysics(),
    //             itemCount: orderList.length,
    //             itemBuilder: ((context, index) {
    //               return Column(
    //                 children: [
    //                   OrderCard(order: orderList[index], status: OrderUtils().mapVietnameseOrderStatus(orderList[index].status!)),
    //                 ],
    //               );
    //             }),
    //           ),
    //         ),
    //       );
    //     }
    //   }
  }
}
