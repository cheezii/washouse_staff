import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/resource/controller/order_controller.dart';
import 'package:flutter/src/widgets/basic.dart' as basic;
import '../../components/constants/color_constants.dart';
import '../../resource/model/order.dart';
import '../../resource/model/order_infomation.dart';
import 'components/details_widget/service_details.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'search_order_screen.dart';

class CancelledDetailScreen extends StatefulWidget {
  final orderId;
  const CancelledDetailScreen({super.key, required this.orderId});

  @override
  State<CancelledDetailScreen> createState() => _CancelledDetailScreenState();
}

class _CancelledDetailScreenState extends State<CancelledDetailScreen> {
  bool isLoading = false;
  OrderController orderController = OrderController();
  Order_Infomation order_infomation = Order_Infomation();

  @override
  void initState() {
    super.initState();
    // centerArgs = widget.orderId;
    getOrderInfomation();
  }

  void getOrderInfomation() async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      // Wait for getOrderInformation to complete
      Order_Infomation result = await orderController.getOrderInformation(widget.orderId!);
      setState(() {
        // Update state with loaded data
        order_infomation = result;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return basic.Center(
          child: LoadingAnimationWidget.twistingDots(
        leftDotColor: const Color(0xFF1A1A3F),
        rightDotColor: const Color(0xFFEA3799),
        size: 200,
      ));
    } else {
      String cancelledBy = "";
      String cancelledReason = "";
      if (order_infomation.cancelReasonByCustomer != null) {
        cancelledBy = "bạn";
        cancelledReason = order_infomation.cancelReasonByCustomer!;
      } else if (order_infomation.cancelReasonByStaff != null) {
        cancelledBy = "Trung tâm";
        cancelledReason = order_infomation.cancelReasonByStaff!;
      }
      String truncatedText = cancelledReason;
      if (cancelledReason.length > 500) {
        // Truncate text if it exceeds maxChars
        truncatedText = cancelledReason.substring(0, 500);
      }
      String paymentMethodString = "";
      if (order_infomation.orderPayment!.paymentMethod == 0) {
        paymentMethodString = "Thanh toán khi nhận hàng";
      } else if (order_infomation.orderPayment!.paymentMethod == 1) {
        paymentMethodString = "Thanh toán bằng ví Washouse";
      }
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: textColor,
              size: 24,
            ),
          ),
          title: const Align(
            alignment: Alignment.center,
            child: Text('Chi tiết đơn hủy', style: TextStyle(color: textColor, fontSize: 27)),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, PageTransition(child: const SearchOrderScreen(), type: PageTransitionType.fade));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.search_rounded,
                  color: kBackgroundColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Đã hủy đơn hàng',
                        style: TextStyle(
                          color: cancelledColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (order_infomation.orderTrackings != null)
                            ? '${order_infomation.orderTrackings!.firstWhere((element) => (element.status!.trim().toLowerCase().compareTo("cancelled") == 0)).createdDate}'
                            : '',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.check_circle_outline_sharp,
                    color: cancelledColor,
                    size: 35,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(thickness: 8, color: Colors.grey.shade200),
            const SizedBox(height: 10),
            DetailService(
              status: "Đã hủy",
              order_infomation: order_infomation,
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                CancelDetailFooter(from: 'Yêu cầu bởi', to: '$cancelledBy'),
                CancelDetailFooter(
                  from: 'Yêu cầu vào',
                  to: (order_infomation.orderTrackings != null)
                      ? '${order_infomation.orderTrackings!.firstWhere((element) => (element.status!.trim().toLowerCase().compareTo("cancelled") == 0)).createdDate}'
                      : '',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lý do',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        width: MediaQuery.of(context).size.width / 2,
                        padding: const EdgeInsets.all(0.0),
                        child: Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            truncatedText,
                            maxLines: 20,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CancelDetailFooter(from: 'Phương thức thanh toán', to: paymentMethodString),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class CancelDetailFooter extends StatelessWidget {
  final String from;
  final String to;
  const CancelDetailFooter({
    super.key,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            from,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              to,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
