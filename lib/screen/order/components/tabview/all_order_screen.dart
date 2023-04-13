import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';

import '../../../../resource/model/order.dart';
import '../no_order.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  List<Order> orderList = [];
  @override
  Widget build(BuildContext context) {
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
                  OrderCard(status: 'Đang chờ'),
                ],
              );
            }),
          ),
        ),
      );
    }
  }
}
