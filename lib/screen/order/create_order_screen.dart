import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:washouse_staff/resource/model/center.dart';
import 'package:washouse_staff/resource/model/service.dart';
import '../../components/constants/color_constants.dart';
import '../../components/constants/text_constants.dart';
import '../../resource/model/cart_item.dart';
import '../../resource/model/cart_item_view.dart';
import 'components/create_order/shipping_method.dart';

class CreateOrderScreen extends StatefulWidget {
  final categoryData;
  const CreateOrderScreen({super.key, this.categoryData});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _dropDownServiceKey = GlobalKey<FormBuilderFieldState>();
  List<CenterServices> catetList = [];
  List<OrderDetailItem> addedItems = [];
  int? shippingMethod;
  int lengthAddCate = 1;
  bool checkReceiveOrder = false;

  String? receiveOrderDate;
  String receiveOrderTime = 'Chọn giờ';
  //List<CenterServices>? cateChoosen;
  CenterServices? cateChoosen;
  ServiceCenter? serviceChoosen;
  double priceOfService = 0;
  double measurementOfService = 0;
  double unitPriceOfService = 0;
  String? noteServiceOfCustomer;

  List<ServiceCenter> serviceList = [];

  @override
  void initState() {
    super.initState();
    catetList = widget.categoryData;
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Tạo đơn mới',
            style: TextStyle(color: textColor, fontSize: 24)),
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: addedItems.length,
                itemBuilder: (context, index) {
                  final item = addedItems[index];
                  return ListTile(
                    title: Text('${item.serviceName}'),
                    subtitle: Text(
                        '${item.measurement} x ${item.unitPrice} = ${item.price}'),
                  );
                },
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showAddOrderDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 19, vertical: 10),
                      foregroundColor: kPrimaryColor.withOpacity(.7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: kPrimaryColor.withOpacity(.5), width: 1),
                      ),
                      backgroundColor: kPrimaryColor),
                  child: Text(
                    'Thêm dịch vụ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const ShippingMethod(),
              const SizedBox(height: 15),
              const Text(
                'Thông tin vận chuyển:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text(
                    'Thời gian gửi đơn',
                    style: TextStyle(
                        fontSize: 17,
                        color: textBoldColor,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  FlutterSwitch(
                      value: checkReceiveOrder,
                      width: 50,
                      height: 25,
                      toggleSize: 20,
                      onToggle: (val) {
                        setState(() {
                          checkReceiveOrder = val;
                        });
                      })
                ],
              ),
              const SizedBox(height: 10),
              checkReceiveOrder
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: textColor, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 0, bottom: 0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: textColor, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            isDense: true,
                            isExpanded: true,
                            items: <String>['Hôm nay', 'Ngày mai']
                                .map((String item) {
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
                            onChanged: (String? newValue) {
                              setState(() {
                                receiveOrderDate = newValue!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              TimeOfDay? orderTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (orderTime != null) {
                                setState(() {
                                  receiveOrderTime =
                                      '${orderTime.hour}:${orderTime.minute}';
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 19, vertical: 10),
                              foregroundColor: kPrimaryColor.withOpacity(.7),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: textColor, width: 1),
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
                    )
                  : Container(),

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
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Phí ship:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Text(
                  'Tiền đ',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng dự kiến:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${addedItems.fold(0.0, (sum, item) => sum + item.price!)}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             const CustomerInformationcreen()));
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 19, vertical: 10),
                    foregroundColor: kPrimaryColor.withOpacity(.7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: kPrimaryColor.withOpacity(.5), width: 1),
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

  void _showAddOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return the AlertDialog widget
        return AlertDialog(
          title: const Align(alignment: Alignment.center,child: Text('Thêm dịch vụ')),
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Chọn loại dịch vụ:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                // ListView.builder(
                //     shrinkWrap: true,
                //     itemCount: lengthAddCate,
                //     itemBuilder: ((context, index) {

                //       return Padding(
                //         padding: const EdgeInsets.only(bottom: 8),
                //         child:
                DropdownButtonFormField(
                  items: catetList.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item.serviceCategoryName!),
                    );
                  }).toList(),
                  value: cateChoosen,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                  hint: const Text(
                    'Chọn loại dịch vụ',
                    style: TextStyle(fontSize: 16, color: textNoteColor),
                  ),
                  style: const TextStyle(fontSize: 16, color: textColor),
                  onChanged: (value) {
                    int index = catetList.indexOf(value as CenterServices);
                    setState(() {
                      cateChoosen = value;
                      serviceList =
                          catetList[index].services as List<ServiceCenter>;
                      _dropDownServiceKey.currentState!.reset();
                      _dropDownServiceKey.currentState!.setValue(null);
                    });
                  },
                ),
                //       );
                //     })),
                // const SizedBox(height: 5),
                // ListTile(
                //   title: Text('Thêm loại dịch vụ'),
                //   leading: Icon(
                //     Icons.add_box_rounded,
                //     color: kPrimaryColor,
                //   ),
                //   onTap: () {
                //     setState(() {
                //       if (lengthAddCate < catetList.length) lengthAddCate++;
                //     });
                //   },
                // ),
                const SizedBox(height: 15),
                const Text(
                  'Chọn dịch vụ:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                FormBuilderDropdown(
                  key: _dropDownServiceKey,
                  name: 'Dịch vụ',
                  items: serviceList.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item.serviceName!),
                    );
                  }).toList(),
                  //value: serviceChoosen,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                  hint: const Text(
                    'Chọn dịch vụ',
                    style: TextStyle(fontSize: 16, color: textNoteColor),
                  ),
                  onChanged: (value) {
                    setState(() {
                      serviceChoosen = value;
                    });
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Số lượng/Khối lượng:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                        ),
                        onChanged: (value) {
                          if (serviceChoosen != null) {
                            //Kiểm tra unit Price nằm trong khoảng nào
                            double currentPrice = 0;
                            double totalCurrentPrice = 0;
                            var measurementInput = double.parse(value);

                            print(measurementInput);
                            if (serviceChoosen!.priceType!) {
                              bool check = false;
                              for (var itemPrice in serviceChoosen!.prices!) {
                                if (measurementInput <= itemPrice.maxValue! &&
                                    !check) {
                                  currentPrice = itemPrice.price!.toDouble();
                                }
                                if (currentPrice > 0) {
                                  check = true;
                                }
                              }
                              if (serviceChoosen!.minPrice != null &&
                                  currentPrice * measurementInput <
                                      serviceChoosen!.minPrice!) {
                                totalCurrentPrice =
                                    serviceChoosen!.minPrice!.toDouble();
                              } else {
                                totalCurrentPrice =
                                    currentPrice * measurementInput;
                              }
                            } else {
                              totalCurrentPrice = serviceChoosen!.price! *
                                  measurementInput.toDouble();
                              currentPrice = serviceChoosen!.price!.toDouble();
                            }
                            setState(() {
                              measurementOfService = measurementInput;
                              priceOfService = totalCurrentPrice;
                              unitPriceOfService = currentPrice;
                              print(priceOfService);
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Ghi chú:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      hintText: 'Nhập ghi chú',
                      hintStyle: TextStyle(
                        color: textNoteColor,
                      ),
                    ),
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      setState(() {
                        noteServiceOfCustomer = value;
                        print(noteServiceOfCustomer);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text(
                //       'Tổng giá tiền dịch vụ:',
                //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                //     ),
                //     Text(
                //       '$priceOfService',
                //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  measurementOfService = 0;
                  priceOfService = 0;
                  unitPriceOfService = 0;
                  noteServiceOfCustomer = null;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 19, vertical: 10),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: cancelledColor, width: 1),
                  ),
                  ),
              child: Text(
                'Hủy bỏ',
                style: TextStyle(
                  color: cancelledColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  addedItems.add(OrderDetailItem(
                    serviceId: serviceChoosen!.serviceId!.toInt(),
                    serviceName: serviceChoosen!.serviceName,
                    measurement: measurementOfService,
                    unitPrice: unitPriceOfService,
                    price: priceOfService,
                    customerNote: noteServiceOfCustomer,
                  ));
                  measurementOfService = 0;
                  priceOfService = 0;
                  unitPriceOfService = 0;
                  noteServiceOfCustomer = null;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 19, vertical: 10),
                  foregroundColor: kPrimaryColor.withOpacity(.7),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: kPrimaryColor.withOpacity(.5), width: 1),
                  ),
                  backgroundColor: kPrimaryColor),
              child: const Text(
                'Thêm vào đơn hàng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
