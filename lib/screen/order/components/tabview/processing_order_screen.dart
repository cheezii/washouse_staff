import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';

import '../../../../resource/model/order.dart';
import '../no_order.dart';

class ProcessingOrderScreen extends StatefulWidget {
  const ProcessingOrderScreen({super.key});

  @override
  State<ProcessingOrderScreen> createState() => _ProcessingOrderScreenState();
}

class _ProcessingOrderScreenState extends State<ProcessingOrderScreen> {
  List<Order> processingList = [];
  @override
  Widget build(BuildContext context) {
    if (processingList.isEmpty) {
      return const NoOrderScreen();
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: processingList.length,
            itemBuilder: ((context, index) {
              return const OrderCard(status: 'Xử lý');
            }),
          ),
        ),
      );
    }
  }
}
