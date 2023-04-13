import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';

import '../../../../resource/model/order.dart';
import '../no_order.dart';

class ReadyOrderScreen extends StatefulWidget {
  const ReadyOrderScreen({super.key});

  @override
  State<ReadyOrderScreen> createState() => _ReadyOrderScreenState();
}

class _ReadyOrderScreenState extends State<ReadyOrderScreen> {
  List<Order> readyList = [];
  @override
  Widget build(BuildContext context) {
    if (readyList.isEmpty) {
      return const NoOrderScreen();
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: readyList.length,
            itemBuilder: ((context, index) {
              return const OrderCard(status: 'Sẵn sàng');
            }),
          ),
        ),
      );
    }
  }
}
