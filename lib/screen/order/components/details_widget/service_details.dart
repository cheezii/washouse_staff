// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:washouse_staff/resource/model/order_infomation.dart';

import 'package:washouse_staff/screen/order/components/details_widget/detail_item_card.dart';

import '../../../../components/constants/color_constants.dart';

class DetailService extends StatelessWidget {
  final String status;
  final Order_Infomation order_infomation;
  const DetailService({Key? key, required this.status, required this.order_infomation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //List<CartItem> cartItems = Provider.of<CartProvider>(context).cartItems;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(
                Icons.local_laundry_service_rounded,
                color: kPrimaryColor,
                size: 24,
              ),
              SizedBox(width: 6),
              Text(
                'Dịch vụ của đơn hàng',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              )
            ],
          ),
          const SizedBox(height: 6),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            //itemCount: demoCarts.length,
            itemCount: order_infomation.orderedDetails!.length,
            itemBuilder: (context, index) {
              return DetailItemCard(status: status, order_infomation: order_infomation, index: index);
            },
          ),
        ],
      ),
    );
  }
}
