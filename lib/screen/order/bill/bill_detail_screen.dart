// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../components/constants/color_constants.dart';

class BillDetailScreen extends StatelessWidget {
  const BillDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            size: 22,
          ),
        ),
        centerTitle: true,
        title: const Text('Chi tiết hóa đơn',
            style: TextStyle(color: textColor, fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1, color: Colors.black, spreadRadius: 1)
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/logo/washouse-favicon.png'),
                    maxRadius: 25,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THE WASHOUSE',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Mã hóa đơn: ',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Địa chỉ: ',
                      style: TextStyle(fontSize: 17),
                      maxLines: 2,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'PHIẾU NHẬN ĐỒ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khách hàng: ',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 5),
                Text(
                  'SĐT khách hàng: ',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 5),
                Text(
                  'Địa chỉ: ',
                  style: TextStyle(fontSize: 17),
                  maxLines: 2,
                ),
              ],
            ),
            separatedLine(),
            Row(
              children: [
                Text(
                  'Dịch vụ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  'số',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              ],
            ),
            separatedLine(),
            const InfoWidget(
              row1data: 'Tên dịch vụ',
              row2data: 'Định lượng',
              row3data: 'Thành tiền',
              isHaveNote: false,
              isColumn: true,
            ),
            separatedLine(),
            const InfoWidget(
              row1data: 'tên',
              row2data: '1',
              row3data: '55.000 đ',
              isHaveNote: false,
              isColumn: false,
            ),
            separatedLine(),
            const InfoWidget(
              row1data: 'tên',
              row2data: '1.0',
              row3data: '60.000 đ',
              isHaveNote: true,
              isColumn: false,
            ),
            separatedLine(),
            CheckoutInfo(
              title: 'Trạng thái thanh toán',
              content: 'trạng thái',
            ),
            const SizedBox(height: 8),
            CheckoutInfo(
              title: 'Tổng cộng',
              content: '115.000 đ',
            ),
            const SizedBox(height: 8),
            CheckoutInfo(
              title: 'Tiền mặt',
              content: '115.000 đ',
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'ngày giờ',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: const [
                  Text(
                    'Cảm ơn quý khách',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Phiếu này chỉ có giá trị trong vòng 30 ngày',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Vui lòng giữ phiếu để nhận lại đồ.',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column separatedLine() {
    return Column(
      children: [
        const SizedBox(height: 5),
        Divider(
          thickness: 1,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class CheckoutInfo extends StatelessWidget {
  final String title;
  final String content;
  const CheckoutInfo({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
        ),
        const Spacer(),
        Text(
          content,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

class InfoWidget extends StatelessWidget {
  final String row1data;
  final String row2data;
  final String row3data;
  final bool isHaveNote;
  final bool isColumn;
  const InfoWidget({
    Key? key,
    required this.row1data,
    required this.row2data,
    required this.row3data,
    required this.isHaveNote,
    required this.isColumn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isColumn
            ? Row(
                children: [
                  SizedBox(
                    width: 180,
                    child: Text(
                      row1data,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      row2data,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    row3data,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: 180,
                    child: Text(
                      row1data,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      row2data,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    row3data,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
        isHaveNote
            ? Column(
                children: [
                  const SizedBox(height: 6),
                  Text(
                    'Ghi chú: ',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ],
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
