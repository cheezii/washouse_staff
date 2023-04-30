import 'package:flutter/material.dart';
import 'package:washouse_staff/components/constants/text_constants.dart';
import 'package:washouse_staff/resource/model/order.dart';

import '../../../../components/constants/color_constants.dart';

class CardHeading extends StatelessWidget {
  final Order order;
  const CardHeading({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    String statusOrder = order.status!.toLowerCase();
    String status = '';
    Color statusColor = kPrimaryColor;
    if (statusOrder == 'pending') {
      statusColor = pendingdColor;
      status = pending;
    } else if (statusOrder == 'confirmed') {
      statusColor = confirmedColor;
      status = confirmed;
    } else if (statusOrder == 'received') {
      statusColor = receivedColor;
      status = received;
    } else if (statusOrder == 'processing') {
      statusColor = processingColor;
      status = processing;
    } else if (statusOrder == 'ready') {
      statusColor = readyColor;
      status = ready;
    } else if (statusOrder == 'completed') {
      statusColor = completeColor;
      status = completed;
    } else if (statusOrder == 'cancelled') {
      statusColor = cancelledColor;
      status = cancelled;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              //orderList[0].centerName,
              '#${order.orderId}',
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: statusColor,
            border: Border.all(color: statusColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              status,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
