import 'dart:math';
import 'dart:ui';

import 'package:flutter/src/widgets/basic.dart' as basic;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timelines/timelines.dart';
import '../../resource/controller/base_controller.dart';
import 'package:washouse_staff/screen/category/list_category.dart';

import '../../components/constants/color_constants.dart';
import '../../resource/controller/center_controller.dart';
import '../../resource/controller/order_controller.dart';
import '../../resource/controller/tracking_controller.dart';
import '../../resource/model/order.dart';
import '../../resource/model/order_infomation.dart';
import '../../utils/mapping_util.dart';
import '../../utils/order_util.dart';
import '../../utils/price_util.dart';
import '../order/components/details_widget/service_details.dart';

class DeliveryOrderDetails extends StatefulWidget {
  final Order order;
  const DeliveryOrderDetails({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<DeliveryOrderDetails> createState() => _DeliveryOrderDetailsState();
}

class _DeliveryOrderDetailsState extends State<DeliveryOrderDetails> {
  late int _processIndex;
  bool isLoading = false;
  int? centerId;
  late Order_Infomation order_infomation;
  late String dropoffShipperPhone;
  late String dropoffShipperName;
  late String deliverShipperPhone;
  late String deliverShipperName;
  OrderController orderController = OrderController();
  TrackingController trackingController = TrackingController();
  CenterController centerController = CenterController();
  BaseController baseController = BaseController();
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
    if (widget.order.status?.trim().toLowerCase() == 'pending') {
      _processIndex = 0;
    } else if (widget.order.status?.trim().toLowerCase() == 'confirmed') {
      _processIndex = 1;
    } else if (widget.order.status?.trim().toLowerCase() == 'received') {
      _processIndex = 2;
    } else if (widget.order.status?.trim().toLowerCase() == 'processing') {
      _processIndex = 3;
    } else if (widget.order.status?.trim().toLowerCase() == 'ready') {
      _processIndex = 4;
    } else if (widget.order.status?.trim().toLowerCase() == 'completed') {
      _processIndex = 5;
    }
    getOrderInfomation();
  }

  void getOrderInfomation() async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      // Wait for getOrderInformation to complete
      Order_Infomation result = await orderController.getOrderInformation(widget.order.orderId!);
      var _centerId = await baseController.getInttoSharedPreference("CENTER_ID");

      setState(() {
        // Update state with loaded data
        centerId = _centerId;
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
    bool isHaveDropoff = false;
    int size = 0;
    if (widget.order.deliveryType == 1 || widget.order.deliveryType == 3) {
      isHaveDropoff = true;
      size++;
    }
    bool isHaveReceive = false;
    if (widget.order.deliveryType == 2 || widget.order.deliveryType == 3) {
      isHaveReceive = true;
      size++;
    }
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
                child: LoadingAnimationWidget.threeRotatingDots(color: kPrimaryColor, size: 50),
              ),
            ),
          )
        ],
      );
    } else {
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
          title: const Text('Chi tiết vận chuyển', style: TextStyle(color: textColor, fontSize: 25)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin vận chuyển',
                  style: TextStyle(color: textColor, fontSize: 21, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                isHaveDropoff
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: textColor, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Chiều đi',
                                  style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Text(
                                  //'a',
                                  '${MappingUtils().mapVietnameseDeliveryStatus(order_infomation.orderDeliveries!.first.status!)}',
                                  style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text(
                                  'Nhân viên',
                                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                (order_infomation.orderDeliveries!.first.status == null ||
                                        ((order_infomation.orderDeliveries!.first.status != null) &&
                                            (order_infomation.orderDeliveries!.first.status!.trim().toLowerCase().compareTo('pending') == 0)))
                                    ? ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              title: const Align(
                                                alignment: Alignment.center,
                                                child: Text('Vận chuyển đơn'),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    style: const TextStyle(
                                                      color: textColor,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Tên nhân viên vận chuyển',
                                                      labelStyle: const TextStyle(
                                                        color: textColor,
                                                        fontSize: 18,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey.shade500,
                                                      ),
                                                      // enabledBorder: OutlineInputBorder(
                                                      //     borderSide: BorderSide(
                                                      //         width: 1,
                                                      //         color: Colors.grey.shade400)),
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                                      hintText: 'Nhập họ và tên nhân viên',
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    ),
                                                    cursorColor: textColor.withOpacity(.8),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        dropoffShipperName = value;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(height: 8),
                                                  TextField(
                                                    style: const TextStyle(
                                                      color: textColor,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'SĐT nhân viên vận chuyển',
                                                      labelStyle: const TextStyle(
                                                        color: textColor,
                                                        fontSize: 18,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey.shade500,
                                                      ),
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                                      hintText: 'Nhập SĐT nhân viên',
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    ),
                                                    cursorColor: textColor.withOpacity(.8),
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        dropoffShipperPhone = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    Map<String, dynamic>? result = await centerController.assignDelivery(
                                                        widget.order.orderId!, 'dropoff', dropoffShipperName, dropoffShipperPhone);
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    if (result != null) {
                                                      Navigator.of(context).pop();
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: const Text('Thông báo'),
                                                            content: Text('Thông tin người vận chuyển đã được cập nhật!'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  Navigator.of(context).pop();
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child: DeliveryOrderDetails(
                                                                            order: widget.order,
                                                                          ),
                                                                          type: PageTransitionType.rightToLeftWithFade));
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
                                                            content: Text('Có lỗi xảy ra trong quá trình xử lý! Bạn vui lòng thử lại sau'),
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
                                                    'Cập nhật',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            side: BorderSide(color: kPrimaryColor.withOpacity(.5), width: 1),
                                          ),
                                          backgroundColor: kPrimaryColor,
                                        ),
                                        child: const Text(
                                          'Cập nhật NV',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 0,
                                        width: 0,
                                      ),
                              ],
                            ),
                            Text(
                              'Họ và tên: ${(order_infomation.orderDeliveries!.first.shipperName == null) ? 'Chưa xác định' : order_infomation.orderDeliveries!.first.shipperName}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Số điện thoại: ${(order_infomation.orderDeliveries!.first.shipperPhone == null) ? 'Chưa xác định' : order_infomation.orderDeliveries!.first.shipperPhone}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Địa chỉ lấy đơn',
                              style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              order_infomation.orderDeliveries!.first.addressString!,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                (order_infomation.orderDeliveries!.first.shipperPhone != null &&
                                        (order_infomation.orderDeliveries!.first.status != null) &&
                                        (order_infomation.orderDeliveries!.first.status!.trim().toLowerCase().compareTo('pending') == 0))
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          Map<String, dynamic>? result =
                                              await centerController.changeDeliveryStatus(widget.order.orderId!, 'dropoff');
                                          setState(() {
                                            isLoading = false;
                                          });
                                          print(result);
                                          if (result != null) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Thông báo'),
                                                  content: Text('Trạng thái vận chuyển đã được cập nhật!'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                        Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                child: DeliveryOrderDetails(
                                                                  order: widget.order,
                                                                ),
                                                                type: PageTransitionType.rightToLeftWithFade));
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Thông báo'),
                                                  content: Text('Có lỗi xảy ra trong quá trình xử lý! Bạn vui lòng thử lại sau'),
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
                                          'Cập nhật trạng thái',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 0,
                                        width: 0,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                const SizedBox(height: 16),
                isHaveReceive
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: textColor, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Chiều về',
                                  style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Text(
                                  //'b',
                                  '${MappingUtils().mapVietnameseDeliveryStatus(order_infomation.orderDeliveries!.last.status!)}',
                                  style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text(
                                  'Nhân viên',
                                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                (order_infomation.orderDeliveries!.last.status == null ||
                                        ((order_infomation.orderDeliveries!.last.status != null) &&
                                            (order_infomation.orderDeliveries!.last.status!.trim().toLowerCase().compareTo('pending') == 0)))
                                    ? ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              title: const Align(
                                                alignment: Alignment.center,
                                                child: Text('Vận chuyển đơn'),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    style: const TextStyle(
                                                      color: textColor,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Tên nhân viên vận chuyển',
                                                      labelStyle: const TextStyle(
                                                        color: textColor,
                                                        fontSize: 18,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey.shade500,
                                                      ),
                                                      // enabledBorder: OutlineInputBorder(
                                                      //     borderSide: BorderSide(
                                                      //         width: 1,
                                                      //         color: Colors.grey.shade400)),
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                                      hintText: 'Nhập họ và tên nhân viên',
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    ),
                                                    cursorColor: textColor.withOpacity(.8),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        deliverShipperName = value;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(height: 8),
                                                  TextField(
                                                    style: const TextStyle(
                                                      color: textColor,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'SĐT nhân viên vận chuyển',
                                                      labelStyle: const TextStyle(
                                                        color: textColor,
                                                        fontSize: 18,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey.shade500,
                                                      ),
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                                      hintText: 'Nhập SĐT nhân viên',
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    ),
                                                    cursorColor: textColor.withOpacity(.8),
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        deliverShipperPhone = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    Map<String, dynamic>? result = await centerController.assignDelivery(
                                                        widget.order.orderId!, 'deliver', deliverShipperName, deliverShipperPhone);
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    if (result != null) {
                                                      Navigator.of(context).pop();
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: const Text('Thông báo'),
                                                            content: Text('Thông tin người vận chuyển đã được cập nhật!'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  Navigator.of(context).pop();
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child: DeliveryOrderDetails(
                                                                            order: widget.order,
                                                                          ),
                                                                          type: PageTransitionType.rightToLeftWithFade));
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
                                                            content: Text('Có lỗi xảy ra trong quá trình xử lý! Bạn vui lòng thử lại sau'),
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
                                                    'Cập nhật',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            side: BorderSide(color: kPrimaryColor.withOpacity(.5), width: 1),
                                          ),
                                          backgroundColor: kPrimaryColor,
                                        ),
                                        child: const Text(
                                          'Cập nhật NV',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 0,
                                        width: 0,
                                      ),
                              ],
                            ),
                            Text(
                              'Họ và tên: ${(order_infomation.orderDeliveries!.last.shipperName == null) ? 'Chưa xác định' : order_infomation.orderDeliveries!.last.shipperName}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Số điện thoại: ${(order_infomation.orderDeliveries!.last.shipperPhone == null) ? 'Chưa xác định' : order_infomation.orderDeliveries!.last.shipperPhone}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Địa chỉ lấy đơn',
                              style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              order_infomation.orderDeliveries!.last.addressString!,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                (order_infomation.orderDeliveries!.last.shipperPhone != null &&
                                        (order_infomation.orderDeliveries!.last.status != null) &&
                                        (order_infomation.orderDeliveries!.last.status!.trim().toLowerCase().compareTo('pending') == 0))
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          Map<String, dynamic>? result =
                                              await centerController.changeDeliveryStatus(widget.order.orderId!, 'deliver');
                                          setState(() {
                                            isLoading = false;
                                          });
                                          print(result);
                                          if (result != null) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Thông báo'),
                                                  content: Text('Trạng thái vận chuyển đã được cập nhật!'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                        Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                child: DeliveryOrderDetails(
                                                                  order: widget.order,
                                                                ),
                                                                type: PageTransitionType.rightToLeftWithFade));
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Thông báo'),
                                                  content: Text('Có lỗi xảy ra trong quá trình xử lý! Bạn vui lòng thử lại sau'),
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
                                          'Cập nhật trạng thái',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 0,
                                        width: 0,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                const SizedBox(height: 15),
                const Text(
                  'Trạng thái đơn hàng',
                  style: TextStyle(color: textColor, fontSize: 21, fontWeight: FontWeight.w600),
                ),
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
                      itemExtentBuilder: (_, __) => MediaQuery.of(context).size.width / _processes.length,
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
                              valueColor: AlwaysStoppedAnimation(Colors.white),
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
                              gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
                            } else {
                              gradientColors = [prevColor, Color.lerp(prevColor, color, 0.5)!];
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

                const SizedBox(height: 15),
                const Text(
                  'Chi tiết đơn hàng',
                  style: TextStyle(color: textColor, fontSize: 21, fontWeight: FontWeight.w600),
                ),
                // Text(
                //   'Chi tiết trong comment bên dưới',
                //   style: TextStyle(
                //     color: textColor,
                //     fontSize: 18,
                //   ),
                // ),
                DetailService(status: OrderUtils().mapVietnameseOrderStatus(order_infomation.status!), order_infomation: order_infomation),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin thanh toán',
                      style: TextStyle(color: textColor, fontSize: 21, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Column(
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
                              style: const TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold),
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
                                    style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    '${PriceUtils().convertFormatPrice(order_infomation.deliveryPrice!.toDouble().round())} đ',
                                    //'${order_infomation.deliveryPrice!.toDouble().round()} đ',
                                    style: const TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold),
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
                            Text(
                              '${order_infomation.orderPayment!.platformFee!.toInt()} đ',
                              style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold),
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
                                    style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    '- ${PriceUtils().convertFormatPrice((order_infomation.orderPayment!.discount! * order_infomation.totalOrderValue!).toInt())} đ',
                                    style: const TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold),
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
                              style: const TextStyle(fontSize: 17, color: kPrimaryColor, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const SizedBox(height: 10)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: Container(
        //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        //   height: 70,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        //     boxShadow: [
        //       BoxShadow(
        //         offset: const Offset(0, -15),
        //         blurRadius: 20,
        //         color: const Color(0xffdadada).withOpacity(0.15),
        //       ),
        //     ],
        //   ),
        //   child: SizedBox(
        //     width: 190,
        //     height: 40,
        //     child: ElevatedButton(
        //       style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: kPrimaryColor),
        //       onPressed: () {},
        //       child: const Text(
        //         'Hoàn tất thanh toán',
        //         style: TextStyle(fontSize: 17),
        //       ),
        //     ),
        //   ),
        // ),
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
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius) // TODO connector start & gradient
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
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius, radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.drawStart != drawStart || oldDelegate.drawEnd != drawEnd;
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
