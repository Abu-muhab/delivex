import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> updateName(
      BuildContext context, String firstName, String lastName) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authProvider.firebaseUser.uid)
        .set({'firstName': firstName, 'lastName': lastName},
            SetOptions(merge: true));
  }

  Future<void> updatePhone(BuildContext context, String phoneNumber) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authProvider.firebaseUser.uid)
        .set({'phoneNumber': phoneNumber}, SetOptions(merge: true));
  }

  Future<List<Order>> getOrders(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    QuerySnapshot snapshot;
    snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: authProvider.firebaseUser.uid)
        .get();
    List<Order> orders = new List();
    snapshot.docs.forEach((orderData) {
      print(orderData.data());
      orders.add(Order.fromJson(orderData.data()['details']));
    });
    return orders;
  }

  Future<List<Order>> getOrderHistory(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    QuerySnapshot snapshot;
    snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: authProvider.firebaseUser.uid)
        .get();
    List<Order> orders = new List();
    snapshot.docs.forEach((orderData) {
      print(orderData.data());
      orders.add(Order.fromJson(orderData.data()['details']));
    });
    return orders;
  }
}
