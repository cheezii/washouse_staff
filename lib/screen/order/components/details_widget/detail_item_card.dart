import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/basic.dart' as basic;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/resource/controller/order_controller.dart';
import 'package:washouse_staff/resource/controller/tracking_controller.dart';
import 'package:washouse_staff/resource/model/order_infomation.dart';

import '../../../../components/constants/color_constants.dart';
import '../../../../utils/order_util.dart';
import '../../../../utils/price_util.dart';
import '../../order_detail_screen.dart';

class DetailItemCard extends StatelessWidget {
  final String status;
  final Order_Infomation order_infomation;
  final int index;
  DetailItemCard(
      {super.key,
      required this.status,
      required this.order_infomation,
      required this.index});
  TrackingController trackingController = TrackingController();
  OrderController orderController = OrderController();
  double? newMeasurement;
  String? staffNote;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          // SizedBox(
          //   width: 80,
          //   child: AspectRatio(
          //     aspectRatio: 0.88,
          //     child: Container(
          //       padding: const EdgeInsets.all(10),
          //       decoration: BoxDecoration(
          //         color: const Color(0xfff5f6f9),
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //       //child: Image.asset(cart.service.image!),
          //       child: Image.network(order_infomation.orderedDetails![index].image!),
          //     ),
          //   ),
          // ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              order_infomation.orderedDetails![index].image!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return basic.Center(
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
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: status == 'Xử lý' ? 150 : 200,
                      child: Text(
                        //cart.service.name!,
                        '${order_infomation.orderedDetails![index].serviceName}',
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order_infomation.orderedDetails![index].unit!
                                  .toLowerCase()
                                  .trim() ==
                              'kg'
                          ? 'KL: ${order_infomation.orderedDetails![index].measurement} kg'
                          : 'SL: ${order_infomation.orderedDetails![index].measurement!.round()} ${order_infomation.orderedDetails![index].unit!.toLowerCase()}',
                      style: const TextStyle(color: textColor, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      //'${PriceUtils().convertFormatPrice(cart.service.price!.round() * cart.measurement)} đ',
                      //'${PriceUtils().convertFormatPrice(cart.price!.round())} đ',
                      '${PriceUtils().convertFormatPrice(order_infomation.orderedDetails![index].price!.toInt())} đ',
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    (order_infomation.orderedDetails![index].status != null)
                        ? Text(
                            'Trạng thái: ${OrderUtils().mapVietnameseOrderDetailStatus(order_infomation.orderedDetails![index].status!)}',
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                  ],
                ),
                const Spacer(),
                status == 'Xử lý'
                    ? SizedBox(
                        width: 90,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: kPrimaryColor),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      title: const Align(
                                        alignment: Alignment.center,
                                        child: Text('Cập nhật đơn hàng'),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          order_infomation
                                                      .orderedDetails![index]
                                                      .status!
                                                      .toLowerCase() !=
                                                  'completed'
                                              ? SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  'Thông báo'),
                                                            ),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                    'Trạng thái hiện tại của món hàng là "${OrderUtils().mapVietnameseOrderDetailStatus(order_infomation.orderedDetails![index].status!)}"!'),
                                                                Text(
                                                                    'Bạn có chắc chắn muốn cập nhật trạng thái của món hàng đến trạng thái tiếp theo?'),
                                                              ],
                                                            ),
                                                            actions: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      String result = await trackingController.trackingOrderDetail(
                                                                          order_infomation
                                                                              .id!,
                                                                          order_infomation
                                                                              .orderedDetails![index]
                                                                              .orderDetailId!);
                                                                      if (result
                                                                              .compareTo("success") ==
                                                                          0) {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        await showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: const Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text('Thông báo'),
                                                                              ),
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                              ),
                                                                              content: Text('Dịch vụ đã được cập nhật trạng thái thành công!'),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                    Navigator.of(context).pop();
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        PageTransition(
                                                                                            child: OrderDetailScreen(
                                                                                              orderId: order_infomation.id!,
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
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        await showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: const Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text('Thông báo'),
                                                                              ),
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                              ),
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
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      return;
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
                                                                        foregroundColor: kPrimaryColor.withOpacity(.7),
                                                                        elevation: 0,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                          side: BorderSide(
                                                                              color: kPrimaryColor,
                                                                              width: 1),
                                                                        ),
                                                                        backgroundColor: kPrimaryColor),
                                                                    child:
                                                                        const Text(
                                                                      'OK',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
                                                                        elevation: 0,
                                                                        foregroundColor: cancelledColor.withOpacity(.5),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                          side: BorderSide(
                                                                              color: cancelledColor,
                                                                              width: 1),
                                                                        ),
                                                                        backgroundColor: cancelledColor),
                                                                    child:
                                                                        const Text(
                                                                      'Hủy',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .symmetric(
                                                                    horizontal:
                                                                        19,
                                                                    vertical:
                                                                        10),
                                                            foregroundColor:
                                                                kPrimaryColor
                                                                    .withOpacity(
                                                                        .7),
                                                            elevation: 0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              side: BorderSide(
                                                                  color:
                                                                      kPrimaryColor,
                                                                  width: 1),
                                                            ),
                                                            backgroundColor:
                                                                Colors.white),
                                                    child: const Text(
                                                      'Cập nhật trạng thái',
                                                      style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(height: 15),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                //Navigator.of(context).pop();
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              title:
                                                                  const Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Cập nhật số lượng/khối lượng'),
                                                              ),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  TextFormField(
                                                                    style:
                                                                        const TextStyle(
                                                                      color:
                                                                          textColor,
                                                                    ),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Số lượng/Khối lượng mới',
                                                                      labelStyle: const TextStyle(
                                                                          color:
                                                                              textBoldColor,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      hintStyle:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade500,
                                                                      ),
                                                                      contentPadding:
                                                                          EdgeInsets.symmetric(
                                                                              vertical: 5),
                                                                      hintText:
                                                                          'Nhập Số lượng/Khối lượng mới',
                                                                      floatingLabelBehavior:
                                                                          FloatingLabelBehavior
                                                                              .always,
                                                                    ),
                                                                    cursorColor:
                                                                        textColor
                                                                            .withOpacity(.8),
                                                                    onChanged:
                                                                        (newValue) {
                                                                      if (newValue
                                                                          .isNotEmpty) {
                                                                        newMeasurement =
                                                                            double.tryParse(newValue);
                                                                      } // Convert input to double
                                                                    },
                                                                    keyboardType: const TextInputType
                                                                            .numberWithOptions(
                                                                        decimal:
                                                                            true), // Set keyboard type to number with decimal option
                                                                    inputFormatters: <
                                                                        TextInputFormatter>[
                                                                      FilteringTextInputFormatter
                                                                          .allow(
                                                                              RegExp(r'^\d+\.?\d{0,1}')), // Allow only digits with optional decimal up to 1 decimal places
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          20),
                                                                  TextFormField(
                                                                    style:
                                                                        const TextStyle(
                                                                      color:
                                                                          textColor,
                                                                    ),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Ghi chú của nhân viên',
                                                                      labelStyle: const TextStyle(
                                                                          color:
                                                                              textBoldColor,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      hintStyle:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade500,
                                                                      ),
                                                                      contentPadding:
                                                                          EdgeInsets.symmetric(
                                                                              vertical: 5),
                                                                      hintText:
                                                                          'Nhập ghi chú của bạn',
                                                                      floatingLabelBehavior:
                                                                          FloatingLabelBehavior
                                                                              .always,
                                                                    ),
                                                                    cursorColor:
                                                                        textColor
                                                                            .withOpacity(.8),
                                                                    onChanged:
                                                                        (newValue) {
                                                                      staffNote =
                                                                          newValue;
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          120,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
                                                                            elevation: 0,
                                                                            foregroundColor: cancelledColor.withOpacity(.5),
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                              side: BorderSide(color: cancelledColor, width: 1),
                                                                            ),
                                                                            backgroundColor: cancelledColor),
                                                                        child:
                                                                            const Text(
                                                                          'Hủy',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          120,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          if (staffNote != null &&
                                                                              staffNote!.isEmpty) {
                                                                            staffNote =
                                                                                null;
                                                                          }
                                                                          String result = await orderController.updateMeasurementOrderDetail(
                                                                              order_infomation.id!,
                                                                              order_infomation.orderedDetails![index].orderDetailId!,
                                                                              newMeasurement,
                                                                              staffNote);
                                                                          if (result.compareTo("success") ==
                                                                              0) {
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pop();
                                                                            await showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: const Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Text('Thông báo'),
                                                                                  ),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                  ),
                                                                                  content: Text('Dịch vụ đã được cập nhật thành công!'),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                        Navigator.of(context).pop();
                                                                                        Navigator.push(
                                                                                            context,
                                                                                            PageTransition(
                                                                                                child: OrderDetailScreen(
                                                                                                  orderId: order_infomation.id!,
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
                                                                            Navigator.of(context).pop();
                                                                            await showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: const Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Text('Thông báo'),
                                                                                  ),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                  ),
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
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          return;
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
                                                                            foregroundColor: kPrimaryColor.withOpacity(.7),
                                                                            elevation: 0,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                              side: BorderSide(color: kPrimaryColor, width: 1),
                                                                            ),
                                                                            backgroundColor: kPrimaryColor),
                                                                        child:
                                                                            const Text(
                                                                          'Lưu',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .symmetric(
                                                          horizontal: 19,
                                                          vertical: 10),
                                                  foregroundColor: kPrimaryColor
                                                      .withOpacity(.7),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    side: BorderSide(
                                                        color: kPrimaryColor,
                                                        width: 1),
                                                  ),
                                                  backgroundColor:
                                                      Colors.white),
                                              child: const Text(
                                                'Cập nhật số lượng/khối lượng',
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .symmetric(
                                                            horizontal: 19,
                                                            vertical: 10),
                                                    elevation: 0,
                                                    foregroundColor:
                                                        cancelledColor
                                                            .withOpacity(.5),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          color: cancelledColor,
                                                          width: 1),
                                                    ),
                                                    backgroundColor:
                                                        cancelledColor),
                                                child: const Text(
                                                  'Hủy',
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
                                      ],
                                    ));
                          },
                          child: const Text(
                            'Cập nhật',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    : const SizedBox(height: 0, width: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
