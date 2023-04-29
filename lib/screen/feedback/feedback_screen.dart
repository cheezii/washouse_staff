import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/feedback/feedback_order_screen.dart';
import 'package:washouse_staff/screen/feedback/feedback_service_screen.dart';

import '../../components/constants/color_constants.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
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
          title: const Text('Đánh giá',
              style: TextStyle(color: textColor, fontSize: 25)),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: textColor,
                size: 30.0,
              ),
            ),
          ],
          bottom: TabBar(
            unselectedLabelColor: textColor,
            labelColor: textColor,
            tabs: [
              Tab(
                child: Text(
                  'Đơn hàng',
                  style: TextStyle(fontSize: 19),
                ),
              ),
              Tab(
                child: Text(
                  'Dịch vụ',
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          FeedbackOrderScreen(),
          FeedbackServiceScreen(),
        ]),
      ),
    );
  }
}
