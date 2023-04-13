import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';

import '../../../../resource/model/order.dart';
import '../no_order.dart';

class CompletedOrderScreen extends StatefulWidget {
  const CompletedOrderScreen({super.key});

  @override
  State<CompletedOrderScreen> createState() => _CompletedOrderScreenState();
}

class _CompletedOrderScreenState extends State<CompletedOrderScreen> {
  List<Order> completedList = [];
  @override
  Widget build(BuildContext context) {
    if (completedList.isEmpty) {
      return const NoOrderScreen();
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: completedList.length,
            itemBuilder: ((context, index) {
              return const OrderCard(status: 'Hoàn tất');
            }),
          ),
        ),
      );
    }
  }
}
