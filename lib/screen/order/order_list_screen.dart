import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/screen/order/components/tabview/all_order_screen.dart';
import 'package:washouse_staff/screen/order/components/tabview/cancelled_order_screen.dart';
import 'package:washouse_staff/screen/order/components/tabview/completed_order_screen.dart';
import 'package:washouse_staff/screen/order/components/tabview/confirmed_order_screen.dart';
import 'package:washouse_staff/screen/order/components/tabview/pending_order_screen.dart';
import 'package:washouse_staff/screen/order/components/tabview/processing_order_screen.dart';
import 'package:washouse_staff/screen/order/components/tabview/ready_order_screen.dart';
import 'package:washouse_staff/screen/order/components/tabview/received_order_screen.dart';

import '../../components/constants/color_constants.dart';
import '../../components/constants/text_constants.dart';
import 'search_order_screen.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 8,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: textColor,
                size: 27,
              ),
            ),
            centerTitle: true,
            title: const Text('Đơn hàng',
                style: TextStyle(
                    color: textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const SearchOrderScreen(),
                          type: PageTransitionType.fade));
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.search_rounded,
                    color: textColor,
                    size: 27,
                  ),
                ),
              ),
            ],
            bottom: const TabBar(
              unselectedLabelColor: textColor,
              labelColor: textColor,
              isScrollable: true,
              tabs: [
                Tab(text: 'Tất cả'),
                Tab(text: pending),
                Tab(text: confirmed),
                Tab(text: 'Đã nhận'),
                Tab(text: processing),
                Tab(text: ready),
                Tab(text: completed),
                Tab(text: cancelled),
              ],
            ),
          ),
          body: const TabBarView(children: [
            AllOrderScreen(),
            PendingOrderScreen(),
            ConfirmedOrderScreen(),
            ReceivedOrderScreen(),
            ProcessingOrderScreen(),
            ReadyOrderScreen(),
            CompletedOrderScreen(),
            CancelledOrderScreen()
          ])),
    );
  }
}
