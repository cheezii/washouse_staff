import 'package:flutter/material.dart';

import '../../../../components/constants/color_constants.dart';

class CardBody extends StatelessWidget {
  const CardBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 70,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xfff5f6f9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(
                      'assets/images/placeholder.png'), //ảnh dịch vụ
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      'Tên dịch vụ',
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Phân loại: Loại dịch vụ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'SL: x1',
                        style: const TextStyle(color: textColor, fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Divider(thickness: 1, color: Colors.grey.shade300),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Xem thêm',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Colors.grey.shade500,
            )
          ],
        ),
        Divider(thickness: 1, color: Colors.grey.shade300),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ngày đặt',
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            Text(
              'Ngày',
              style: TextStyle(color: textColor, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thanh toán',
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            Text(
              'Tiền đ',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}
