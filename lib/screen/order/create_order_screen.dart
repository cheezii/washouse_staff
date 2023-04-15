import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:washouse_staff/resource/controller/base_controller.dart';
import 'package:washouse_staff/resource/model/center.dart';
import 'package:washouse_staff/resource/model/service.dart';
import '../../components/constants/color_constants.dart';
import '../../components/constants/text_constants.dart';
import '../../resource/model/cart_item.dart';
import '../../resource/model/cart_item_view.dart';
import '../../resource/provider/cart_provider.dart';
import 'components/create_order/add_to_cart_dialog.dart';
import 'components/create_order/shipping_method.dart';

class CreateOrderScreen extends StatefulWidget {
  final categoryData;
  final cartList;
  const CreateOrderScreen({super.key, this.categoryData, this.cartList});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  BaseController baseController = BaseController();
  final _dropDownServiceKey = GlobalKey<FormBuilderFieldState>();
  TextEditingController measurementController = TextEditingController();
  List<OrderDetailItem> addedItems = [];
  int? shippingMethod;
  int lengthAddCate = 1;
  bool checkReceiveOrder = false;
  num measurement = 1;

  String? receiveOrderDate;
  String receiveOrderTime = 'Chọn giờ';
  //List<CenterServices>? cateChoosen;
  CenterServices? cateChoosen;
  ServiceCenter? serviceChoosen;
  double priceOfService = 0;
  double measurementOfService = 0;
  double unitPriceOfService = 0;
  String? noteServiceOfCustomer;

  String? chooseDate;
  String? sendOrderTimeSave;

  List<ServiceCenter> serviceList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CartProvider>(context);
    measurementController = TextEditingController(text: measurement.toString());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: textColor,
              size: 27,
            )),
        centerTitle: true,
        title: const Text('Tạo đơn mới', style: TextStyle(color: textColor, fontSize: 24)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thông tin khách hàng:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  contentPadding: EdgeInsets.all(8),
                  labelText: 'Họ và tên',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  hintText: 'Nhập họ và tên khách hàng',
                  hintStyle: TextStyle(
                    color: textNoteColor,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  contentPadding: EdgeInsets.all(8),
                  labelText: 'Số điện thoại',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  hintText: 'Nhập số điện thoại khách hàng',
                  hintStyle: TextStyle(
                    color: textNoteColor,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Giỏ hàng:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

              Consumer<CartProvider>(builder: (context, value, child) {
                //var cart = value.getCart(); //lấy cart để hiện thị ở đây
                //print(provider.list.first.);
                return provider.list.length > 0
                    ? Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: value.list.length,
                            itemBuilder: (context, index) {
                              final item = value.list[index];
                              measurementController = TextEditingController(text: item.measurement.toString());
                              return ListTile(
                                title: Text('${item.serviceName}'),
                                subtitle: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            //measurement--;
                                            provider.updateOrderDetailItemToCart(item, -1);
                                          });
                                        },
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Icon(Icons.remove, color: Colors.white, size: 15),
                                        ),
                                      ),
                                      Flexible(
                                        child: SizedBox(
                                          height: 40,
                                          width: 50,
                                          child: TextField(
                                            controller: measurementController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              setState(() {
                                                measurementController.text = value;
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              contentPadding: EdgeInsets.all(0),
                                            ),
                                            style: const TextStyle(
                                              height: 0,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            //measurement++;
                                            provider.updateOrderDetailItemToCart(item, 1);
                                          });
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor.withOpacity(.8),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Icon(Icons.add, color: Colors.white, size: 15),
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        '${item.unit}', //check uint để hiện kg hay cái
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        'x  ${item.price! / item.measurement}', //check uint để hiện kg hay cái
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text("="),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${item.price} đ',
                                        style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                // Text(
                                //     '${item.measurement} x ${item.unitPrice} = ${item.price}'),
                              );
                            },
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 200, width: 200, child: Image.asset('assets/images/empty/empty-cart.png')),
                            const SizedBox(height: 30),
                            const Text(
                              "Giỏ hàng trống",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
              }),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //_showAddOrderDialog(context);
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AddToCartDialog(cateList: widget.categoryData);
                        }));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
                      foregroundColor: kPrimaryColor.withOpacity(.7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: kPrimaryColor.withOpacity(.5), width: 1),
                      ),
                      backgroundColor: kPrimaryColor),
                  child: Text(
                    'Thêm dịch vụ',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const ShippingMethod(),
              const SizedBox(height: 15),
              // const Text(
              //   'Thông tin vận chuyển:',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              // ),
              // const SizedBox(height: 5),
              const Text(
                'Thời gian gửi đơn',
                style: TextStyle(fontSize: 18, color: textBoldColor, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: textColor, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: textColor, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      isDense: true,
                      isExpanded: true,
                      items: <String>['Hôm nay', 'Ngày mai'].map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 25,
                      ),
                      iconSize: 30,
                      hint: const Text('Chọn ngày'),
                      value: receiveOrderDate,
                      style: const TextStyle(color: textColor),
                      onChanged: (String? newValue) async {
                        setState(() {
                          receiveOrderDate = newValue!;
                        });

                        if (newValue!.compareTo("Hôm nay") == 0) {
                          chooseDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
                        } else if (newValue!.compareTo("Ngày mai") == 0) {
                          chooseDate = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days: 1)));
                        }
                        //print(await baseController.getStringtoSharedPreference("preferredDropoffTime_Date"));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? orderTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (orderTime != null) {
                          setState(() {
                            receiveOrderTime = '${orderTime.hour}:${orderTime.minute}';
                          });
                          String hourSave = orderTime.hour.toString().padLeft(2, '0');
                          String minuteSave = orderTime.minute.toString().padLeft(2, '0');
                          String secondSave = '00';
                          String sendOrderTimeSave = '$hourSave:$minuteSave:$secondSave';
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
                        foregroundColor: kPrimaryColor.withOpacity(.7),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: textColor, width: 1),
                        ),
                        backgroundColor: kBackgroundColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            receiveOrderTime,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.watch_later_outlined,
                            size: 20,
                            color: Colors.grey.shade600,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // const Text(
              //   'Chọn loại dịch vụ:',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              // ),
              // const SizedBox(height: 5),
              // // ListView.builder(
              // //     shrinkWrap: true,
              // //     itemCount: lengthAddCate,
              // //     itemBuilder: ((context, index) {

              // //       return Padding(
              // //         padding: const EdgeInsets.only(bottom: 8),
              // //         child:
              // DropdownButtonFormField(
              //   items: catetList.map((item) {
              //     return DropdownMenuItem(
              //       value: item,
              //       child: Text(item.serviceCategoryName!),
              //     );
              //   }).toList(),
              //   value: cateChoosen,
              //   decoration: const InputDecoration(
              //     contentPadding: EdgeInsets.all(8),
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(width: 1),
              //     ),
              //   ),
              //   hint: const Text(
              //     'Chọn loại dịch vụ',
              //     style: TextStyle(fontSize: 16, color: textNoteColor),
              //   ),
              //   style: const TextStyle(fontSize: 16, color: textColor),
              //   onChanged: (value) {
              //     int index = catetList.indexOf(value as CenterServices);
              //     setState(() {
              //       cateChoosen = value;
              //       serviceList = catetList[index].services as List<ServiceCenter>;
              //       _dropDownServiceKey.currentState!.reset();
              //       _dropDownServiceKey.currentState!.setValue(null);
              //     });
              //   },
              // ),
              // //       );
              // //     })),
              // // const SizedBox(height: 5),
              // // ListTile(
              // //   title: Text('Thêm loại dịch vụ'),
              // //   leading: Icon(
              // //     Icons.add_box_rounded,
              // //     color: kPrimaryColor,
              // //   ),
              // //   onTap: () {
              // //     setState(() {
              // //       if (lengthAddCate < catetList.length) lengthAddCate++;
              // //     });
              // //   },
              // // ),
              // const SizedBox(height: 15),
              // const Text(
              //   'Chọn dịch vụ:',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              // ),
              // const SizedBox(height: 5),
              // FormBuilderDropdown(
              //   key: _dropDownServiceKey,
              //   name: 'Dịch vụ',
              //   items: serviceList.map((item) {
              //     return DropdownMenuItem(
              //       value: item,
              //       child: Text(item.serviceName!),
              //     );
              //   }).toList(),
              //   //value: serviceChoosen,
              //   decoration: const InputDecoration(
              //     contentPadding: EdgeInsets.all(8),
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(width: 1),
              //     ),
              //   ),
              //   hint: const Text(
              //     'Chọn dịch vụ',
              //     style: TextStyle(fontSize: 16, color: textNoteColor),
              //   ),
              //   onChanged: (value) {
              //     setState(() {
              //       serviceChoosen = value;
              //     });
              //   },
              // ),
              // const SizedBox(height: 15),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       'Số lượng/Khối lượng:',
              //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              //     ),
              //     SizedBox(
              //       width: 100,
              //       height: 50,
              //       child: TextFormField(
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           contentPadding: EdgeInsets.all(8),
              //           border: OutlineInputBorder(
              //             borderSide: BorderSide(width: 1),
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              // const SizedBox(height: 15),
              // const Text(
              //   'Ghi chú:',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              // ),
              // const SizedBox(height: 5),
              // SizedBox(
              //   width: double.infinity,
              //   child: TextFormField(
              //     maxLines: 3,
              //     decoration: const InputDecoration(
              //       contentPadding: EdgeInsets.all(8),
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide(width: 1),
              //       ),
              //       hintText: 'Nhập ghi chú',
              //       hintStyle: TextStyle(
              //         color: textNoteColor,
              //       ),
              //     ),
              //     style: const TextStyle(
              //       color: textColor,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15),
              // SizedBox(
              //   height: 40,
              //   width: MediaQuery.of(context).size.width,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //         addedItems.add(serviceChoosen!);
              //       });
              //     },
              //     style: ElevatedButton.styleFrom(
              //         padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
              //         foregroundColor: kPrimaryColor.withOpacity(.7),
              //         elevation: 0,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(20),
              //           side: BorderSide(color: kPrimaryColor.withOpacity(.5), width: 1),
              //         ),
              //         backgroundColor: kPrimaryColor),
              //     child: const Text(
              //       'Thêm vào đơn hàng',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 17,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color(0xffdadada).withOpacity(0.15),
            ),
          ],
        ),
        child: Column(
          children: [
            Consumer<CartProvider>(builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Phí ship:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '${value.deliveryPrice}',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: kPrimaryColor),
                  ),
                ],
              );
            }),
            const SizedBox(height: 5),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng cộng dự kiến:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${value.list.fold(0.0, (sum, item) => sum + item.price!) + value.deliveryPrice}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: kPrimaryColor),
                  ),
                ],
              );
            }),
            const SizedBox(height: 15),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  List<OrderDetailRequest> orderDetailRequests = [];
                  var centerId = await baseController.getInttoSharedPreference("CENTER_ID");
                  for (var element in provider.list) {
                    orderDetailRequests.add(new OrderDetailRequest(
                        serviceId: element.serviceId,
                        measurement: element.measurement,
                        price: element.price,
                        customerNote: element.customerNote,
                        staffNote: element.staffNote));
                  }
                  List<DeliveryRequest> deliveries = [];
                  if (shippingMethod == 1 || shippingMethod == 3) {
                    String? dropoff = await baseController.getStringtoSharedPreference("dropoff");
                    dynamic dropoffDynamic = jsonDecode(dropoff!);
                    var dropoffModel = dropoffDynamic.map((item) => DeliveryRequest.fromJson(item));
                    deliveries.add(dropoffModel);
                  } else if (shippingMethod == 2 || shippingMethod == 3) {
                    String? deliver = await baseController.getStringtoSharedPreference("deliver");
                    dynamic deliverDynamic = jsonDecode(deliver!);
                    var deliverModel = deliverDynamic.map((item) => DeliveryRequest.fromJson(item));
                    deliveries.add(deliverModel);
                  }
                  String? preferredDropoffTime;
                  if (chooseDate != null && sendOrderTimeSave != null && chooseDate != "" && sendOrderTimeSave != "") {
                    preferredDropoffTime = chooseDate! + " " + sendOrderTimeSave!;
                  }
                  CartItem cartItem = CartItem(
                      centerId: centerId,
                      order: new OrderRequest(
                          // customerName: ,
                          // customerAddressString: ,
                          // customerEmail: ,
                          // customerWardId: ,
                          // customerMobile: ,
                          // customerMessage: ,
                          // deliveryType: ,
                          // deliveryPrice: ,
                          // preferredDropoffTime: preferredDropoffTime == null ? DateTime.now() : preferredDropoffTime!
                          ),
                      orderDetails: orderDetailRequests,
                      deliveries: deliveries,
                      paymentMethod: shippingMethod);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             const CustomerInformationcreen()));
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
                    foregroundColor: kPrimaryColor.withOpacity(.7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: kPrimaryColor.withOpacity(.5), width: 1),
                    ),
                    backgroundColor: kPrimaryColor),
                child: const Text(
                  'Đặt dịch vụ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _showAddOrderDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // Return the AlertDialog widget
  //       return AlertDialog(
  //         title: const Align(
  //             alignment: Alignment.center, child: Text('Thêm dịch vụ')),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               const Text(
  //                 'Chọn loại dịch vụ:',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //               ),
  //               const SizedBox(height: 5),
  //               // ListView.builder(
  //               //     shrinkWrap: true,
  //               //     itemCount: lengthAddCate,
  //               //     itemBuilder: ((context, index) {

  //               //       return Padding(
  //               //         padding: const EdgeInsets.only(bottom: 8),
  //               //         child:
  //               DropdownButtonFormField(
  //                 items: catetList.map((item) {
  //                   return DropdownMenuItem(
  //                     value: item,
  //                     child: Text(item.serviceCategoryName!),
  //                   );
  //                 }).toList(),
  //                 value: cateChoosen,
  //                 decoration: const InputDecoration(
  //                   contentPadding: EdgeInsets.all(8),
  //                   border: OutlineInputBorder(
  //                     borderSide: BorderSide(width: 1),
  //                   ),
  //                 ),
  //                 hint: const Text(
  //                   'Chọn loại dịch vụ',
  //                   style: TextStyle(fontSize: 16, color: textNoteColor),
  //                 ),
  //                 style: const TextStyle(fontSize: 16, color: textColor),
  //                 onChanged: (value) {
  //                   int index = catetList.indexOf(value as CenterServices);
  //                   setState(() {
  //                     cateChoosen = value;
  //                     serviceList =
  //                         catetList[index].services as List<ServiceCenter>;
  //                     _dropDownServiceKey.currentState!.reset();
  //                     _dropDownServiceKey.currentState!.setValue(null);
  //                   });
  //                 },
  //               ),
  //               //       );
  //               //     })),
  //               // const SizedBox(height: 5),
  //               // ListTile(
  //               //   title: Text('Thêm loại dịch vụ'),
  //               //   leading: Icon(
  //               //     Icons.add_box_rounded,
  //               //     color: kPrimaryColor,
  //               //   ),
  //               //   onTap: () {
  //               //     setState(() {
  //               //       if (lengthAddCate < catetList.length) lengthAddCate++;
  //               //     });
  //               //   },
  //               // ),
  //               const SizedBox(height: 15),
  //               const Text(
  //                 'Chọn dịch vụ:',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //               ),
  //               const SizedBox(height: 5),
  //               FormBuilderDropdown(
  //                 key: _dropDownServiceKey,
  //                 name: 'Dịch vụ',
  //                 items: serviceList.map((item) {
  //                   return DropdownMenuItem(
  //                     value: item,
  //                     child: Text(item.serviceName!),
  //                   );
  //                 }).toList(),
  //                 //value: serviceChoosen,
  //                 decoration: const InputDecoration(
  //                   contentPadding: EdgeInsets.all(8),
  //                   border: OutlineInputBorder(
  //                     borderSide: BorderSide(width: 1),
  //                   ),
  //                 ),
  //                 hint: const Text(
  //                   'Chọn dịch vụ',
  //                   style: TextStyle(fontSize: 16, color: textNoteColor),
  //                 ),
  //                 onChanged: (value) {
  //                   setState(() {
  //                     serviceChoosen = value;
  //                   });
  //                 },
  //               ),
  //               const SizedBox(height: 15),
  //               const Text(
  //                 'Số lượng/Khối lượng:',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //               ),
  //               const SizedBox(height: 5),
  //               SizedBox(
  //                 width: double.infinity,
  //                 height: 50,
  //                 child: TextFormField(
  //                   keyboardType: TextInputType.number,
  //                   decoration: const InputDecoration(
  //                     contentPadding: EdgeInsets.all(8),
  //                     border: OutlineInputBorder(
  //                       borderSide: BorderSide(width: 1),
  //                     ),
  //                   ),
  //                   onChanged: (value) {
  //                     if (serviceChoosen != null) {
  //                       //Kiểm tra unit Price nằm trong khoảng nào
  //                       double currentPrice = 0;
  //                       double totalCurrentPrice = 0;
  //                       var measurementInput = double.parse(value);

  //                       print(measurementInput);
  //                       if (serviceChoosen!.priceType!) {
  //                         bool check = false;
  //                         for (var itemPrice in serviceChoosen!.prices!) {
  //                           if (measurementInput <= itemPrice.maxValue! &&
  //                               !check) {
  //                             currentPrice = itemPrice.price!.toDouble();
  //                           }
  //                           if (currentPrice > 0) {
  //                             check = true;
  //                           }
  //                         }
  //                         if (serviceChoosen!.minPrice != null &&
  //                             currentPrice * measurementInput <
  //                                 serviceChoosen!.minPrice!) {
  //                           totalCurrentPrice =
  //                               serviceChoosen!.minPrice!.toDouble();
  //                         } else {
  //                           totalCurrentPrice = currentPrice * measurementInput;
  //                         }
  //                       } else {
  //                         totalCurrentPrice = serviceChoosen!.price! *
  //                             measurementInput.toDouble();
  //                         currentPrice = serviceChoosen!.price!.toDouble();
  //                       }
  //                       setState(() {
  //                         measurementOfService = measurementInput;
  //                         priceOfService = totalCurrentPrice;
  //                         unitPriceOfService = currentPrice;
  //                         print(priceOfService);
  //                       });
  //                     }
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 15),
  //               const Text(
  //                 'Ghi chú:',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //               ),
  //               const SizedBox(height: 5),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: TextFormField(
  //                   maxLines: 3,
  //                   decoration: const InputDecoration(
  //                     contentPadding: EdgeInsets.all(8),
  //                     border: OutlineInputBorder(
  //                       borderSide: BorderSide(width: 1),
  //                     ),
  //                     hintText: 'Nhập ghi chú',
  //                     hintStyle: TextStyle(
  //                       color: textNoteColor,
  //                     ),
  //                   ),
  //                   style: const TextStyle(
  //                     color: textColor,
  //                     fontSize: 16,
  //                   ),
  //                   onChanged: (value) {
  //                     setState(() {
  //                       noteServiceOfCustomer = value;
  //                       print(noteServiceOfCustomer);
  //                     });
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 15),
  //               // Row(
  //               //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               //   children: [
  //               //     const Text(
  //               //       'Tổng giá tiền dịch vụ:',
  //               //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //               //     ),
  //               //     Text(
  //               //       '$priceOfService',
  //               //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //               //     )
  //               //   ],
  //               // ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 measurementOfService = 0;
  //                 priceOfService = 0;
  //                 unitPriceOfService = 0;
  //                 noteServiceOfCustomer = null;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //             style: ElevatedButton.styleFrom(
  //               padding: const EdgeInsetsDirectional.symmetric(
  //                   horizontal: 19, vertical: 10),
  //               elevation: 0,
  //               backgroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //                 side: BorderSide(color: cancelledColor, width: 1),
  //               ),
  //             ),
  //             child: Text(
  //               'Hủy bỏ',
  //               style: TextStyle(
  //                 color: cancelledColor,
  //                 fontSize: 17,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 addedItems.add(OrderDetailItem(
  //                   serviceId: serviceChoosen!.serviceId!.toInt(),
  //                   serviceName: serviceChoosen!.serviceName,
  //                   measurement: measurementOfService,
  //                   unitPrice: unitPriceOfService,
  //                   price: priceOfService,
  //                   customerNote: noteServiceOfCustomer,
  //                 ));
  //                 measurementOfService = 0;
  //                 priceOfService = 0;
  //                 unitPriceOfService = 0;
  //                 noteServiceOfCustomer = null;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //             style: ElevatedButton.styleFrom(
  //                 padding: const EdgeInsetsDirectional.symmetric(
  //                     horizontal: 19, vertical: 10),
  //                 foregroundColor: kPrimaryColor.withOpacity(.7),
  //                 elevation: 0,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                   side: BorderSide(
  //                       color: kPrimaryColor.withOpacity(.5), width: 1),
  //                 ),
  //                 backgroundColor: kPrimaryColor),
  //             child: const Text(
  //               'Thêm vào đơn hàng',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 17,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
