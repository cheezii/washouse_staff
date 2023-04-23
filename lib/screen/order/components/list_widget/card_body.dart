import 'package:flutter/material.dart';
import 'package:washouse_staff/resource/model/order.dart';
import 'package:washouse_staff/utils/price_util.dart';

import '../../../../components/constants/color_constants.dart';

class CardBody extends StatelessWidget {
  final Order order;
  final String status;
  const CardBody({
    super.key,
    required this.order,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 70,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xfff5f6f9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset('assets/images/placeholder.png'), //ảnh dịch vụ
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      '${order.orderedServices!.first.serviceName}',
                      style: const TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Phân loại: ${order.orderedServices!.first.serviceCategory}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'SL: ${order.orderedServices!.first.measurement}',
                        style: const TextStyle(color: textColor, fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Divider(thickness: 1, color: Colors.grey.shade300),
        (order.orderedServices!.length > 1)
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Và thêm ${order.orderedServices!.length - 1}  sản phẩm nữa',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: Colors.grey.shade500,
                      )
                    ],
                  ),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                ],
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thời gian đặt hàng:',
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            Text(
              '${order.orderDate}',
              style: TextStyle(color: textColor, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thanh toán',
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            Text(
              '${PriceUtils().convertFormatPrice(order.totalOrderPayment!.toInt())} đ',
              style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}
