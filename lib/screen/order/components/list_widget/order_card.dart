// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/resource/model/order.dart';

import 'package:washouse_staff/screen/order/order_detail_screen.dart';

import '../../../../components/constants/color_constants.dart';
import '../../cancelled_detail_screen.dart';
import 'card_body.dart';
import 'card_heading.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int length = order.orderedServices!.length;
    return SizedBox(
      height: length > 1 ? 320 : 285,
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
              CardHeading(order: this.order),
              CardBody(order: this.order),
              Divider(thickness: 1, color: Colors.grey.shade300),
              const SizedBox(height: 1),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
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
                                child:
                                    OrderDetailScreen(orderId: order.orderId!),
                                type: PageTransitionType.fade));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 19, vertical: 10),
                      foregroundColor: kPrimaryColor.withOpacity(.7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: kPrimaryColor.withOpacity(.5), width: 1),
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
