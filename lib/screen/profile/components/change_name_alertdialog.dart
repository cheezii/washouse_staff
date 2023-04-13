import 'package:flutter/material.dart';

import '../../../components/constants/color_constants.dart';

class ChangeNameAlertDialog extends StatefulWidget {
  const ChangeNameAlertDialog({super.key});

  @override
  State<ChangeNameAlertDialog> createState() => _ChangeNameAlertDialogState();
}

class _ChangeNameAlertDialogState extends State<ChangeNameAlertDialog> {
  final _formNameKey = GlobalKey<FormState>();

  late String newName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Align(
        alignment: Alignment.center,
        child: Text('Đổi tên hiển thị'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formNameKey,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Tên không được để trống';
                }
                return null;
              },
              style: const TextStyle(
                color: textColor,
              ),
              decoration: InputDecoration(
                labelText: 'Tên mới',
                labelStyle: const TextStyle(
                    color: textBoldColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                hintText: 'Nhập tên mới',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              cursorColor: textColor.withOpacity(.8),
              onSaved: (newValue) {
                newName = newValue!;
              },
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              if (_formNameKey.currentState!.validate()) {
                _formNameKey.currentState!.save();
                //change name
              }
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
              'Lưu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
