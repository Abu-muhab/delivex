import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:node_auth/models/order.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:provider/provider.dart';

class User {
  String userId;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;

  User(
      {this.email,
      this.lastName,
      this.firstName,
      this.userId,
      this.phoneNumber});

  factory User.formJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        email: json['email'],
        firstName: json['firstName'],
        phoneNumber: json['phoneNumber'],
        lastName: json['lastName']);
  }

  Future<bool> updateName(
      BuildContext context, String firstName, String lastName) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    http.Response response = await http.post('$domain/user/updateName',
        body: JsonEncoder()
            .convert({'firstName': firstName, 'lastName': lastName}),
        headers: {
          'Authorization':
              'Bearer ${authProvider.tokenDecoder(await authProvider.getEncodedToken())}',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      Map body = JsonDecoder().convert(response.body);
      if (!body['successful']) {
        throw (body['message']);
      }
      return authProvider.loadUserDetails(
          authProvider.tokenDecoder(await authProvider.getEncodedToken()));
    }
    throw ('Server Error');
  }

  Future<bool> updatePhone(BuildContext context, String phoneNumber) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    http.Response response = await http.post('$domain/user/updatePhone',
        body: JsonEncoder().convert({
          'phoneNumber': phoneNumber,
        }),
        headers: {
          'Authorization':
              'Bearer ${authProvider.tokenDecoder(await authProvider.getEncodedToken())}',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      Map body = JsonDecoder().convert(response.body);
      if (!body['successful']) {
        throw (body['message']);
      }
      return authProvider.loadUserDetails(
          authProvider.tokenDecoder(await authProvider.getEncodedToken()));
    }
    throw ('Server Error');
  }

  Future<List<Order>> getOrders(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    http.Response response = await http.get('$domain/user/orders', headers: {
      'Authorization':
          'Bearer ${authProvider.tokenDecoder(await authProvider.getEncodedToken())}'
    });
    if (response.statusCode == 200) {
      Map body = JsonDecoder().convert(response.body);
      if (!body['successful']) {
        throw (body['message']);
      }

      List data = body['data'];
      List<Order> orders = new List();
      data.forEach((orderData) {
        orders.add(Order.fromJson(orderData));
      });
      return orders;
    }
    throw ('Server Error');
  }

  Future<List<Order>> getOrderHistory(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    http.Response response =
        await http.get('$domain/user/orderHistory', headers: {
      'Authorization':
          'Bearer ${authProvider.tokenDecoder(await authProvider.getEncodedToken())}'
    });
    if (response.statusCode == 200) {
      Map body = JsonDecoder().convert(response.body);
      if (!body['successful']) {
        throw (body['message']);
      }

      List data = body['data'];
      List<Order> orders = new List();
      data.forEach((orderData) {
        orders.add(Order.fromJson(orderData));
      });
      return orders;
    }
    throw ('Server Error');
  }
}
