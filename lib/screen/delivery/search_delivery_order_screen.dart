import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../components/constants/color_constants.dart';
import '../../resource/controller/order_controller.dart';
import '../../resource/model/order.dart';
import 'component/list_widget/order_card.dart';

class SearchDeliveryOrderScreen extends StatefulWidget {
  const SearchDeliveryOrderScreen({super.key});

  @override
  State<SearchDeliveryOrderScreen> createState() =>
      _SearchDeliveryOrderScreenState();
}

class _SearchDeliveryOrderScreenState extends State<SearchDeliveryOrderScreen> {
  OrderController orderController = OrderController();
  List<Order> orderList = [];
  TextEditingController searchController = TextEditingController();
  List<Order> suggetsList = [];
  bool isLoading = false;
  bool isSearch = false;

  void getListSearch(String value) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Wait for getOrderInformation to complete
      List<Order> result = await orderController.getOrderDeliveryList(
          1, 50, null, null, null, null, true, 'Pending');
      setState(() {
        // Update state with loaded data
        suggetsList = result;
        isSearch = true;
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
        title: const Align(
          alignment: Alignment.center,
          child: Text('Tìm kiếm đơn hàng',
              style: TextStyle(color: textColor, fontSize: 27)),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.search_rounded,
                color: kBackgroundColor,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: searchController,
                onChanged: (value) => getListSearch(value),
                textInputAction: TextInputAction.search,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm đơn hàng',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (searchController.text.isEmpty) {
                        setState(() {
                          isSearch = false;
                        });
                      } else {
                        searchController.text = '';
                      }
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.grey.shade100,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.grey.shade100,
                    ),
                  ),
                ),
                style: const TextStyle(color: textColor, height: 1.4),
              ),
            ),
            // FutureBuilder(
            //     future: orderController.getOrderList(
            //         1, 100, searchController.text, null, null, null, null),
            //     builder: ((context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Center(
            //           child: LoadingAnimationWidget.prograssiveDots(
            //               color: kPrimaryColor, size: 50),
            //         );
            //       } else if (snapshot.connectionState == ConnectionState.done) {
            //         orderList = snapshot.data!;
            //         return
            isSearch
                ? isLoading
                    ? Center(
                        child: LoadingAnimationWidget.prograssiveDots(
                            color: kPrimaryColor, size: 50),
                      )
                    : suggetsList.length == 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 100),
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(
                                        'assets/images/empty/empty-data.png')),
                                const SizedBox(height: 10),
                                Text(
                                  'Không có kết quả nào cho ${searchController.text}',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontSize: 15, color: textColor),
                                )
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: suggetsList.length,
                              itemBuilder: ((context, index) {
                                return CardOrder(order: suggetsList[index]);
                              }),
                            ),
                          )
                : isLoading
                    ? Center(
                        child: LoadingAnimationWidget.prograssiveDots(
                            color: kPrimaryColor, size: 50),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 100),
                        child: Column(
                          children: [
                            SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/images/search.png')),
                            const SizedBox(height: 10),
                            const Text(
                              'Bạn có thể tìm kiếm theo tên tiệm giặt, mã đơn hàng hoặc tên dịch vụ',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: textColor),
                            )
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
