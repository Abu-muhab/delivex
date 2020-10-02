import 'package:flutter/material.dart';
import 'package:node_auth/models/order.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:provider/provider.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> orders;
  List<Order> history;

  Future<bool> fetchOrders(BuildContext context) async {
    try {
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      orders = await authProvider.user.getOrders(context);
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> fetchHistory(BuildContext context) async {
    try {
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      history = await authProvider.user.getOrderHistory(context);
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }
}
