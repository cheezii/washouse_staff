import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../components/constants/color_constants.dart';
import '../../../../resource/model/order.dart';
import '../../../../utils/order_util.dart';
import '../../../../utils/price_util.dart';
import '../../delivery_order_details.dart';
import 'card_heading.dart';

class CardOrder extends StatelessWidget {
  final Order order;
  const CardOrder({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isHaveDropoff = false;
    int size = 0;
    if (order.deliveryType == 1 || order.deliveryType == 3) {
      isHaveDropoff = true;
      size++;
    }
    bool isHaveReceive = false;
    if (order.deliveryType == 2 || order.deliveryType == 3) {
      isHaveReceive = true;
      size++;
    }
    return SizedBox(
      height: (size == 2) ? 330 : 250,
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                      color: pendingdColor,
                      border: Border.all(color: pendingdColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${OrderUtils().mapVietnameseOrderStatus(order.status!)}',
                        style: const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              isHaveDropoff
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(thickness: 1, color: Colors.grey.shade500),
                        Text(
                          'Lấy đơn',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: kPrimaryColor,
                              size: 35,
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 280, // Set the width of the SizedBox to limit the width of the Column
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${order.deliveries!.first.addressString}',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textColor),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    '${order.deliveries!.first.wardName}, ${order.deliveries!.first.districtName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(height: 0),
              isHaveReceive
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(thickness: 1, color: Colors.grey.shade500),
                        Text(
                          'Trả đơn',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: kPrimaryColor,
                              size: 35,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${order.deliveries!.last.addressString}',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textColor),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  '${order.deliveries!.last.wardName}, ${order.deliveries!.last.districtName}',
                                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(height: 0),
              Divider(thickness: 1, color: Colors.grey.shade300),
              RichText(
                text: TextSpan(
                  text: 'Khách hàng: ',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${order.customerName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              //Divider(thickness: 1, color: Colors.grey.shade300),
              const SizedBox(height: 7),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, PageTransition(child: DeliveryOrderDetails(order: order), type: PageTransitionType.fade));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
                      foregroundColor: kPrimaryColor.withOpacity(.7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: kPrimaryColor.withOpacity(.5), width: 1),
                      ),
                      backgroundColor: kPrimaryColor),
                  child: const Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
