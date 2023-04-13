import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../components/constants/color_constants.dart';
import '../../resource/controller/account_controller.dart';
import '../../resource/controller/base_controller.dart';
import '../../resource/model/customer.dart';
import 'components/change_name_alertdialog.dart';
import 'components/change_password_alertdialog.dart';
import 'components/information_widget.dart';

class InfomationScreen extends StatefulWidget {
  const InfomationScreen({super.key});

  @override
  State<InfomationScreen> createState() => _InfomationScreenState();
}

BaseController baseController = BaseController();
AccountController accountController = AccountController();

class _InfomationScreenState extends State<InfomationScreen> {
  TextEditingController dateController = TextEditingController();
  DateTime date = DateTime.now().subtract(const Duration(days: 18 * 365 + 4));
  String? gender;
  String genderDisplay = '- Chọn -';
  String? birthday;
  String birthdayDisplay = '- Chọn -';
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  String? _currentUserName = '';
  String? _currentUserEmail = '';
  String? _currentUserAvartar = '';
  int _currentUserId = 0;
  Customer? _currentCustomer;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final name =
        await baseController.getStringtoSharedPreference("CURRENT_USER_NAME");
    final email =
        await baseController.getStringtoSharedPreference("CURRENT_USER_EMAIL");
    final avatar =
        await baseController.getStringtoSharedPreference("CURRENT_USER_AVATAR");
    final userId =
        await baseController.getInttoSharedPreference("CURRENT_USER_ID");
    final currentCustomer =
        await accountController.getCustomerInfomation(userId!);
    setState(() {
      _currentUserName = name != "" ? name : "Undentified Name";
      _currentUserEmail = email != "" ? email : "Undentified Email";
      _currentUserAvartar = avatar != ""
          ? avatar
          : "https://storage.googleapis.com/washousebucket/anonymous-20230330210147.jpg?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=washouse-sa%40washouse-381309.iam.gserviceaccount.com%2F20230330%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20230330T210148Z&X-Goog-Expires=1800&X-Goog-SignedHeaders=host&X-Goog-Signature=7c813f26489c9ba06cdfff27db9faa2ca4d7c046766aeb3874fdf86ec7c91ae904951f7b2617b6e78598d46f8b91d842d2f4c2a10696539bcf09c839d51d9565831f6c503b3e37f899ab8920f69c3aaa30e0ff2d9c598d1a4c523c1e8038520a32fe49a92c4448c49e602b77312444fe3505afa30da1c4bfbdf0f7a5ab9f2783005c1f3624b3417e17c0067f65f4c02fd03bbe9a0eed8390b56aa2b78a34ca88b52bbce7e1d364dc24e6650a68954e36439102f19a3b332fcb1562260d5223db1e09748eee5d7e6b0cba62dc7cfda9e1e00690f334b9e4b85c710ed77dee42759b48f98df0f05e1adf686351f6232a7d157c9f988248af0c69ec64af0cdbe247";
      _currentUserId = userId != 0 ? userId : 0;
      _currentCustomer = currentCustomer != null ? currentCustomer : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    dateController.text = '${date.day}/${date.month}/${date.year}';
    if (_currentCustomer != null && _currentCustomer!.gender != null) {
      switch (_currentCustomer!.gender!) {
        case 0:
          genderDisplay = "Nam";
          break;
        case 1:
          genderDisplay = "Nữ";
          break;
        case 2:
          genderDisplay = "Khác";
          break;
        default:
          genderDisplay = '- Chọn -';
      }
    }
    if (_currentCustomer != null &&
        _currentCustomer!.dob != null &&
        _currentCustomer!.dob!.isNotEmpty) {
      birthday = _currentCustomer!.dob!;
    }
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
        title: const Text('Hồ sơ',
            style: TextStyle(color: textColor, fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    //backgroundImage: AssetImage('assets/images/profile/4.jpg'),
                    backgroundImage: NetworkImage(_currentUserAvartar!),
                  ),
                  TextButton(
                      onPressed: () async {
                        await _pickImage(ImageSource.gallery);

                        //   Map<String, String> responseMap =
                        //       await baseController.uploadImage(_imageFile!);

                        //   //accountController.  ///api/customers/profilepic
                        //   String messageChangeProfilePicture =
                        //       await accountController.changeProfilePicture(
                        //           responseMap['SavedFileName']!,
                        //           _currentUserId);
                        //   if (messageChangeProfilePicture.compareTo(
                        //           "update profile picture success") ==
                        //       0) {
                        //     //save avatar Preference
                        //     await baseController.saveStringtoSharedPreference(
                        //         "CURRENT_USER_AVATAR",
                        //         responseMap['signedUrl']);
                        print('_imageFile - $_imageFile');
                        if (_imageFile != null) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Ảnh bạn đã chọn'),
                                content: Image.file(
                                  _imageFile!,
                                  height: 200.0,
                                  width: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Hủy bỏ'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Map<String, String> responseMap =
                                          await baseController
                                              .upload(_imageFile!);
                                      String messageChangeProfilePicture =
                                          await accountController
                                              .changeProfilePicture(
                                                  responseMap['savedFileName']!,
                                                  _currentUserId);
                                      if (messageChangeProfilePicture.compareTo(
                                              "update profile picture success") ==
                                          0) {
                                        //save avatar Preference
                                        await baseController
                                            .saveStringtoSharedPreference(
                                                "CURRENT_USER_AVATAR",
                                                responseMap['signedUrl']);
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Thông báo'),
                                              content: const Text(
                                                  'Bạn đã đổi ảnh đại diện thành công!'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Thông báo'),
                                              content: const Text(
                                                  'Có lỗi trong quá trình xử lý!'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: const Text('Chấp nhận'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Thông báo'),
                                content:
                                    const Text('Có lỗi trong quá trình xử lý!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                        //}
                      },
                      child: const Text('Đổi ảnh đại diện',
                          style: TextStyle(fontSize: 17))),
                ],
              ),
              Column(
                children: [
                  InformationWidget(
                      title: 'Họ và tên',
                      subTitle: _currentUserName!,
                      canChange: true,
                      press: () {
                        showDialog(
                            context: context,
                            builder: ((context) =>
                                const ChangeNameAlertDialog()));
                      }),
                  InformationWidget(
                      title: 'Số điện thoại',
                      subTitle: (_currentCustomer != null &&
                              _currentCustomer!.phone != null)
                          ? _currentCustomer!.phone!
                          : '- Chọn -',
                      canChange: false,
                      press: () {}),
                  InformationWidget(
                      title: 'Email',
                      subTitle: _currentUserEmail!,
                      canChange: false,
                      press: () {}),
                  InformationWidget(
                      title: 'Giới tính',
                      subTitle: genderDisplay,
                      canChange: true,
                      press: () {
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            builder: ((context) => StatefulBuilder(
                                  builder: (context, setState) => Container(
                                    height: 380,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: StatefulBuilder(
                                      builder: (context, setState) => Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                  icon: const Icon(
                                                      Icons.close_rounded),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                              const SizedBox(width: 90),
                                              const Text(
                                                'Chọn giới tính',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                              thickness: 1,
                                              color: Colors.grey.shade300),
                                          const SizedBox(height: 10),
                                          ListTile(
                                            title: const Text('Nam'),
                                            trailing: Radio<String>(
                                              value: 'Nam',
                                              groupValue: gender,
                                              onChanged: (value) {
                                                setState(() {
                                                  gender = value;
                                                  genderDisplay =
                                                      value.toString();
                                                });
                                                this.setState(() {
                                                  genderDisplay =
                                                      value.toString();
                                                });
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Nữ'),
                                            trailing: Radio<String>(
                                              value: 'Nữ',
                                              groupValue: gender,
                                              onChanged: (value) {
                                                setState(() {
                                                  gender = value;
                                                });
                                                this.setState(() {
                                                  genderDisplay =
                                                      value.toString();
                                                });
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Khác'),
                                            trailing: Radio<String>(
                                              value: 'Khác',
                                              groupValue: gender,
                                              onChanged: (value) {
                                                setState(() {
                                                  gender = value;
                                                  genderDisplay =
                                                      value.toString();
                                                });
                                                this.setState(() {
                                                  genderDisplay =
                                                      value.toString();
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 60),
                                          SizedBox(
                                            width: size.width,
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                //lưu gender sang
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  backgroundColor:
                                                      kPrimaryColor),
                                              child: const Text('Lưu',
                                                  style:
                                                      TextStyle(fontSize: 17)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )));
                      }),
                  InformationWidget(
                      title: 'Ngày sinh',
                      subTitle: birthdayDisplay,
                      canChange: true,
                      press: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          builder: ((context) => StatefulBuilder(
                                builder: (context, setState) => Container(
                                  height: 530,
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              icon: const Icon(
                                                  Icons.close_rounded),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                          const SizedBox(width: 90),
                                          const Text(
                                            'Chọn ngày sinh',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                          thickness: 1,
                                          color: Colors.grey.shade300),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: dateController,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 4),
                                        ),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: textColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 2),
                                      const TextField(
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          hintText:
                                              '*Lưu ý: Bạn phải trên 18 tuổi để sử dụng dịch vụ',
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        height: 250,
                                        child: CupertinoDatePicker(
                                            initialDateTime: date,
                                            use24hFormat: true,
                                            maximumDate: date,
                                            dateOrder: DatePickerDateOrder.dmy,
                                            mode: CupertinoDatePickerMode.date,
                                            backgroundColor: Colors.white,
                                            onDateTimeChanged:
                                                (DateTime newDate) {
                                              setState(() {
                                                dateController.text =
                                                    '${newDate.day}/${newDate.month}/${newDate.year}';
                                              });
                                            }),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: size.width,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            this.setState(() {
                                              birthdayDisplay =
                                                  dateController.text;
                                            });
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              backgroundColor: kPrimaryColor),
                                          child: const Text('Lưu',
                                              style: TextStyle(fontSize: 17)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return const ChangePassWordAlertDialog();
                });
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 19, vertical: 16),
              foregroundColor: kPrimaryColor.withOpacity(.7),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side:
                    BorderSide(color: kPrimaryColor.withOpacity(.5), width: 1),
              ),
              backgroundColor: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.change_circle_outlined,
                color: textColor.withOpacity(.6),
                size: 26.0,
              ),
              const SizedBox(width: 16),
              const Text(
                'Đổi mật khẩu',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
