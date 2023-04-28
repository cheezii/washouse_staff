import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../components/constants/color_constants.dart';
import '../../../../resource/controller/order_controller.dart';
import '../../../../resource/model/order.dart';
import '../../../../utils/order_util.dart';
import '../list_widget/order_card.dart';
import '../no_order.dart';

class ReceivedOrderScreen extends StatefulWidget {
  const ReceivedOrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ReceivedOrderScreen> createState() => _ReceivedOrderScreenState();
}

class _ReceivedOrderScreenState extends State<ReceivedOrderScreen> {
  OrderController orderController = OrderController();
  List<Order> receivedList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: orderController.getOrderList(
          1, 100, null, null, null, 'received', null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.prograssiveDots(
                color: kPrimaryColor, size: 50),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          receivedList = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: receivedList.length,
                itemBuilder: ((context, index) {
                  return OrderCard(order: receivedList[index]);
                }),
              ),
            ),
          );
        } else {
          return const NoOrderScreen();
        }
      },
    );
  }
}
