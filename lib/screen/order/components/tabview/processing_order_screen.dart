import 'package:flutter/material.dart';
import 'package:washouse_staff/screen/order/components/list_widget/order_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../resource/controller/order_controller.dart';
import '../../../../resource/model/order.dart';
import '../no_order.dart';

class ProcessingOrderScreen extends StatefulWidget {
  const ProcessingOrderScreen({super.key});

  @override
  State<ProcessingOrderScreen> createState() => _ProcessingOrderScreenState();
}

class _ProcessingOrderScreenState extends State<ProcessingOrderScreen> {
  List<Order> processingList = [];
  OrderController orderController = OrderController();
  //List<Order> orderItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // centerArgs = widget.orderId;
    getOrderItems();
  }

  void getOrderItems() async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      // Wait for getOrderInformation to complete
      List<Order> result = await orderController.getOrderList(1, 100, null, null, null, 'processing', null);
      setState(() {
        // Update state with loaded data
        processingList = result;
        print(result.length);
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
          child: LoadingAnimationWidget.twistingDots(
        leftDotColor: const Color(0xFF1A1A3F),
        rightDotColor: const Color(0xFFEA3799),
        size: 200,
      ));
    } else {
      if (processingList.isEmpty) {
        return const NoOrderScreen();
      } else {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: processingList.length,
              itemBuilder: ((context, index) {
                return OrderCard(
                  status: 'Xử lý',
                  order: processingList[index],
                );
              }),
            ),
          ),
        );
      }
    }
  }
}
