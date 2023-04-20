import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:washouse_staff/resource/controller/order_controller.dart';
import 'package:washouse_staff/resource/controller/base_controller.dart';
import 'package:washouse_staff/resource/model/cart_item.dart';
import 'package:washouse_staff/resource/provider/cart_provider.dart';
import 'package:washouse_staff/screen/order/create_order_screen.dart';
import 'package:washouse_staff/utils/cart_util.dart';

import '../../../../components/constants/color_constants.dart';
import '../../../../components/constants/text_constants.dart';

class ChooseShippingMethod extends StatefulWidget {
  const ChooseShippingMethod({super.key});

  @override
  State<ChooseShippingMethod> createState() => _ChooseShippingMethodState();
}

class _ChooseShippingMethodState extends State<ChooseShippingMethod> {
  int? shippingMethod;
  final GlobalKey<FormBuilderFieldState> _dropDownSendWardKey = GlobalKey<FormBuilderFieldState>();
  final GlobalKey<FormBuilderFieldState> _dropDownReceiveWardKey = GlobalKey<FormBuilderFieldState>();
  TextEditingController sendAdressController = TextEditingController();
  TextEditingController receiveAdressController = TextEditingController();
  final GlobalKey<FormState> _formSendAddressKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formReceiveAddressKey = GlobalKey<FormState>();

  String? sendOrderDate;
  String? receiveOrderDate;
  String? sendDistrict;
  String? sendWard;
  String? receiveDistrict;
  String? receiveWard;
  bool isLoadingSendWard = true;
  bool isLoadingReceiveWard = true;

  List sendDistrictList = [];
  List sendWardList = [];
  List receiveDistrictList = [];
  List receiveWardList = [];

  OrderController orderController = OrderController();
  BaseController baseController = BaseController();
  Future getSendDistrictList() async {
    Response response = await get(Uri.parse('$baseUrl/districts'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        sendDistrictList = data['data'];
        isLoadingSendWard = true;
      });
    } else {
      throw Exception("Lỗi khi load Json");
    }
  }

  Future getSendWardsList(String district) async {
    int districtId = int.parse(district);
    Response response = await get(Uri.parse('$baseUrl/districts/$districtId/wards'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        sendWardList = data['data'];
        isLoadingSendWard = true;
      });
    } else {
      throw Exception("Lỗi khi load Json");
    }
  }

  Future getReceiveDistrictList() async {
    Response response = await get(Uri.parse('$baseUrl/districts'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        receiveDistrictList = data['data'];
      });
    } else {
      throw Exception("Lỗi khi load Json");
    }
  }

  Future getReceiveWardsList(String district) async {
    int districtId = int.parse(district);
    Response response = await get(Uri.parse('$baseUrl/districts/$districtId/wards'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        receiveWardList = data['data'];
        isLoadingReceiveWard = true;
      });
    } else {
      throw Exception("Lỗi khi load Json");
    }
  }

  @override
  void initState() {
    getSendDistrictList();
    getReceiveDistrictList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //0 = không chọn, 1 = một chiều đi, 2 = một chiều về, 3 = 2 chiều
    var provider = Provider.of<CartProvider>(context);
    return Scaffold(
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
        title: const Text('Phương thức vận chuyển', style: TextStyle(color: textColor, fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 35,
                        child: Image.asset('assets/images/shipping/ship-di.png'),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Không sử dụng dịch vụ vận chuyển',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Radio(
                    value: 0,
                    groupValue: shippingMethod,
                    onChanged: (newVal) {
                      setState(() {
                        shippingMethod = newVal;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 35,
                        child: Image.asset('assets/images/shipping/dua-den.png'),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Vận chuyển 1 chiều đi',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Radio(
                    value: 1,
                    groupValue: shippingMethod,
                    onChanged: (newVal) {
                      setState(() {
                        shippingMethod = newVal;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 35,
                        child: Image.asset('assets/images/shipping/giao-den.png'),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Vận chuyển 1 chiều về',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Radio(
                    value: 2,
                    groupValue: shippingMethod,
                    onChanged: (newVal) {
                      setState(() {
                        shippingMethod = newVal;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 35,
                        child: Image.asset('assets/images/shipping/shipper.png'),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Vận chuyển 2 chiều',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Radio(
                    value: 3,
                    groupValue: shippingMethod,
                    onChanged: (newVal) {
                      setState(() {
                        shippingMethod = newVal;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              shippingMethod == 1 || shippingMethod == 3
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Địa chỉ lấy đơn',
                          style: TextStyle(fontSize: 18, color: textBoldColor, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Địa chỉ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Form(
                          key: _formSendAddressKey,
                          child: FillingShippingInfo(
                            lableText: 'Địa chỉ',
                            hintText: 'Nhập địa chỉ',
                            controller: sendAdressController,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tỉnh / thành phố',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField(
                          isDense: true,
                          isExpanded: true,
                          items: <String>['Thành phố Hồ Chí Minh', 'Chọn tỉnh / thành phố'].map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                            contentPadding: EdgeInsets.only(left: 5),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                          ),
                          iconSize: 30,
                          hint: const Text('Thành phố Hồ Chí Minh'),
                          style: const TextStyle(color: textColor),
                          onChanged: null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quận / huyện',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 40,
                                  width: 150,
                                  child: DropdownButtonFormField(
                                    items: sendDistrictList.map((item) {
                                      return DropdownMenuItem(
                                        value: item['districtId'].toString(),
                                        child: Text(item['districtName']),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1),
                                      ),
                                      contentPadding: EdgeInsets.only(left: 5),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                    ),
                                    iconSize: 30,
                                    value: sendDistrict,
                                    hint: const Text('Chọn quận/huyện'),
                                    style: const TextStyle(color: textColor),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        sendDistrict = newValue!;
                                        getSendWardsList(newValue);
                                        _dropDownSendWardKey.currentState!.reset();
                                        _dropDownSendWardKey.currentState!.setValue(null);
                                        isLoadingSendWard = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phường / xã',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 40,
                                  width: 200,
                                  child: FormBuilderDropdown(
                                    key: _dropDownSendWardKey,
                                    name: 'Phường/xã',
                                    enabled: isLoadingSendWard,
                                    items: sendWardList.map((item) {
                                      return DropdownMenuItem(
                                        value: item['wardId'].toString(),
                                        child: Text(item['wardName']),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1),
                                      ),
                                      contentPadding: EdgeInsets.only(left: 5),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                    ),
                                    iconSize: 30,
                                    //initialValue: sendWard,
                                    hint: const Text('Chọn phường/xã'),
                                    style: const TextStyle(color: textColor),
                                    onChanged: (newValue) {
                                      setState(() {
                                        sendWard = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
              const SizedBox(height: 10),
              shippingMethod == 2 || shippingMethod == 3
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Địa chỉ trả đơn',
                          style: TextStyle(fontSize: 18, color: textBoldColor, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Địa chỉ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Form(
                          key: _formReceiveAddressKey,
                          child: FillingShippingInfo(
                            lableText: 'Địa chỉ',
                            hintText: 'Nhập địa chỉ',
                            controller: receiveAdressController,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tỉnh / thành phố',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField(
                          isDense: true,
                          isExpanded: true,
                          items: <String>['Thành phố Hồ Chí Minh', 'Chọn tỉnh / thành phố'].map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                            contentPadding: EdgeInsets.only(left: 5),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                          ),
                          iconSize: 30,
                          hint: const Text('Thành phố Hồ Chí Minh'),
                          style: const TextStyle(color: textColor),
                          onChanged: null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quận / huyện',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 40,
                                  width: 150,
                                  child: DropdownButtonFormField(
                                    items: receiveDistrictList.map((item) {
                                      return DropdownMenuItem(
                                        value: item['districtId'].toString(),
                                        child: Text(item['districtName']),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1),
                                      ),
                                      contentPadding: EdgeInsets.only(left: 5),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                    ),
                                    iconSize: 30,
                                    value: receiveDistrict,
                                    hint: const Text('Chọn quận/huyện'),
                                    style: const TextStyle(color: textColor),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        receiveDistrict = newValue!;
                                        _dropDownReceiveWardKey.currentState!.reset();
                                        _dropDownReceiveWardKey.currentState!.setValue(null);
                                        getReceiveWardsList(newValue);
                                        isLoadingReceiveWard = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phường / xã',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 40,
                                  width: 200,
                                  child: FormBuilderDropdown(
                                    key: _dropDownReceiveWardKey,
                                    name: 'Phường/xã',
                                    enabled: isLoadingReceiveWard,
                                    items: receiveWardList.map((item) {
                                      return DropdownMenuItem(
                                        value: item['wardId'].toString(),
                                        child: Text(item['wardName']),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1),
                                      ),
                                      contentPadding: EdgeInsets.only(left: 5),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                    ),
                                    iconSize: 30,
                                    //initialValue: receiveWard,
                                    hint: const Text('Chọn phường/xã'),
                                    style: const TextStyle(color: textColor),
                                    onChanged: (newValue) {
                                      setState(() {
                                        receiveWard = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        height: 70,
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
        child: SizedBox(
          width: 190,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), backgroundColor: kPrimaryColor),
            onPressed: () async {
              await baseController.saveInttoSharedPreference("shippingMethod", shippingMethod);

              print("shippingMethod $shippingMethod");
              if (shippingMethod == 0) {
                baseController.saveDoubletoSharedPreference("deliveryPrice", 0);
                provider.updateDeliveryPrice();
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateOrderScreen()));
                return;
              }
              bool checkValidateFormSend = (shippingMethod == 1 || shippingMethod == 3);
              bool checkValidateFormReceive = (shippingMethod == 2 || shippingMethod == 3);
              bool check = false;
              String? DropoffAddress;
              int? DropoffWardId;
              String? DeliverAddress;
              int? DeliverWardId;
              if (!checkValidateFormSend) {
                check = _formReceiveAddressKey.currentState!.validate();
              } else if (!checkValidateFormReceive) {
                check = _formSendAddressKey.currentState!.validate();
              } else {
                check = (_formSendAddressKey.currentState!.validate() || _formReceiveAddressKey.currentState!.validate());
              }
              // print('sendAdressController.value.text${checkReceiveOrder}');
              // print('sendAdressController.value.te---xt${checkSendOrder}');
              // print('2==${widget.isReceive}');
              // print('1---${widget.isSend}');
              // print(
              //     'receiveAdressController.value.text${sendAdressController.value.text}');
              if (check) {
                print('DropoffAddress - $DropoffAddress');
                print('DropoffWardId - $DropoffWardId');
                print('DeliverAddress - $DeliverAddress');
                print('DeliverWardId - $DeliverWardId');
                print('widget.isSend - ${shippingMethod}');
                //CartItem cartItem = await CartProvider().loadCartItemsFromPrefs();
                DeliveryRequest dropoff = DeliveryRequest();
                DeliveryRequest deliver = DeliveryRequest();
                if (checkValidateFormSend && (shippingMethod == 1 || shippingMethod == 3)) {
                  DropoffAddress = sendAdressController.value.text;
                  DropoffWardId = int.parse(sendWard!);
                  dropoff = DeliveryRequest(deliveryType: false, wardId: DropoffWardId, addressString: DropoffAddress);
                  dynamic dropoffDynamic = dropoff.toJson();
                  String dropoffJson = jsonEncode(dropoffDynamic);
                  baseController.saveStringtoSharedPreference("dropoff", dropoffJson);
                }
                if (checkValidateFormReceive && (shippingMethod == 2 || shippingMethod == 3)) {
                  DeliverAddress = receiveAdressController.value.text;
                  DeliverWardId = int.parse(receiveWard!);
                  deliver = DeliveryRequest(deliveryType: true, wardId: DeliverWardId, addressString: DeliverAddress);
                  dynamic deliverDynamic = deliver.toJson();
                  String deliverJson = jsonEncode(deliverDynamic);
                  baseController.saveStringtoSharedPreference("deliver", deliverJson);
                }
                //double totalWeight = ;

                double totalWeight = 0;
                for (var element in provider.list) {
                  if (element.weight != null) {
                    totalWeight = totalWeight + element.measurement * element.weight!;
                  }
                }
                var totalDeliveryPrice = await orderController.calculateDeliveryPrice(
                    totalWeight, DropoffAddress, DropoffWardId, DeliverAddress, DeliverWardId, shippingMethod!);
                baseController.saveDoubletoSharedPreference("deliveryPrice", totalDeliveryPrice);
                provider.updateDeliveryPrice();
                //baseController.printAllSharedPreferences();
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateOrderScreen()));
              }
            },
            child: const Text(
              'Xác nhận',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}

class FillingShippingInfo extends StatelessWidget {
  final String lableText;
  final String hintText;
  final TextEditingController controller;
  const FillingShippingInfo({
    Key? key,
    required this.lableText,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Không được để trống trường này';
        }
      },
      onSaved: (newValue) {
        controller.text = newValue!;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1),
        ),
        contentPadding: const EdgeInsets.only(left: 5),
        // labelText: lableText,
        // labelStyle: const TextStyle(
        //   color: Colors.black,
        //   fontSize: 18,
        // ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: textNoteColor,
          fontSize: 15,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      controller: controller,
      style: const TextStyle(
        color: textColor,
        fontSize: 15,
      ),
    );
  }
}
