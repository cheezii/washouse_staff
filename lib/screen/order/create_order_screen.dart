import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'dart:ui';
import 'package:flutter/src/widgets/basic.dart' as basic;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:washouse_staff/resource/controller/base_controller.dart';
import 'package:washouse_staff/resource/controller/center_controller.dart';
import 'package:washouse_staff/resource/controller/order_controller.dart';
import 'package:washouse_staff/resource/model/center.dart';
import 'package:washouse_staff/resource/model/service.dart';
import 'package:washouse_staff/screen/order/order_detail_screen.dart';
import '../../components/constants/color_constants.dart';
import '../../components/constants/text_constants.dart';
import '../../resource/model/cart_item.dart';
import '../../resource/model/cart_item_view.dart';
import '../../resource/provider/cart_provider.dart';
import '../../utils/custom_timer_picker_util.dart';
import '../../utils/price_util.dart';
import 'components/create_order/add_to_cart_dialog.dart';
import 'components/create_order/choose_shipping_method.dart';
import 'components/create_order/shipping_method.dart';

class CreateOrderScreen extends StatefulWidget {
  final categoryData;
  final cartList;
  const CreateOrderScreen({super.key, this.categoryData, this.cartList});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final GlobalKey<FormBuilderFieldState> _dropDownWardKey =
      GlobalKey<FormBuilderFieldState>();
  BaseController baseController = BaseController();
  OrderController orderController = OrderController();
  CenterController centerController = CenterController();
  TextEditingController measurementController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  GlobalKey<FormState> _formCusNameKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formPhoneNumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formEmailKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formAddressKey = GlobalKey<FormState>();
  final typePhoneNum = RegExp(r'(((\+|)84)|0)(3|5|7|8|9)+([0-9]{8})\b');
  final typeEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  int? shippingMethod;
  int lengthAddCate = 1;
  bool checkReceiveOrder = false;
  bool isLoadingWard = true;
  bool checkSendOrder = false;
  num measurement = 1;
  int? payment;
  int? h, m;

  TimeOfDay? minToday;
  TimeOfDay? maxToday;
  TimeOfDay? minTomorrow;
  TimeOfDay? maxTomorrow;

  bool isCalculateShipFee = false;

  String? DropoffAddress;
  int? DropoffWardId;
  String? DeliverAddress;
  int? DeliverWardId;

  //List<CenterServices>? cateChoosen;
  CenterServices? cateChoosen;
  ServiceCenter? serviceChoosen;
  LaundryCenter center = LaundryCenter();

  double priceOfService = 0;
  double measurementOfService = 0;
  double unitPriceOfService = 0;

  String? noteServiceOfCustomer;
  String? receiveOrderDate;
  String receiveOrderTime = 'Chọn giờ';
  String? chooseDate;
  String? sendOrderTimeSave;
  String? cusDistrict;
  String? cusWard;

  List<ServiceCenter> serviceList = [];
  List districtList = [];
  List wardList = [];
  List<OrderDetailItem> addedItems = [];

  final GlobalKey<FormBuilderFieldState> _dropDownSendWardKey =
      GlobalKey<FormBuilderFieldState>();
  final GlobalKey<FormBuilderFieldState> _dropDownReceiveWardKey =
      GlobalKey<FormBuilderFieldState>();
  TextEditingController sendAdressController = TextEditingController();
  TextEditingController receiveAdressController = TextEditingController();
  final GlobalKey<FormState> _formSendAddressKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formReceiveAddressKey = GlobalKey<FormState>();

  String dropoffJson = "";
  String deliverJson = "";
  String? sendOrderDate;
  String? sendDistrict;
  String? sendWard;
  String? receiveDistrict;
  String? receiveWard;
  bool isLoadingSendWard = true;
  bool isLoadingReceiveWard = true;
  bool isLoadingDeliveryPrice = false;

  double totalDeliveryPrice = 0;

  List sendDistrictList = [];
  List sendWardList = [];
  List receiveDistrictList = [];
  List receiveWardList = [];

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
    Response response =
        await get(Uri.parse('$baseUrl/districts/$districtId/wards'));
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
    Response response =
        await get(Uri.parse('$baseUrl/districts/$districtId/wards'));
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

  Future getDistrictList() async {
    Response response = await get(Uri.parse('$baseUrl/districts'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        districtList = data['data'];
      });
    } else {
      throw Exception("Lỗi khi load Json");
    }
  }

  Future getWardsList(String district) async {
    int districtId = int.parse(district);
    Response response =
        await get(Uri.parse('$baseUrl/districts/$districtId/wards'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        wardList = data['data'];
        isLoadingWard = true;
      });
    } else {
      throw Exception("Lỗi khi load Json");
    }
  }

  Future loadData() async {
    var data = await baseController.getInttoSharedPreference("paymentMethod");
    final centerId = await baseController.getInttoSharedPreference("CENTER_ID");
    final centerInfo = await centerController.getCenterById(centerId!);
    setState(() {
      payment = data;
      shippingMethod = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    getDistrictList();
    getSendDistrictList();
    getReceiveDistrictList();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    bool checkHasDelivery = true;
    if (center.hasDelivery = true) {
      checkHasDelivery = true;
    } else {
      checkHasDelivery = false;
    }
    var provider = Provider.of<CartProvider>(context);
    measurementController = TextEditingController(text: measurement.toString());
    // if (isLoadingDeliveryPrice) {
    //   return Stack(
    //     fit: StackFit.expand,
    //     children: [
    //       Positioned.fill(
    //         child: BackdropFilter(
    //           filter: ImageFilter.blur(
    //             sigmaX: 10.0,
    //             sigmaY: 10.0,
    //           ),
    //           child: Container(
    //             color: Colors.black.withOpacity(0.2),
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         child: Center(
    //           child: Container(
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.circular(15),
    //             ),
    //             width: 100,
    //             height: 100,
    //             child: LoadingAnimationWidget.threeRotatingDots(
    //                 color: kPrimaryColor, size: 50),
    //           ),
    //         ),
    //       )
    //     ],
    //   );
    // } else {
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
              Form(
                key: _formCusNameKey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Không được để trống trường này';
                    }
                  },
                  onSaved: (newValue) {
                    nameController.text = newValue!;
                  },
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
                  controller: nameController,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formPhoneNumberKey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Không được để trống trường này';
                    }
                    if (!typePhoneNum.hasMatch(value)) {
                      return 'Số điện thoại phải có mười số';
                    }
                  },
                  onSaved: (newValue) {
                    phoneController.text = newValue!;
                  },
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
                  controller: phoneController,
                ),
              ),
              const SizedBox(height: 15),
              Form(
                key: _formEmailKey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Không được để trống trường này!';
                    }
                    if (!typeEmail.hasMatch(value)) {
                      return 'Không khớp định dạng email!';
                    }
                  },
                  onSaved: (newValue) {
                    emailController.text = newValue!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    hintText: 'Nhập email khách hàng',
                    hintStyle: TextStyle(
                      color: textNoteColor,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                  controller: emailController,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formAddressKey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Không được để trống trường này';
                    }
                  },
                  onSaved: (newValue) {
                    addressController.text = newValue!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    labelText: 'Địa chỉ',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    hintText: 'Nhập địa chỉ của khách hàng',
                    hintStyle: TextStyle(
                      color: textNoteColor,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                  controller: addressController,
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
                items: <String>[
                  'Thành phố Hồ Chí Minh',
                  'Chọn tỉnh / thành phố'
                ].map((String item) {
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
                          items: districtList.map((item) {
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
                          value: cusDistrict,
                          hint: const Text('Chọn quận/huyện'),
                          style: const TextStyle(color: textColor),
                          onChanged: (String? newValue) {
                            setState(() {
                              cusDistrict = newValue!;
                              getWardsList(newValue);
                              _dropDownWardKey.currentState!.reset();
                              _dropDownWardKey.currentState!.setValue(null);
                              isLoadingWard = false;
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
                          key: _dropDownWardKey,
                          name: 'Phường/xã',
                          enabled: isLoadingWard,
                          items: wardList.map((item) {
                            return DropdownMenuItem(
                              value: item['wardId'].toString(),
                              child: Text(item['wardName']),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Không được để trống trường này';
                            }
                          },
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
                              cusWard = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'Giỏ hàng:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

              Consumer<CartProvider>(builder: (context, value, child) {
                //var cart = value.getCart(); //lấy cart để hiện thị ở đây
                //print(provider.list.first.);
                return
                    // provider.list.length > 0
                    //     ?
                    Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.list.length,
                      itemBuilder: (context, index) {
                        final item = value.list[index];
                        int? id = item.serviceId;
                        bool checkUnit;
                        double measurement = item.measurement;

                        if (item.unit == 'kg') {
                          checkUnit = true;
                        } else {
                          checkUnit = false;
                        }
                        return Dismissible(
                          key: Key(id.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xffffe6e6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: const [
                                Spacer(),
                                Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) {
                            //provider.clear(id!);
                            value.removeItemFromCart(item);
                          },
                          child: ListTile(
                            title: Text('${index + 1}. ${item.serviceName}'),
                            subtitle: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        //measurement--;
                                        provider.updateOrderDetailItemToCart(
                                            item, -1);
                                      });
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(Icons.remove,
                                          color: Colors.white, size: 15),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: basic.SizedBox(
                                      width: 25,
                                      child: Text(
                                        checkUnit
                                            ? '$measurement'
                                            : '${measurement.round()}',
                                        style:
                                            const TextStyle(color: textColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        //measurement++;
                                        provider.updateOrderDetailItemToCart(
                                            item, 1);
                                      });
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor.withOpacity(.8),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(Icons.add,
                                          color: Colors.white, size: 15),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  basic.SizedBox(
                                    width: 30,
                                    child: Text(
                                      '${item.unit}', //check uint để hiện kg hay cái
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  SizedBox(
                                    width: 90,
                                    child: Text(
                                      'x  ${PriceUtils().convertFormatPrice((item.price! / item.measurement).toInt())} đ', //check uint để hiện kg hay cái
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("="),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${PriceUtils().convertFormatPrice((item.price!).toInt())} đ',
                                    style: const TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            // Text(
                            //     '${item.measurement} x ${item.unitPrice} = ${item.price}'),
                          ),
                        );
                      },
                    ),
                  ],
                );
                // :
                // Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         SizedBox(
                //             height: 200,
                //             width: 200,
                //             child: Image.asset(
                //                 'assets/images/empty/empty-cart.png')),
                //         const SizedBox(height: 30),
                //         const Text(
                //           "Giỏ hàng trống",
                //           style: TextStyle(
                //               fontSize: 19, fontWeight: FontWeight.w500),
                //         ),
                //       ],
                //     ),
                //   );
              }),
              TextButton(
                onPressed: () {
                  //_showAddOrderDialog(context);
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AddToCartDialog(cateList: widget.categoryData);
                      }));
                },
                child: Row(
                  children: const [
                    Icon(Icons.add, color: kPrimaryColor),
                    SizedBox(width: 5),
                    Text(
                      'Thêm dịch vụ',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.note_alt_outlined,
                    color: textColor.withOpacity(.5),
                  ),
                  hintText: 'Có ghi chú cho trung tâm?',
                ),
                controller: noteController,
                onSubmitted: (String value) async {
                  setState(() {
                    noteController.text = value;
                  });
                  await baseController.saveStringtoSharedPreference(
                      "customerMessage", value);
                  print(value);
                },
              ),
              const SizedBox(height: 15),
              const Text(
                'Phương thức vận chuyển:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 35,
                        child:
                            Image.asset('assets/images/shipping/ship-di.png'),
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
                    activeColor: kPrimaryColor,
                    groupValue: shippingMethod,
                    onChanged: (newVal) async {
                      setState(() async {
                        shippingMethod = newVal;
                        isCalculateShipFee = true;
                        await baseController.saveDoubletoSharedPreference(
                            "deliveryPrice", 0);
                        provider.updateDeliveryPrice();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              checkHasDelivery
                  ? basic.Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 35,
                                  child: Image.asset(
                                      'assets/images/shipping/dua-den.png'),
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
                              activeColor: kPrimaryColor,
                              groupValue: shippingMethod,
                              onChanged: (newVal) {
                                setState(() {
                                  shippingMethod = newVal;
                                  isCalculateShipFee = false;
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
                                  child: Image.asset(
                                      'assets/images/shipping/giao-den.png'),
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
                              activeColor: kPrimaryColor,
                              groupValue: shippingMethod,
                              onChanged: (newVal) {
                                setState(() {
                                  shippingMethod = newVal;
                                  isCalculateShipFee = false;
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
                                  child: Image.asset(
                                      'assets/images/shipping/shipper.png'),
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
                              activeColor: kPrimaryColor,
                              groupValue: shippingMethod,
                              onChanged: (newVal) {
                                setState(() {
                                  shippingMethod = newVal;
                                  isCalculateShipFee = false;
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
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: textBoldColor,
                                        fontWeight: FontWeight.w500),
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
                                    items: <String>[
                                      'Thành phố Hồ Chí Minh',
                                      'Chọn tỉnh / thành phố'
                                    ].map((String item) {
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              items:
                                                  sendDistrictList.map((item) {
                                                return DropdownMenuItem(
                                                  value: item['districtId']
                                                      .toString(),
                                                  child: Text(
                                                      item['districtName']),
                                                );
                                              }).toList(),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 1),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.only(left: 5),
                                              ),
                                              icon: const Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 20,
                                              ),
                                              iconSize: 30,
                                              value: sendDistrict,
                                              hint:
                                                  const Text('Chọn quận/huyện'),
                                              style: const TextStyle(
                                                  color: textColor),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  sendDistrict = newValue!;
                                                  getSendWardsList(newValue);
                                                  _dropDownSendWardKey
                                                      .currentState!
                                                      .reset();
                                                  _dropDownSendWardKey
                                                      .currentState!
                                                      .setValue(null);
                                                  isLoadingSendWard = false;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                  value:
                                                      item['wardId'].toString(),
                                                  child: Text(item['wardName']),
                                                );
                                              }).toList(),
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Không được để trống trường này';
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 1),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.only(left: 5),
                                              ),
                                              icon: const Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 20,
                                              ),
                                              iconSize: 30,
                                              //initialValue: sendWard,
                                              hint:
                                                  const Text('Chọn phường/xã'),
                                              style: const TextStyle(
                                                  color: textColor),
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
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: textBoldColor,
                                        fontWeight: FontWeight.w500),
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
                                    items: <String>[
                                      'Thành phố Hồ Chí Minh',
                                      'Chọn tỉnh / thành phố'
                                    ].map((String item) {
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              items: receiveDistrictList
                                                  .map((item) {
                                                return DropdownMenuItem(
                                                  value: item['districtId']
                                                      .toString(),
                                                  child: Text(
                                                      item['districtName']),
                                                );
                                              }).toList(),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 1),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.only(left: 5),
                                              ),
                                              icon: const Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 20,
                                              ),
                                              iconSize: 30,
                                              value: receiveDistrict,
                                              hint:
                                                  const Text('Chọn quận/huyện'),
                                              style: const TextStyle(
                                                  color: textColor),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  receiveDistrict = newValue!;
                                                  _dropDownReceiveWardKey
                                                      .currentState!
                                                      .reset();
                                                  _dropDownReceiveWardKey
                                                      .currentState!
                                                      .setValue(null);
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              items:
                                                  receiveWardList.map((item) {
                                                return DropdownMenuItem(
                                                  value:
                                                      item['wardId'].toString(),
                                                  child: Text(item['wardName']),
                                                );
                                              }).toList(),
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Không được để trống trường này';
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 1),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.only(left: 5),
                                              ),
                                              icon: const Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 20,
                                              ),
                                              iconSize: 30,
                                              //initialValue: receiveWard,
                                              hint:
                                                  const Text('Chọn phường/xã'),
                                              style: const TextStyle(
                                                  color: textColor),
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
                                  ),
                                ],
                              )
                            : const SizedBox(
                                height: 0,
                                width: 0,
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        (shippingMethod != 0 && isCalculateShipFee == false)
                            ? Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 40,
                                  width: 250,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      //await baseController.saveInttoSharedPreference("shippingMethod", shippingMethod);

                                      //print("shippingMethod $shippingMethod");
                                      if (shippingMethod == 0) {
                                        baseController
                                            .saveDoubletoSharedPreference(
                                                "deliveryPrice", 0);
                                        provider.updateDeliveryPrice();
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateOrderScreen()));
                                        return;
                                      }
                                      bool checkValidateFormSend =
                                          (shippingMethod == 1 ||
                                              shippingMethod == 3);
                                      bool checkValidateFormReceive =
                                          (shippingMethod == 2 ||
                                              shippingMethod == 3);
                                      bool check = false;
                                      if (!checkValidateFormSend) {
                                        check = _formReceiveAddressKey
                                                .currentState!
                                                .validate() &&
                                            _dropDownReceiveWardKey
                                                .currentState!
                                                .validate();
                                      } else if (!checkValidateFormReceive) {
                                        check = _formSendAddressKey
                                                .currentState!
                                                .validate() &&
                                            _dropDownSendWardKey.currentState!
                                                .validate();
                                      } else {
                                        check = (_formSendAddressKey
                                                    .currentState!
                                                    .validate() &&
                                                _dropDownSendWardKey
                                                    .currentState!
                                                    .validate() ||
                                            _formReceiveAddressKey.currentState!
                                                    .validate() &&
                                                _dropDownReceiveWardKey
                                                    .currentState!
                                                    .validate());
                                      }
                                      // print('sendAdressController.value.text${checkReceiveOrder}');
                                      // print('sendAdressController.value.te---xt${checkSendOrder}');
                                      // print('2==${widget.isReceive}');
                                      // print('1---${widget.isSend}');
                                      // print(
                                      //     'receiveAdressController.value.text${sendAdressController.value.text}');
                                      if (check) {
                                        print(
                                            'DropoffAddress - $DropoffAddress');
                                        print('DropoffWardId - $DropoffWardId');
                                        print(
                                            'DeliverAddress - $DeliverAddress');
                                        print('DeliverWardId - $DeliverWardId');
                                        print(
                                            'widget.isSend - ${shippingMethod}');
                                        //CartItem cartItem = await CartProvider().loadCartItemsFromPrefs();
                                        DeliveryRequest dropoff =
                                            DeliveryRequest();
                                        DeliveryRequest deliver =
                                            DeliveryRequest();
                                        if (checkValidateFormSend &&
                                            (shippingMethod == 1 ||
                                                shippingMethod == 3)) {
                                          DropoffAddress =
                                              sendAdressController.value.text;
                                          DropoffWardId = int.parse(sendWard!);
                                          dropoff = DeliveryRequest(
                                              deliveryType: false,
                                              wardId: DropoffWardId,
                                              addressString: DropoffAddress);
                                          dynamic dropoffDynamic =
                                              dropoff.toJson();
                                          dropoffJson =
                                              jsonEncode(dropoffDynamic);
                                          //baseController.saveStringtoSharedPreference("dropoff", dropoffJson);
                                        }
                                        if (checkValidateFormReceive &&
                                            (shippingMethod == 2 ||
                                                shippingMethod == 3)) {
                                          DeliverAddress =
                                              receiveAdressController
                                                  .value.text;
                                          DeliverWardId =
                                              int.parse(receiveWard!);
                                          deliver = DeliveryRequest(
                                              deliveryType: true,
                                              wardId: DeliverWardId,
                                              addressString: DeliverAddress);
                                          dynamic deliverDynamic =
                                              deliver.toJson();
                                          deliverJson =
                                              jsonEncode(deliverDynamic);
                                          //baseController.saveStringtoSharedPreference("deliver", deliverJson);
                                        }
                                        //double totalWeight = ;

                                        double totalWeight = 0;
                                        for (var element in provider.list) {
                                          if (element.weight != null) {
                                            totalWeight = totalWeight +
                                                element.measurement *
                                                    element.weight!;
                                          }
                                        }
                                        setState(() {
                                          isLoadingDeliveryPrice = true;
                                        });
                                        totalDeliveryPrice =
                                            await orderController
                                                .calculateDeliveryPrice(
                                                    totalWeight,
                                                    DropoffAddress,
                                                    DropoffWardId,
                                                    DeliverAddress,
                                                    DeliverWardId,
                                                    shippingMethod!);
                                        baseController
                                            .saveDoubletoSharedPreference(
                                                "deliveryPrice",
                                                totalDeliveryPrice);
                                        setState(() {
                                          isLoadingDeliveryPrice = false;
                                        });
                                        provider.updateDeliveryPrice();
                                        //baseController.printAllSharedPreferences();
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateOrderScreen()));
                                        setState(() {
                                          isCalculateShipFee = true;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsetsDirectional
                                                .symmetric(
                                            horizontal: 19, vertical: 10),
                                        foregroundColor:
                                            kPrimaryColor.withOpacity(.7),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                              color:
                                                  kPrimaryColor.withOpacity(.5),
                                              width: 1),
                                        ),
                                        backgroundColor: kPrimaryColor),
                                    child: const Text(
                                      'Tính phí vận chuyển',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(
                                height: 0,
                                width: 0,
                              ),
                      ],
                    )
                  : const SizedBox.shrink(),

              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Phương thức thanh toán',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 35,
                                child: Image.asset(
                                    'assets/images/shipping/cash-on-delivery.png'),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Thanh toán bằng tiền mặt',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          Radio(
                            activeColor: kPrimaryColor,
                            value: 0,
                            groupValue: payment,
                            onChanged: (newVal) {
                              setState(() {
                                payment = newVal;
                                baseController.saveInttoSharedPreference(
                                    "paymentMethod", 0);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Container(
                    //   padding: const EdgeInsets.only(left: 16, right: 16),
                    //   height: 50,
                    //   width: double.infinity,
                    //   alignment: Alignment.centerLeft,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       width: 1,
                    //       color: Colors.grey.shade400,
                    //     ),
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           SizedBox(
                    //             width: 35,
                    //             child: Image.asset(
                    //                 'assets/images/shipping/vnpay-icon.png'),
                    //           ),
                    //           const SizedBox(width: 8),
                    //           const Text(
                    //             'Thanh toán bằng ví Washouse',
                    //             style: TextStyle(fontSize: 15),
                    //           ),
                    //         ],
                    //       ),
                    //       Radio(
                    //         value: 1,
                    //         groupValue: payment,
                    //         onChanged: (newVal) {
                    //           setState(() {
                    //             payment = newVal;
                    //             print(newVal);
                    //             baseController.saveInttoSharedPreference(
                    //                 "paymentMethod", 1);
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              // const Text(
              //   'Thông tin vận chuyển:',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              // ),
              // const SizedBox(height: 5),
              const SizedBox(height: 15),
              basic.Row(
                children: [
                  const Text(
                    'Thời gian gửi đơn',
                    style: TextStyle(
                        fontSize: 18,
                        color: textBoldColor,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  FlutterSwitch(
                      value: checkSendOrder,
                      activeColor: kPrimaryColor,
                      width: 50,
                      height: 25,
                      toggleSize: 20,
                      onToggle: (val) {
                        setState(() {
                          checkSendOrder = val;
                        });
                      })
                ],
              ),
              const SizedBox(height: 10),
              checkSendOrder
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
                            value: sendOrderDate,
                            style: const TextStyle(color: textColor),
                            onChanged: (String? newValue) async {
                              setState(() {
                                sendOrderDate = newValue!;
                              });
                              if (newValue!.compareTo("Hôm nay") == 0) {
                                chooseDate = DateFormat('dd-MM-yyyy')
                                    .format(DateTime.now());
                              } else if (newValue.compareTo("Ngày mai") == 0) {
                                chooseDate = DateFormat('dd-MM-yyyy').format(
                                    DateTime.now().add(Duration(days: 1)));
                              }
                              baseController.saveStringtoSharedPreference(
                                  "preferredDropoffTime_Date", chooseDate!);
                              print(await baseController
                                  .getStringtoSharedPreference(
                                      "preferredDropoffTime_Date"));
                            },
                          ),
                        ),
                        sendOrderDate != null
                            ? Center(
                                child: Column(
                                  children: [
                                    sendOrderDate!.compareTo("Hôm nay") == 0
                                        ?

                                        /// wrap with sizedBOx
                                        SizedBox(
                                            height: 200,
                                            child: CustomTimerPicker(
                                              intiTimeOfDay: TimeOfDay.now(),
                                              maxTimeOfDay: maxToday,
                                              onChanged: (selectedHour,
                                                  selectedMinute) async {
                                                setState(() {
                                                  h = selectedHour;
                                                  m = selectedMinute;
                                                });
                                                debugPrint(
                                                    "H: $selectedHour minute: $selectedMinute");
                                                String hourSave = h
                                                    .toString()
                                                    .padLeft(2, '0');
                                                String minuteSave = m
                                                    .toString()
                                                    .padLeft(2, '0');
                                                String secondSave = '00';
                                                sendOrderTimeSave =
                                                    '$hourSave:$minuteSave:$secondSave';
                                                baseController
                                                    .saveStringtoSharedPreference(
                                                        "preferredDropoffTime_Time",
                                                        sendOrderTimeSave);
                                                print(await baseController
                                                    .getStringtoSharedPreference(
                                                        "preferredDropoffTime_Time"));
                                              },
                                            ),
                                          )
                                        : SizedBox(
                                            height: 200,
                                            child: CustomTimerPicker(
                                              intiTimeOfDay:
                                                  minTomorrow, // Giờ bắt đầu ngày mai
                                              maxTimeOfDay:
                                                  TimeOfDay.now().replacing(
                                                hour: TimeOfDay.now().hour +
                                                            24 >=
                                                        24
                                                    ? TimeOfDay.now().hour +
                                                        24 -
                                                        24
                                                    : TimeOfDay.now().hour + 24,
                                                minute: TimeOfDay.now().minute,
                                              ), // Giờ này 24 tiếng sau.
                                              onChanged: (selectedHour,
                                                  selectedMinute) async {
                                                setState(() {
                                                  h = selectedHour;
                                                  m = selectedMinute;
                                                });
                                                debugPrint(
                                                    "H: $selectedHour minute: $selectedMinute");

                                                String hourSave = h
                                                    .toString()
                                                    .padLeft(2, '0');
                                                String minuteSave = m
                                                    .toString()
                                                    .padLeft(2, '0');
                                                String secondSave = '00';
                                                sendOrderTimeSave =
                                                    '$hourSave:$minuteSave:$secondSave';
                                                baseController
                                                    .saveStringtoSharedPreference(
                                                        "preferredDropoffTime_Time",
                                                        sendOrderTimeSave);
                                                print(await baseController
                                                    .getStringtoSharedPreference(
                                                        "preferredDropoffTime_Time"));
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isLoadingDeliveryPrice
          ? Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10.0,
                      sigmaY: 10.0,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 100,
                      height: 100,
                      child: LoadingAnimationWidget.threeRotatingDots(
                          color: kPrimaryColor, size: 50),
                    ),
                  ),
                )
              ],
            )
          : Container(
              padding: const EdgeInsets.all(16),
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
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
                          'Phí vận chuyển:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '${PriceUtils().convertFormatPrice((value.deliveryPrice).toInt())} đ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryColor),
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
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${PriceUtils().convertFormatPrice((value.list.fold(0.0, (sum, item) => sum + item.price!) + value.deliveryPrice).toInt())} đ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryColor),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: (isCalculateShipFee == false &&
                              shippingMethod != 0)
                          ? null
                          : () async {
                              if (_formCusNameKey.currentState!.validate() &&
                                  _formPhoneNumberKey.currentState!
                                      .validate() &&
                                  _formEmailKey.currentState!.validate() &&
                                  _formAddressKey.currentState!.validate() &&
                                  _dropDownWardKey.currentState!.validate()) {
                                if (provider.list.isEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Align(
                                            alignment: Alignment.center,
                                            child: Text('Thông báo'),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          content: const Text(
                                              'Không có dịch vụ nào trong giỏ hàng!'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Đóng',
                                                style: TextStyle(
                                                    color: kPrimaryColor),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  List<OrderDetailRequest> orderDetailRequests =
                                      [];
                                  var centerId = await baseController
                                      .getInttoSharedPreference("CENTER_ID");
                                  for (var element in provider.list) {
                                    orderDetailRequests.add(
                                        new OrderDetailRequest(
                                            serviceId: element.serviceId,
                                            measurement: element.measurement,
                                            price: element.price,
                                            customerNote: element.customerNote,
                                            staffNote: element.staffNote));
                                  }
                                  print(1);
                                  List<DeliveryRequest> deliveries = [];
                                  //shippingMethod = await baseController.getInttoSharedPreference("shippingMethod");
                                  shippingMethod = shippingMethod;
                                  if (shippingMethod == 1 ||
                                      shippingMethod == 3) {
                                    //String? dropoff = await baseController.getStringtoSharedPreference("dropoff");
                                    //dynamic dropoffDynamic = jsonDecode(dropoff!);
                                    //dynamic dropoffDynamic = jsonDecode(dropoffJson);
                                    //var dropoffModel = dropoffDynamic.map((item) => DeliveryRequest.fromJson(item));
                                    //deliveries.add(dropoffModel);

                                    deliveries.add(new DeliveryRequest(
                                        addressString: DropoffAddress,
                                        wardId: DropoffWardId,
                                        deliveryType: false));
                                  }
                                  if (shippingMethod == 2 ||
                                      shippingMethod == 3) {
                                    //String? deliver = await baseController.getStringtoSharedPreference("deliver");
                                    //dynamic deliverDynamic = jsonDecode(deliver!);
                                    // dynamic deliverDynamic = jsonDecode(deliverJson);
                                    // var deliverModel = deliverDynamic.map((item) => DeliveryRequest.fromJson(item));
                                    // deliveries.add(deliverModel);
                                    deliveries.add(new DeliveryRequest(
                                        addressString: DeliverAddress,
                                        wardId: DeliverWardId,
                                        deliveryType: true));
                                  }
                                  String? preferredDropoffTime;
                                  print('chooseDate: $chooseDate');
                                  print(
                                      'sendOrderTimeSave: $sendOrderTimeSave');
                                  if (chooseDate != null &&
                                      sendOrderTimeSave != null &&
                                      chooseDate != "" &&
                                      sendOrderTimeSave != "") {
                                    preferredDropoffTime =
                                        chooseDate! + " " + sendOrderTimeSave!;
                                  }
                                  CartItem cartItem = CartItem(
                                      centerId: centerId,
                                      order: OrderRequest(
                                          customerName: nameController.text,
                                          customerAddressString:
                                              addressController.text,
                                          customerEmail: emailController.text,
                                          customerWardId: int.parse(cusWard!),
                                          customerMobile: phoneController.text,
                                          customerMessage: noteController.text,
                                          deliveryType: shippingMethod,
                                          //deliveryPrice: await baseController.getDoubletoSharedPreference("deliveryPrice"),
                                          deliveryPrice: totalDeliveryPrice,
                                          preferredDropoffTime:
                                              preferredDropoffTime == null
                                                  ? DateFormat(
                                                          'dd-MM-yyyy HH:mm:ss')
                                                      .format(DateTime.now())
                                                  : preferredDropoffTime),
                                      orderDetails: orderDetailRequests,
                                      deliveries: deliveries,
                                      paymentMethod: payment);
                                  print(cartItem.toJson());
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      });
                                  String? orderId = await orderController
                                      .createOrder(cartItem);
                                  print(orderId);
                                  if (orderId != null && orderId.length == 16) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    await provider.removeCart();
                                    await baseController
                                        .printAllSharedPreferences();
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: OrderDetailScreen(
                                                orderId: orderId),
                                            type: PageTransitionType
                                                .rightToLeftWithFade));
                                  } else {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Align(
                                            alignment: Alignment.center,
                                            child: Text('Thông báo'),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          content: Text(
                                              'Có lỗi xảy ra trong quá trình đặt hàng'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                'Đóng',
                                                style: TextStyle(
                                                    color: kPrimaryColor),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 19, vertical: 10),
                          foregroundColor: kPrimaryColor.withOpacity(.7),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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
  //}
}
