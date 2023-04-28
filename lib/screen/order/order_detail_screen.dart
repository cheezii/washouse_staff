// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';
import 'package:flutter/src/widgets/basic.dart' as basic;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timelines/timelines.dart';
import 'package:washouse_staff/resource/controller/order_controller.dart';
import 'package:washouse_staff/resource/model/order.dart';
import 'package:washouse_staff/resource/model/order_infomation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:washouse_staff/screen/order/cancelled_detail_screen.dart';
import 'package:washouse_staff/utils/order_util.dart';
import '../../components/constants/color_constants.dart';
import '../../resource/controller/tracking_controller.dart';
import '../../utils/price_util.dart';
import 'components/details_widget/service_details.dart';
import 'tracking_order_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  //final String status;
  //final Order order;
  final String orderId;
  const OrderDetailScreen({
    Key? key,
    //required this.status,
    //required this.order,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late int _processIndex;
  bool isLoading = false;
  OrderController orderController = OrderController();
  TrackingController trackingController = TrackingController();
  late Order_Infomation order_infomation;
  String CancelledReason = '';
  TextEditingController _textEditingController = TextEditingController();
  bool isCancelledReasonEmpty = true;

  Color getColor(int index) {
    if (index == _processIndex) {
      return kPrimaryColor;
    } else if (index < _processIndex) {
      return kPrimaryColor;
    } else {
      return Colors.grey.shade400;
    }
  }

  @override
  void initState() {
    super.initState();
    // if (widget.status == 'Đang chờ') {
    //   _processIndex = 0;
    // } else if (widget.status == 'Xác nhận') {
    //   _processIndex = 1;
    // } else if (widget.status == 'Xử lý') {
    //   _processIndex = 2;
    // } else if (widget.status == 'Sẵn sàng') {
    //   _processIndex = 3;
    // } else if (widget.status == 'Hoàn tất') {
    //   _processIndex = 4;
    // }
    getOrderInfomation();
  }

  void getOrderInfomation() async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      // Wait for getOrderInformation to complete
      Order_Infomation result =
          await orderController.getOrderInformation(widget.orderId);
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
      // return basic.Center(
      //     child: LoadingAnimationWidget.twistingDots(
      //   leftDotColor: const Color(0xFF1A1A3F),
      //   rightDotColor: const Color(0xFFEA3799),
      //   size: 200,
      // ));
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 10.0,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            child: basic.Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                width: 100,
                height: 100,
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: kPrimaryColor, size: 50),
              ),
            ),
          )
        ],
      );
    } else {
      String status = order_infomation.status!;
      if (status.toLowerCase().trim() == 'pending') {
        _processIndex = 0;
      } else if (status.toLowerCase().trim() == 'confirmed') {
        _processIndex = 1;
      } else if (status.toLowerCase().trim() == 'received') {
        _processIndex = 2;
      } else if (status.toLowerCase().trim() == 'processing') {
        _processIndex = 3;
      } else if (status.toLowerCase().trim() == 'ready') {
        _processIndex = 4;
      } else if (status.toLowerCase().trim() == 'completed') {
        _processIndex = 5;
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
          centerTitle: true,
          title: Text('Chi tiết đơn hàng',
              style: TextStyle(color: textColor, fontSize: 27)),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${order_infomation.id}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${order_infomation.orderTrackings!.first.createdDate}',
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    Text(
                      '${OrderUtils().mapVietnameseOrderStatus(status)}',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              separateLine(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Theo dõi đơn hàng',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: TrackingOrderScreen(
                                        order_infomation: order_infomation,
                                        status: status),
                                    type: PageTransitionType
                                        .rightToLeftWithFade));
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 90,
                    child: Timeline.tileBuilder(
                      theme: TimelineThemeData(
                        direction: Axis.horizontal,
                        connectorTheme: const ConnectorThemeData(
                          space: 30.0,
                          thickness: 5.0,
                        ),
                      ),
                      builder: TimelineTileBuilder.connected(
                        connectionDirection: ConnectionDirection.before,
                        itemExtentBuilder: (_, __) =>
                            MediaQuery.of(context).size.width /
                            _processes.length,
                        contentsBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              _processes[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: getColor(index),
                              ),
                            ),
                          );
                        },
                        indicatorBuilder: (_, index) {
                          var color;
                          var child;
                          if (index == _processIndex) {
                            color = kPrimaryColor;
                            child = const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            );
                          } else if (index < _processIndex) {
                            color = kPrimaryColor;
                            child = const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15.0,
                            );
                          } else {
                            color = Colors.grey.shade400;
                          }
                          if (_processIndex == 5) {
                            color = kPrimaryColor;
                            child = const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15.0,
                            );
                          }
                          if (index <= _processIndex) {
                            return Stack(
                              children: [
                                CustomPaint(
                                  size: Size(30.0, 30.0),
                                  painter: _BezierPainter(
                                    color: color,
                                    drawStart: index > 0,
                                    drawEnd: index < _processIndex,
                                  ),
                                ),
                                DotIndicator(
                                  size: 30.0,
                                  color: color,
                                  child: child,
                                ),
                              ],
                            );
                          } else {
                            return Stack(
                              children: [
                                CustomPaint(
                                  size: Size(15.0, 15.0),
                                  painter: _BezierPainter(
                                    color: color,
                                    drawEnd: index < _processes.length - 1,
                                  ),
                                ),
                                OutlinedDotIndicator(
                                  borderWidth: 4.0,
                                  color: color,
                                ),
                              ],
                            );
                          }
                        },
                        connectorBuilder: (_, index, type) {
                          if (index > 0) {
                            if (index == _processIndex) {
                              final prevColor = getColor(index - 1);
                              final color = getColor(index);
                              List<Color> gradientColors;
                              if (type == ConnectorType.start) {
                                gradientColors = [
                                  Color.lerp(prevColor, color, 0.5)!,
                                  color
                                ];
                              } else {
                                gradientColors = [
                                  prevColor,
                                  Color.lerp(prevColor, color, 0.5)!
                                ];
                              }
                              return DecoratedLineConnector(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                  ),
                                ),
                              );
                            } else {
                              return SolidLineConnector(
                                color: getColor(index),
                              );
                            }
                          } else {
                            return null;
                          }
                        },
                        itemCount: _processes.length,
                      ),
                    ),
                  ),
                ],
              ),
              separateLine(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin khách hàng', //hoặc địa chỉ nhận hàng/gửi hàng...
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tên khách hàng: ${order_infomation.customerName}',
                      style: const TextStyle(fontSize: 16, color: textColor),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Số điện thoại: ${order_infomation.customerMobile}',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Địa chỉ: ${order_infomation.customerAddress}',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      overflow: TextOverflow.clip,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        (order_infomation.deliveryType == 1 ||
                                order_infomation.deliveryType == 3)
                            ? order_infomation.orderDeliveries!
                                        .firstWhere((element) =>
                                            element.deliveryType == false)
                                        .deliveryDate !=
                                    null
                                ? Text(
                                    'Giờ khách giao hàng: ${order_infomation.orderDeliveries!.firstWhere((element) => element.deliveryType == false).deliveryDate}',
                                    style: const TextStyle(
                                        fontSize: 16, color: textColor),
                                  )
                                : const SizedBox(height: 0)
                            : const SizedBox(height: 0, width: 0),
                        (order_infomation.deliveryType == 2 ||
                                order_infomation.deliveryType == 3)
                            ? order_infomation.orderDeliveries!
                                        .firstWhere((element) =>
                                            element.deliveryType == true)
                                        .deliveryDate !=
                                    null
                                ? Text(
                                    'Giờ khách nhận hàng: ${order_infomation.orderDeliveries!.firstWhere((element) => element.deliveryType == true).deliveryDate}',
                                    style: const TextStyle(
                                        fontSize: 16, color: textColor),
                                  )
                                : const SizedBox(height: 0)
                            : const SizedBox(height: 0, width: 0),
                      ],
                    ),
                  ],
                ),
              ),
              separateLine(),
              DetailService(
                  status: OrderUtils().mapVietnameseOrderStatus(status),
                  order_infomation: order_infomation),
              separateLine(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phương thức vận chuyển',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 35,
                            child: Image.asset(
                                'assets/images/shipping/ship-di.png'),
                          ),
                          const SizedBox(width: 8),
                          (order_infomation.deliveryType == 0)
                              ? const Text(
                                  'Không sử dụng dịch vụ vận chuyển',
                                  style: TextStyle(fontSize: 16),
                                )
                              : const SizedBox(height: 0),
                          (order_infomation.deliveryType == 1)
                              ? const Text(
                                  'Vận chuyển từ khách hàng đến trung tâm',
                                  style: TextStyle(fontSize: 16),
                                )
                              : const SizedBox(height: 0),
                          (order_infomation.deliveryType == 2)
                              ? const Text(
                                  'Vận chuyển từ trung tâm đến khách hàng',
                                  style: TextStyle(fontSize: 16),
                                )
                              : const SizedBox(height: 0),
                          (order_infomation.deliveryType == 3)
                              ? const Text(
                                  'Vận chuyển hai chiều',
                                  style: TextStyle(fontSize: 16),
                                )
                              : const SizedBox(height: 0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              separateLine(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phương thức thanh toán',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child:
                          (order_infomation.orderPayment!.paymentMethod! == 0)
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: 35,
                                      child: Image.asset(
                                          'assets/images/shipping/cash-on-delivery.png'),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Thanh toán bằng tiền mặt',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                )
                              : Row(
                                  children: [
                                    SizedBox(
                                      width: 35,
                                      child: Image.asset(
                                          'assets/images/payments/vnpay-icon.png'),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Thanh toán bằng ví',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                    ),
                  ],
                ),
              ),
              separateLine(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chi tiết thanh toán',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng đơn hàng:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${PriceUtils().convertFormatPrice(order_infomation.totalOrderValue!.toInt())} đ',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Phí vận chuyển:',
                                style: TextStyle(fontSize: 16),
                              ),
                              (order_infomation.deliveryPrice == null)
                                  ? const Text(
                                      '0 đ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      '${PriceUtils().convertFormatPrice(order_infomation.deliveryPrice!.toDouble().round())} đ',
                                      //'${order_infomation.deliveryPrice!.toDouble().round()} đ',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Phí nền tảng:',
                                style: TextStyle(fontSize: 16),
                              ),
                              (order_infomation.deliveryPrice == null)
                                  ? const Text(
                                      '0 đ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      '${PriceUtils().convertFormatPrice(order_infomation.deliveryPrice!.toDouble().round())} đ',
                                      //'${order_infomation.deliveryPrice!.toDouble().round()} đ',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Chiết khấu:',
                                style: TextStyle(fontSize: 16),
                              ),
                              (order_infomation.orderPayment!.discount == 0)
                                  ? const Text(
                                      '- 0 đ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      '- ${PriceUtils().convertFormatPrice((order_infomation.orderPayment!.discount! * order_infomation.totalOrderValue!).toInt())} đ',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          ),
                          Divider(
                            height: 40,
                            color: Colors.grey.shade300,
                            thickness: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng thanh toán:',
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                '${PriceUtils().convertFormatPrice(order_infomation.orderPayment!.paymentTotal!.toInt())} đ',
                                style: const TextStyle(
                                    fontSize: 17,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
        bottomNavigationBar: status.toLowerCase() == 'pending'
            ? Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -15),
                      blurRadius: 20,
                      color: const Color(0xffdadada).withOpacity(0.15),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: cancelledColor),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Align(
                                    alignment: Alignment.center,
                                    child: Text('Thông báo')),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Bạn có chắn chắn muốn hủy đơn hàng ${order_infomation.id!}?'),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Lý do hủy',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 19),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      maxLines: 6,
                                      maxLength: 500,
                                      controller: _textEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'Nhập lý do hủy',
                                        contentPadding: const EdgeInsets.only(
                                            top: 8,
                                            left: 8,
                                            right: 8,
                                            bottom: 8),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          CancelledReason = value;
                                          isCancelledReasonEmpty = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            String result =
                                                await trackingController
                                                    .cancelledOrder(
                                                        order_infomation.id!,
                                                        CancelledReason);
                                            if (result.compareTo("success") ==
                                                0) {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('Thông báo'),
                                                    content: Text(
                                                        'Đơn hàng đã được hủy thành công!'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  child:
                                                                      CancelledDetailScreen(
                                                                    orderId:
                                                                        order_infomation
                                                                            .id!,
                                                                  ),
                                                                  type: PageTransitionType
                                                                      .rightToLeftWithFade));
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('Thông báo'),
                                                    content: Text(
                                                        'Có lỗi xảy ra trong quá trình xử lý hoặc đơn hàng không thể hủy! Bạn vui lòng thử lại sau'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                          .symmetric(
                                                      horizontal: 19,
                                                      vertical: 10),
                                              elevation: 0,
                                              foregroundColor: cancelledColor
                                                  .withOpacity(.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                side: BorderSide(
                                                    color: cancelledColor,
                                                    width: 1),
                                              ),
                                              backgroundColor: cancelledColor),
                                          child: const Text(
                                            'Xác nhận hủy',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                          .symmetric(
                                                      horizontal: 19,
                                                      vertical: 10),
                                              elevation: 0,
                                              foregroundColor:
                                                  kPrimaryColor.withOpacity(.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                side: const BorderSide(
                                                    color: kPrimaryColor,
                                                    width: 1),
                                              ),
                                              backgroundColor: kPrimaryColor),
                                          child: const Text(
                                            'Giữ lại',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  // TextButton(
                                  //   onPressed: () async {
                                  //     String result = await trackingController
                                  //         .cancelledOrder(order_infomation.id!,
                                  //             CancelledReason);
                                  //     if (result.compareTo("success") == 0) {
                                  //       Navigator.of(context).pop();
                                  //       showDialog(
                                  //         context: context,
                                  //         builder: (BuildContext context) {
                                  //           return AlertDialog(
                                  //             title: const Text('Thông báo'),
                                  //             content: Text(
                                  //                 'Đơn hàng đã được hủy thành công!'),
                                  //             actions: [
                                  //               TextButton(
                                  //                 onPressed: () {
                                  //                   Navigator.of(context).pop();
                                  //                   Navigator.push(
                                  //                       context,
                                  //                       PageTransition(
                                  //                           child:
                                  //                               CancelledDetailScreen(
                                  //                             orderId:
                                  //                                 order_infomation
                                  //                                     .id!,
                                  //                           ),
                                  //                           type: PageTransitionType
                                  //                               .rightToLeftWithFade));
                                  //                 },
                                  //                 child: Text('OK'),
                                  //               ),
                                  //             ],
                                  //           );
                                  //         },
                                  //       );
                                  //     } else {
                                  //       Navigator.of(context).pop();
                                  //       showDialog(
                                  //         context: context,
                                  //         builder: (BuildContext context) {
                                  //           return AlertDialog(
                                  //             title: const Text('Thông báo'),
                                  //             content: Text(
                                  //                 'Có lỗi xảy ra trong quá trình xử lý hoặc đơn hàng không thể hủy! Bạn vui lòng thử lại sau'),
                                  //             actions: [
                                  //               TextButton(
                                  //                 onPressed: () {
                                  //                   Navigator.of(context).pop();
                                  //                 },
                                  //                 child: Text('OK'),
                                  //               ),
                                  //             ],
                                  //           );
                                  //         },
                                  //       );
                                  //     }
                                  //   },
                                  //   child: Text('Xác nhận hủy'),
                                  // ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     Navigator.of(context).pop();
                                  //   },
                                  //   child: Text('Giữ lại'),
                                  // ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Từ chối',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: kPrimaryColor),
                        onPressed: () async {
                          setState(() {
                            _processIndex =
                                (_processIndex + 1) % _processes.length;
                          });
                          String result = await trackingController
                              .trackingOrder(order_infomation.id!);
                          if (result.compareTo("success") == 0) {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Thông báo'),
                                  content: Text(
                                      'Đơn hàng đã được xác nhận thành công!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: OrderDetailScreen(
                                                  orderId: order_infomation.id!,
                                                ),
                                                type: PageTransitionType
                                                    .rightToLeftWithFade));
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Thông báo'),
                                  content: Text(
                                      'Có lỗi xảy ra trong quá trình xử lý! Bạn vui lòng thử lại sau'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text(
                          'Chấp nhận',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : status.toLowerCase() == 'confirmed' ||
                    status.toLowerCase() == 'processing' ||
                    status.toLowerCase() == 'received'
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, -15),
                          blurRadius: 20,
                          color: const Color(0xffdadada).withOpacity(0.15),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 190,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: kPrimaryColor),
                        onPressed: () async {
                          setState(() {
                            _processIndex =
                                (_processIndex + 1) % _processes.length;
                          });
                          String result = await trackingController
                              .trackingOrder(order_infomation.id!);
                          if (result.compareTo("success") == 0) {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Thông báo'),
                                  content: Text(status == 'confirmed'
                                      ? 'Đơn hàng đã được chuyển sang trạng thái đã nhận!'
                                      : status == 'received'
                                          ? 'Đơn hàng đã được chuyển sang trạng thái xử lý!'
                                          : 'Đơn hàng đã được chuyển sang trạng thái tiếp theo!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: OrderDetailScreen(
                                                  orderId: order_infomation.id!,
                                                ),
                                                type: PageTransitionType
                                                    .rightToLeftWithFade));
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Thông báo'),
                                  content: Text(
                                      'Có lỗi xảy ra trong quá trình xử lý! Bạn vui lòng thử lại sau'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text(
                          'Cập nhật',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  )
                : status.toLowerCase() == 'ready'
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, -15),
                              blurRadius: 20,
                              color: const Color(0xffdadada).withOpacity(0.15),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: 190,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: kPrimaryColor),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Thông báo'),
                                    content: Text(
                                        'Bạn có chắn chắn muốn hoàn thành đơn hàng ${order_infomation.id!}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          String result =
                                              await trackingController
                                                  .completeOrder(
                                                      order_infomation.id!);
                                          if (result.compareTo("success") ==
                                              0) {
                                            Navigator.of(context).pop();

                                            setState(() {
                                              _processIndex =
                                                  (_processIndex + 1) %
                                                      _processes.length;
                                            });
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('Thông báo'),
                                                  content: Text(
                                                      'Đơn hàng đã hoàn thành!'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                child:
                                                                    OrderDetailScreen(
                                                                  orderId:
                                                                      order_infomation
                                                                          .id!,
                                                                ),
                                                                type: PageTransitionType
                                                                    .rightToLeftWithFade));
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('Thông báo'),
                                                  content: Text(
                                                      'Có lỗi xảy ra trong quá trình xử lý! Bạn vui lòng thử lại sau'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Text('Xác nhận hoàn thành'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Hủy bỏ'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Hoàn tất đơn hàng',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      )
                    : status.toLowerCase() == 'completed'
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, -15),
                                  blurRadius: 20,
                                  color:
                                      const Color(0xffdadada).withOpacity(0.15),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: 190,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor: kPrimaryColor),
                                onPressed: () {
                                  setState(() {
                                    _processIndex =
                                        (_processIndex + 1) % _processes.length;
                                  });
                                },
                                child: const Text(
                                  'Xem đánh giá',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(height: 0, width: 0),
      );
    }
  }

  Column separateLine() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Divider(thickness: 5, color: Colors.grey.shade200),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = [
  'Đang chờ',
  'Xác nhận',
  'Đã nhận',
  'Xử lý',
  'Sẵn sàng',
  'Hoàn tất',
];
