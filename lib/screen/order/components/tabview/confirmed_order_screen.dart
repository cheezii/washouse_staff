import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';

import '../../../../resource/model/order.dart';
import '../no_order.dart';

class ConfirmedOrderScreen extends StatefulWidget {
  const ConfirmedOrderScreen({super.key});

  @override
  State<ConfirmedOrderScreen> createState() => _ConfirmedOrderScreenState();
}

class _ConfirmedOrderScreenState extends State<ConfirmedOrderScreen> {
  List<Order> confirmedList = [];
  @override
  Widget build(BuildContext context) {
    if (confirmedList.isEmpty) {
      return const NoOrderScreen();
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: confirmedList.length,
            itemBuilder: ((context, index) {
              return const OrderCard(status: 'Xác nhận');
            }),
          ),
        ),
      );
    }
  }
}
