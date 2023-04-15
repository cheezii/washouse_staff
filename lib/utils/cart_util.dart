import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washouse_staff/resource/model/cart_item.dart';

class CartUtils {
  static double getTotalPriceOfCartItem(CartItem item) {
    double currentPrice = 0;
    double totalCurrentPrice = 0;
    // if (item.priceType) {
    //   bool check = false;
    //   for (var itemPrice in item.prices!) {
    //     if (item.measurement <= itemPrice.maxValue! && !check) {
    //       currentPrice = itemPrice.price!.toDouble();
    //     }
    //     if (currentPrice > 0) {
    //       check = true;
    //     }
    //   }
    //   print('currentPrice-${currentPrice}');
    //   print('item.minPrice-${item.minPrice}');
    //   if (item.minPrice != null && currentPrice * item.measurement < item.minPrice!) {
    //     totalCurrentPrice = item.minPrice!.toDouble();
    //   } else {
    //     totalCurrentPrice = currentPrice * item.measurement;
    //   }
    //   print('totalCurrentPrice-${totalCurrentPrice}');
    // } else {
    //   totalCurrentPrice = item.unitPrice! * item.measurement.toDouble();
    //   currentPrice = item.price!.toDouble();
    // }
    return totalCurrentPrice;
  }
}
