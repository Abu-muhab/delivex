import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    QuerySnapshot snapshot2;
    snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: authProvider.firebaseUser.uid)
        .where('deliveryStatus', isEqualTo: 'pendingPickup')
        .where('paymentVerified', isEqualTo: true)
        .get();
    snapshot2 = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: authProvider.firebaseUser.uid)
        .where('deliveryStatus', isEqualTo: 'pendingDelivery')
        .where('paymentVerified', isEqualTo: true)
        .get();
    List<Order> orders = new List();
    List<QueryDocumentSnapshot> shots = [];
    shots.addAll(snapshot.docs);
    shots.addAll(snapshot2.docs);
    shots.forEach((orderData) {
      Map json = orderData.data()['details'];
      json.putIfAbsent('amount', () => orderData.data()['amount']);
      Timestamp timestamp = orderData.data()['paymentVerificationTime'];
      json.putIfAbsent(
          'date',
          () =>
              timestamp.toDate().day.toString() +
              "/" +
              timestamp.toDate().month.toString() +
              "/" +
              timestamp.toDate().year.toString());
      orders.add(Order.fromJson(json));
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
        .where('deliveryStatus', isEqualTo: 'completed')
        .get();
    List<Order> orders = new List();
    snapshot.docs.forEach((orderData) {
      Map json = orderData.data()['details'];
      json.putIfAbsent('amount', () => orderData.data()['amount']);
      Timestamp timestamp = orderData.data()['paymentVerificationTime'];
      json.putIfAbsent(
          'date',
          () =>
              timestamp.toDate().day.toString() +
              "/" +
              timestamp.toDate().month.toString() +
              "/" +
              timestamp.toDate().year.toString());
      orders.add(Order.fromJson(json));
    });
    return orders;
  }
}
