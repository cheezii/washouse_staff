import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../../components/constants/color_constants.dart';
import '../../../../utils/price_util.dart';

class DetailItemCard extends StatelessWidget {
  final String status;
  const DetailItemCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
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
              child: Image.network('ảnh'),
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
                    width: 150,
                    child: Text(
                      //cart.service.name!,
                      'tên dịch vụ',
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'SL: x1',
                    style: const TextStyle(color: textColor, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    //'${PriceUtils().convertFormatPrice(cart.service.price!.round() * cart.measurement)} đ',
                    //'${PriceUtils().convertFormatPrice(cart.price!.round())} đ',
                    '${PriceUtils().convertFormatPrice(80000)} đ',
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
                                            width: MediaQuery.of(context).size.width,
                                            child: ElevatedButton(
                                              onPressed: () {},
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
                                                  foregroundColor: cancelledColor.withOpacity(.5),
                                                  shape: RoundedRectangleBorder(
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
    );
  }
}
