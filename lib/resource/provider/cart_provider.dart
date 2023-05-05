import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washouse_staff/resource/model/cart_item_view.dart';

import '../../utils/cart_util.dart';
import '../model/cart_item.dart';
import '../model/promotion.dart';

class CartProvider extends ChangeNotifier {
  CartItem _cartItem = CartItem();
  List<OrderDetailItem> _list = [];
  //late int _counter;
  int? _centerId = 0;
  double _totalPrice = 0;
  double _discount = 0;
  double _deliveryPrice = 0;
  int _deliveryType = 0;
  String? _promoCode = '';

  CartItem get cartItem => _cartItem;
  List<OrderDetailItem> get list => _list;

  //int get counter => _counter;
  int? get centerId => _centerId;
  double get totalPrice => _totalPrice;
  double get discount => _discount;
  double get deliveryPrice => _deliveryPrice;
  int get deliveryType => _deliveryType;
  String? get promoCode => _promoCode;

  CartProvider() {
    loadCartItemsFromPrefs();
  }

  Future<void> loadCartItemsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartItemsJson = prefs.getString('cartItem');
    //String? centerName = prefs.getString('centerName');
    if (cartItemsJson != null) {
      dynamic cartItemsDynamic = jsonDecode(cartItemsJson);
      _cartItem = cartItemsDynamic.map((item) => CartItem.fromJson(item));
      notifyListeners();
    }
  }

  void addOrderDetailItemToCart(OrderDetailItem orderDetailItem) {
    int existingItemIndex =
        _list.indexWhere((item) => item.serviceId == orderDetailItem.serviceId);
    if (existingItemIndex == -1) {
      orderDetailItem.price =
          CartUtils.getTotalPriceOfCartItem(orderDetailItem);
      //addTotalPrice(newItem.price!);
      _list.add(orderDetailItem);
    } else {
      OrderDetailItem existingItem = _list[existingItemIndex];
      if (orderDetailItem.priceType) {
        double totalMeasurement =
            existingItem.measurement + orderDetailItem.measurement;
        double maxCapacity = orderDetailItem.prices!.last.maxValue!.toDouble();
        if (totalMeasurement <= maxCapacity) {
          orderDetailItem.measurement = totalMeasurement;
          orderDetailItem.price =
              CartUtils.getTotalPriceOfCartItem(orderDetailItem);
        } else {
          orderDetailItem.measurement = maxCapacity;
          orderDetailItem.price =
              CartUtils.getTotalPriceOfCartItem(orderDetailItem);
          print(
              "Measurement capacity exceeded for item with serviceId ${existingItem.serviceId}");
        }
      } else {
        orderDetailItem.measurement =
            orderDetailItem.measurement + existingItem.measurement;
        orderDetailItem.price =
            CartUtils.getTotalPriceOfCartItem(orderDetailItem);
      }
      existingItem = orderDetailItem;
      _list[existingItemIndex] = orderDetailItem;
      //removeTotalPrice(existingItem.price!);
      //_cartItems.removeAt(existingItemIndex);
      //addTotalPrice(newItem.price!);
      //_cartItems.add(newItem);
    }
    notifyListeners();
    saveCartItemsToPrefs();
  }

  void removeItemFromCart(OrderDetailItem itemToRemove) {
    int existingItemIndex =
        _list.indexWhere((item) => item.serviceId == itemToRemove.serviceId);
    // removeTotalPrice(_list[existingItemIndex].price!);
    _list.remove(_list[existingItemIndex]);
    if (_list.length == 0) {
      _discount = 0;
      _deliveryPrice = 0;
      _totalPrice = 0;
      _promoCode = "";
      _clearIfCartEmpty();
    }
    notifyListeners();
    saveCartItemsToPrefs();
  }

  void updateOrderDetailItemToCart(
      OrderDetailItem orderDetailItem, double measurement) {
    int existingItemIndex =
        _list.indexWhere((item) => item.serviceId == orderDetailItem.serviceId);
    if (existingItemIndex == -1) {
      return;
    } else {
      OrderDetailItem existingItem = _list[existingItemIndex];
      if (orderDetailItem.priceType) {
        double totalMeasurement = existingItem.measurement + measurement;
        double maxCapacity = orderDetailItem.prices!.last.maxValue!.toDouble();
        if (totalMeasurement <= maxCapacity) {
          orderDetailItem.measurement = totalMeasurement;
          orderDetailItem.price =
              CartUtils.getTotalPriceOfCartItem(orderDetailItem);
        } else {
          orderDetailItem.measurement = maxCapacity;
          orderDetailItem.price =
              CartUtils.getTotalPriceOfCartItem(orderDetailItem);
          print(
              "Measurement capacity exceeded for item with serviceId ${existingItem.serviceId}");
        }
      } else {
        orderDetailItem.measurement = orderDetailItem.measurement + measurement;
        orderDetailItem.price =
            CartUtils.getTotalPriceOfCartItem(orderDetailItem);
      }
      existingItem = orderDetailItem;
      if (orderDetailItem.measurement > 0) {
        _list[existingItemIndex] = orderDetailItem;
      } else {
        _list.removeAt(existingItemIndex);
      }
      //removeTotalPrice(existingItem.price!);
      //_cartItems.removeAt(existingItemIndex);
      //addTotalPrice(newItem.price!);
      //_cartItems.add(newItem);
    }
    notifyListeners();
    saveCartItemsToPrefs();
  }

  // void removeItemFromCart(CartItem itemToRemove) {
  //   int existingItemIndex = _cartItems.indexWhere((item) => item.serviceId == itemToRemove.serviceId);
  //   removeTotalPrice(_cartItems[existingItemIndex].price!);
  //   _cartItems.remove(_cartItems[existingItemIndex]);
  //   if (_cartItems.length == 0) {
  //     _discount = 0;
  //     _deliveryPrice = 0;
  //     _totalPrice = 0;
  //     _promoCode = "";
  //     _clearIfCartEmpty();
  //   }
  //   notifyListeners();
  //   saveCartItemsToPrefs();
  // }

  Future<void> saveCartItemsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic cartItemDynamic = _cartItem.toJson();
    String cartItemJson = jsonEncode(cartItemDynamic);
    print(cartItemJson);
    if (cartItemJson.isNotEmpty)
      await prefs.setString('cartItem', cartItemJson);
  }

  // void _setPrefItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //prefs.setInt('cart_item', _counter);
  //   prefs.setDouble('total_price', _totalPrice);
  //   notifyListeners();
  // }

  void _clearIfCartEmpty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setInt('cart_item', _counter);
    prefs.remove('centerId');
    prefs.setDouble('total_price', 0);
    prefs.remove('discount');
    prefs.remove('customerName');
    prefs.remove('customerAddressString');
    prefs.remove('customerMessage');
    prefs.remove('customerWardId');
    prefs.remove('paymentMethod');
    prefs.remove('deliveryType');
    prefs.remove('preferredDropoffTime');
    prefs.remove('preferredDropoffTime_Date');
    prefs.remove('preferredDropoffTime_Time');
    prefs.remove('preferredDeliverTime_Time');
    prefs.remove('preferredDeliverTime_Date');
    prefs.remove('addressString_Dropoff');
    prefs.remove('addressString_Delivery');
    prefs.remove('wardId_Dropoff');
    prefs.remove('wardId_Delivery');
    prefs.remove('promoCode');
    prefs.remove('customerPhone');
    prefs.remove('customerNote');
    prefs.remove('cartItems');
    prefs.remove('deliveryPrice');
    prefs.remove('total_price');
    prefs.remove('customerNote');
    prefs.remove('centerId');
    prefs.remove('customerName');
    prefs.remove('customerPhone');
    prefs.remove('customerWardId');
    prefs.remove('deliveryType');
    prefs.remove('addressString_Dropoff');
    prefs.remove('customerMessage');
    prefs.remove('paymentMethod');
    notifyListeners();
  }

  // void _getPrefItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //_counter = prefs.getInt('cart_item') ?? 0;
  //   _totalPrice = prefs.getDouble('total_price') ?? 0;
  //   notifyListeners();
  // }

  // void updateCenter(int id) {
  //   if (_centerId != id) {
  //     _centerId = id;
  //   }
  //   notifyListeners();
  //   _setCenter();
  // }

  // void updatePromotion(PromotionModel promotion) {
  //   if (_promoCode != promotion.code) {
  //     _promoCode = promotion.code;
  //   }
  //   if (_discount != promotion.discount) {
  //     _discount = promotion.discount;
  //   }
  //   print(_promoCode);
  //   notifyListeners();
  //   _setPromotion();
  // }

  Future removeCart() async {
    _cartItem = CartItem();
    _list.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItem');
    _discount = 0;
    _deliveryPrice = 0;
    _deliveryType = 0;
    _totalPrice = 0;
    _promoCode = "";
    _clearIfCartEmpty();
    notifyListeners();
  }

  // void _setCenter() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('centerId', _centerId);
  // }

  // void _getCenter() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _centerId = prefs.getInt('centerId') ?? null;
  // }

  // void _setPromotion() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('promoCode', _promoCode);
  //   prefs.setDouble('discount', _discount);
  // }

  // void _getPromotion() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _promoCode = prefs.getString('promoCode');
  //   _discount = prefs.getDouble('discount');
  // }

  void _setDeliveryPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _deliveryPrice = prefs.getDouble('deliveryPrice')!;
    print(_deliveryPrice);
    //_deliveryType = prefs.getInt("deliveryType")!;
  }

  // void _getDeliveryPrice() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _deliveryPrice = prefs.getDouble('deliveryPrice')!;
  //   _deliveryType = prefs.getInt('deliveryType')!;
  // }

  void updateDeliveryPrice() {
    notifyListeners();
    _setDeliveryPrice();
  }

  // void addTotalPrice(double productPrice) {
  //   print('productPrice-${productPrice}'); //35
  //   print('_totalPrice-${_totalPrice}'); //0
  //   _totalPrice += productPrice;
  //   //(_totalPrice + productPrice) > 0 ? (_totalPrice + productPrice) : 0;
  //   print('_totalPriceAfter-${_totalPrice}');
  //   _setPrefItems();
  //   notifyListeners();
  // }

  // void removeTotalPrice(double productPrice) {
  //   print('productPriceRemove-${productPrice}');
  //   print('_totalPriceRemove-${_totalPrice}'); //0
  //   print('_Remove-${(_totalPrice - productPrice)}'); //0
  //   _totalPrice = (_totalPrice - productPrice) > 0 ? _totalPrice - productPrice : 0;
  //   print('_totalPriceAfterRemove-${_totalPrice}');
  //   _setPrefItems();
  //   notifyListeners();
  // }

  // num getTotalPrice() {
  //   _getPrefItems();
  //   return _totalPrice;
  // }

  // void addCounter() {
  //   //_counter++;
  //   _setPrefItems();
  //   notifyListeners();
  // }

  // void removerCounter() {
  //   //_counter--;
  //   _setPrefItems();
  //   notifyListeners();
  // }

  // //kiểm tra đã có trong cart thì tăng 1, k thì thêm vào cart
  // void addToCartWithQuantity(CartItem cart_item) {
  //   int existingItemIndex = _cartItems.indexWhere((item) => item.serviceId == cart_item.serviceId);
  //   CartItem existingItem = _cartItems[existingItemIndex];
  //   if (cart_item.priceType) {
  //     double totalMeasurement = existingItem.measurement + 1;
  //     double maxCapacity = cart_item.prices!.last.maxValue!.toDouble();
  //     if (totalMeasurement <= maxCapacity) {
  //       cart_item.measurement = totalMeasurement;
  //       cart_item.price = CartUtils.getTotalPriceOfCartItem(cart_item);
  //     } else {
  //       cart_item.measurement = maxCapacity;
  //       cart_item.price = CartUtils.getTotalPriceOfCartItem(cart_item);
  //       print("Measurement capacity exceeded for item with serviceId ${existingItem.serviceId}");
  //     }
  //   } else {
  //     cart_item.measurement = 1 + existingItem.measurement;
  //     cart_item.price = CartUtils.getTotalPriceOfCartItem(cart_item);
  //   }
  //   removeTotalPrice(existingItem.price!);
  //   _cartItems.removeAt(existingItemIndex);
  //   addTotalPrice(cart_item.price!);
  //   _cartItems.add(cart_item);
  //   notifyListeners();
  //   saveCartItemsToPrefs();
  // }

  // //có thì trừ không thì xóa
  // void removeFromCartWithQuantity(CartItem cart_item) {
  //   int existingItemIndex = _cartItems.indexWhere((item) => item.serviceId == cart_item.serviceId);
  //   CartItem existingItem = _cartItems[existingItemIndex];
  //   removeTotalPrice(existingItem.price!);
  //   cart_item.measurement = existingItem.measurement - 1;
  //   cart_item.price = CartUtils.getTotalPriceOfCartItem(cart_item);
  //   _cartItems.removeAt(existingItemIndex);

  //   addTotalPrice(cart_item.price!);
  //   _cartItems.add(cart_item);
  //   notifyListeners();
  //   saveCartItemsToPrefs();
  // }

  // void addToCartWithKilogram(CartItem cart_item) {
  //   int existingItemIndex = _cartItems.indexWhere((item) => item.serviceId == cart_item.serviceId);
  //   CartItem existingItem = _cartItems[existingItemIndex];
  //   if (cart_item.priceType) {
  //     double totalMeasurement = double.parse((existingItem.measurement + 0.1).toStringAsFixed(1));
  //     double maxCapacity = cart_item.prices!.last.maxValue!.toDouble();
  //     if (totalMeasurement <= maxCapacity) {
  //       cart_item.measurement = totalMeasurement;
  //       cart_item.price = CartUtils.getTotalPriceOfCartItem(cart_item);
  //     } else {
  //       cart_item.measurement = maxCapacity;
  //       cart_item.price = CartUtils.getTotalPriceOfCartItem(cart_item);
  //       print("Measurement capacity exceeded for item with serviceId ${existingItem.serviceId}");
  //     }
  //   } else {
  //     cart_item.measurement = double.parse((0.1 + existingItem.measurement).toStringAsFixed(1));
  //     cart_item.price = CartUtils.getTotalPriceOfCartItem(cart_item);
  //   }
  //   removeTotalPrice(existingItem.price!);
  //   _cartItems.removeAt(existingItemIndex);
  //   addTotalPrice(cart_item.price!);
  //   _cartItems.add(cart_item);
  //   notifyListeners();
  //   saveCartItemsToPrefs();
  // }

  // void removeFromCartWithKilogram(CartItem cart_item) {
  //   int existingItemIndex = _cartItems.indexWhere((item) => item.serviceId == cart_item.serviceId);
  //   CartItem existingItem = _cartItems[existingItemIndex];
  //   removeTotalPrice(existingItem.price!);
  //   cart_item.measurement = double.parse((existingItem.measurement - 0.1).toStringAsFixed(1));
  //   cart_item.price = CartUtils.getTotalPriceOfCartItem(cart_item);
  //   _cartItems.removeAt(existingItemIndex);

  //   addTotalPrice(cart_item.price!);
  //   _cartItems.add(cart_item);
  //   notifyListeners();
  //   saveCartItemsToPrefs();
  // }
}
