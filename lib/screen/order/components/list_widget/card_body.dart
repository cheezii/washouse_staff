import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/resource/model/order.dart';
import 'package:washouse_staff/utils/price_util.dart';

import '../../../../components/constants/color_constants.dart';
import '../../cancelled_detail_screen.dart';
import '../../order_detail_screen.dart';

class CardBody extends StatelessWidget {
  final Order order;
  const CardBody({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // SizedBox(
            //   width: 70,
            //   child: AspectRatio(
            //     aspectRatio: 1,
            //     child: Container(
            //       padding: const EdgeInsets.all(10),
            //       decoration: BoxDecoration(
            //         color: const Color(0xfff5f6f9),
            //         borderRadius: BorderRadius.circular(15),
            //       ),
            //       child: Image.asset(
            //           'assets/images/placeholder.png'), //ảnh dịch vụ
            //     ),
            //   ),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                order.orderedServices!.first.image!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded.toDouble() /
                                loadingProgress.expectedTotalBytes!.toDouble()
                            : null),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 80,
                  height: 80,
                  child: Icon(Icons.error),
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
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Phân loại: ${order.orderedServices!.first.serviceCategory}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        order.orderedServices!.first.unit!
                                    .toLowerCase()
                                    .trim() ==
                                'kg'
                            ? 'KL: ${order.orderedServices!.first.measurement} kg'
                            : 'SL: ${order.orderedServices!.first.measurement!.round()} ${order.orderedServices!.first.unit!.toLowerCase()}',
                        style: const TextStyle(color: textColor, fontSize: 16),
                      ),
                      // Text(
                      //   'SL: ${order.orderedServices!.first.measurement}',
                      //   style: const TextStyle(color: textColor, fontSize: 16),
                      // )
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
                      GestureDetector(
                        onTap: () {
                          order.status!.toLowerCase() == 'cancelled'
                              ? Navigator.push(
                                  context,
                                  PageTransition(
                                    child: CancelledDetailScreen(
                                        orderId: order.orderId!),
                                    type: PageTransitionType.fade,
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  PageTransition(
                                      child: OrderDetailScreen(
                                          orderId: order.orderId!),
                                      type: PageTransitionType.fade));
                        },
                        child: Text(
                          'và thêm ${order.orderedServices!.length - 1} sản phẩm nữa',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14),
                        ),
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
            const Text(
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
            const Text(
              'Thanh toán:',
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            Text(
              '${PriceUtils().convertFormatPrice(order.totalOrderPayment!.toInt())} đ',
              style: const TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}
