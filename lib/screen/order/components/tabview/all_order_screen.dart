import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';

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
  //List<Order> orderItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // centerArgs = widget.orderId;
    getOrderItems();
  }

  void getOrderItems() async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      // Wait for getOrderInformation to complete
      List<Order> result = await orderController.getOrderList(1, 100, null, null, null, null, null);
      setState(() {
        // Update state with loaded data
        orderList = result;
        print(result.length);
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
          child: LoadingAnimationWidget.twistingDots(
        leftDotColor: const Color(0xFF1A1A3F),
        rightDotColor: const Color(0xFFEA3799),
        size: 200,
      ));
    } else {
      if (orderList.isEmpty) {
        return const NoOrderScreen();
      } else {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderList.length,
              itemBuilder: ((context, index) {
                return Column(
                  children: [
                    OrderCard(order: orderList[index], status: 'Đang chờ'),
                  ],
                );
              }),
            ),
          ),
        );
      }
    }
  }
}
