import 'package:flutter/material.dart';
import 'package:washouse_staff/components/constants/color_constants.dart';

class NoOrderScreen extends StatelessWidget {
  const NoOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 150,
            width: 150,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffD4DEFE),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset('assets/images/empty/empty-data.png'),
          ),
          const SizedBox(height: 15),
          const Text(
            'Không có đơn hàng nào.',
            style: TextStyle(
                fontSize: 20, color: textColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
