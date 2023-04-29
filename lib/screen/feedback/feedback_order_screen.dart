import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/screen/feedback/feedback_details_screen.dart';

import '../../components/constants/color_constants.dart';
import 'component/feedback_widget.dart';

class FeedbackOrderScreen extends StatefulWidget {
  const FeedbackOrderScreen({super.key});

  @override
  State<FeedbackOrderScreen> createState() => _FeedbackOrderScreenState();
}

class _FeedbackOrderScreenState extends State<FeedbackOrderScreen> {
  bool isMore = true;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      itemCount: 4,
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        return FeedbackWidget(
          avatar: '',
          name: 'họ tên',
          orderID: 'mã đơn',
          date: 'ngày tháng',
          content:
              'nội dung abcdapwofpanwinfoaniehtoianornoenfpwenfpiawneoigaubwpoeubtwioenoanknsldkfbnaouweonk ăirhioinoinpbubfoianwijiodkpn',
          press: () => setState(() {
            isMore = !isMore;
          }),
          isLess: isMore,
          onTap: () => Navigator.push(
              context,
              PageTransition(
                  child: const FeedbackDetailsScreen(),
                  type: PageTransitionType.fade)),
        );
      }),
      separatorBuilder: (context, index) {
        return Divider(
          thickness: 1,
          color: Colors.grey.shade300,
        );
      },
    );
  }
}
