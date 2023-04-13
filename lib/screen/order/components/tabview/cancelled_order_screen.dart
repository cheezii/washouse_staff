import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';

import '../../../../resource/model/order.dart';
import '../no_order.dart';

class CancelledOrderScreen extends StatefulWidget {
  const CancelledOrderScreen({super.key});

  @override
  State<CancelledOrderScreen> createState() => _CancelledOrderScreenState();
}

class _CancelledOrderScreenState extends State<CancelledOrderScreen> {
  List<Order> cancelledList = [];
  @override
  Widget build(BuildContext context) {
    if (cancelledList.isEmpty) {
      return const NoOrderScreen();
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cancelledList.length,
            itemBuilder: ((context, index) {
              return const OrderCard(status: 'Đã hủy');
            }),
          ),
        ),
      );
    }
  }
}
