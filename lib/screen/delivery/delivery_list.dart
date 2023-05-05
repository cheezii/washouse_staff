import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/resource/controller/order_controller.dart';
import 'package:washouse_staff/screen/delivery/search_delivery_order_screen.dart';

import '../../components/constants/color_constants.dart';
import '../../resource/model/order.dart';
import '../order/components/no_order.dart';
import 'component/list_widget/order_card.dart';

class ListDeliveryScreen extends StatefulWidget {
  const ListDeliveryScreen({Key? key}) : super(key: key);

  @override
  State<ListDeliveryScreen> createState() => _ListDeliveryScreenState();
}

class _ListDeliveryScreenState extends State<ListDeliveryScreen> {
  OrderController orderController = OrderController();
  List<Order> orderList = [];

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
            size: 24,
          ),
        ),
        centerTitle: true,
        title: const Text('Vận chuyển',
            style: TextStyle(color: textColor, fontSize: 25)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: const SearchDeliveryOrderScreen(),
                      type: PageTransitionType.fade));
            },
            icon: const Icon(
              Icons.search,
              color: textColor,
              size: 30.0,
            ),
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16),
      //     child: ListView.builder(
      //       shrinkWrap: true,
      //       physics: const NeverScrollableScrollPhysics(),
      //       itemCount: 3,
      //       itemBuilder: ((context, index) {
      //         return CardOrder();
      //       }),
      //     ),
      //   ),
      // ),
      body: FutureBuilder(
        future: orderController.getOrderDeliveryList(
            1, 50, null, null, null, null, true, 'Pending'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                  color: kPrimaryColor, size: 50),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            orderList = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderList.length,
                  itemBuilder: ((context, index) {
                    return CardOrder(order: orderList[index]);
                    //return CardOrder();
                  }),
                ),
              ),
            );
          } else {
            return const Center(child: NoOrderScreen());
          }
        },
      ),
    );
  }
}
