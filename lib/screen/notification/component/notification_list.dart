// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/constants/color_constants.dart';
import '../../../resource/controller/order_controller.dart';
import '../../../utils/time_utils.dart';
import '../../order/order_detail_screen.dart';

class NotificationList extends StatefulWidget {
  final String title;
  final String content;
  final String image;
  final String time;
  final bool isNotiRead;
  const NotificationList({
    Key? key,
    required this.title,
    required this.content,
    required this.image,
    required this.time,
    required this.isNotiRead,
  }) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  OrderController orderController = OrderController();
  late FontWeight fontWeight;
  bool isPayment = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //bool checkOver24h = TimeUtils().checkOver24Hours(widget.time);
    bool checkOver24h = true;
    Color containerColor = Colors.white;
    if (!widget.isNotiRead)
      fontWeight = FontWeight.bold;
    else
      fontWeight = FontWeight.normal;
    return GestureDetector(
      onTap: () async {
        if (widget.title.contains("đơn hàng:")) {
          String orderId = widget.title.split(':').last.trim();
          var order = await orderController.getOrderInformation(orderId);
          if (order.orderPayment!.status!
                      .trim()
                      .toLowerCase()
                      .compareTo('paid') ==
                  0 ||
              order.orderPayment!.status!
                      .trim()
                      .toLowerCase()
                      .compareTo('received') ==
                  0) {
            setState(() {
              isPayment = true;
            });
          }
          Navigator.push(
              context,
              PageTransition(
                  child: OrderDetailScreen(orderId: orderId),
                  type: PageTransitionType.leftToRightWithFade));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(17)),
          child: Container(
            color: containerColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                color: kPrimaryColor,
                                spreadRadius: 1)
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(widget.image),
                          maxRadius: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: widget.isNotiRead
                                      ? Colors.grey.shade800
                                      : kPrimaryColor,
                                  fontWeight: fontWeight,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 250,
                                height: 35,
                                child: Text(
                                  widget.content,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: fontWeight,
                                      color: Colors.grey.shade600),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  checkOver24h
                      ? TimeUtils().getDisplayName(widget.time)
                      : TimeUtils().getDisplayName(widget.time.split(' ')[1]),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: fontWeight,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
