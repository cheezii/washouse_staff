import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/resource/controller/tracking_controller.dart';
import 'package:washouse_staff/resource/model/order_infomation.dart';

import '../../../../components/constants/color_constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xfff5f6f9),
                  borderRadius: BorderRadius.circular(15),
                ),
                //child: Image.asset(cart.service.image!),
                child: Image.network(
                    order_infomation.orderedDetails![index].image!),
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
                                          TextFormField(
                                            style: const TextStyle(
                                              color: textColor,
                                            ),
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Số lượng/Khối lượng mới',
                                              labelStyle: const TextStyle(
                                                  color: textBoldColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                              hintStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade500,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 5),
                                              hintText:
                                                  'Nhập Số lượng/Khối lượng mới',
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                            cursorColor:
                                                textColor.withOpacity(.8),
                                            onSaved: (newValue) {},
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                String result =
                                                    await trackingController
                                                        .trackingOrderDetail(
                                                            order_infomation
                                                                .id!,
                                                            order_infomation
                                                                .orderedDetails![
                                                                    index]
                                                                .orderDetailId!);
                                                if (result
                                                        .compareTo("success") ==
                                                    0) {
                                                  //var order =
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Thông báo'),
                                                        content: Text(
                                                            'Dịch vụ đã được cập nhật trạng thái thành công!'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              // Navigator.push(
                                                              //     context,
                                                              //     PageTransition(
                                                              //         child: OrderDetailScreen(
                                                              //           status: 'Xử lý',
                                                              //           order: order_infomation,
                                                              //         ),
                                                              //         type: PageTransitionType.rightToLeftWithFade));
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
                                                        title: const Text(
                                                            'Thông báo'),
                                                        content: Text(
                                                            'Có lỗi xảy ra trong quá trình xử lý! Bạn vui lòng thử lại sau'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
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
                                                'Cập nhật trạng thái',
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
                                                onPressed: () {},
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
                                            SizedBox(
                                              width: 120,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .symmetric(
                                                            horizontal: 19,
                                                            vertical: 10),
                                                    foregroundColor:
                                                        kPrimaryColor
                                                            .withOpacity(.7),
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          color: kPrimaryColor,
                                                          width: 1),
                                                    ),
                                                    backgroundColor:
                                                        kPrimaryColor),
                                                child: const Text(
                                                  'Lưu',
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
                    : SizedBox(height: 0, width: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
