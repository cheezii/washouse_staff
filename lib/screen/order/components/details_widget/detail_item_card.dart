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
                    width: 200,
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
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: kPrimaryColor),
                        onPressed: () {},
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
