import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:node_auth/views/pickup_summary.dart';
import 'package:provider/provider.dart';

class PaymentApi {
  static PaymentApi _instance;
  static String paystackPublicKey =
      "pk_test_de2fcaf6d6d94dd396f2b09aecf498fa5a8aa97f";

  PaymentApi._();

  static Future<PaymentApi> getInstance() async {
    if (_instance == null) {
      await initialize();
      _instance = PaymentApi._();
    }
    return _instance;
  }

  static Future<dynamic> initialize() {
    return PaystackPlugin.initialize(publicKey: paystackPublicKey);
  }

  Future<dynamic> getDeliveryFee(distance) async {
    try {
      String url =
          'https://us-central1-delivery-client-5f214.cloudfunctions.net/calculateDeliveryFee?distance=$distance';
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        Map data = JsonDecoder().convert(response.body);
        if (data['successful'] == true) {
          return data['data'];
        }
        return null;
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<CheckoutResponse> beginTransaction(
      BuildContext context, Map<String, String> transactionRef, fee) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    PaymentCard card = PaymentCard(
        number: '4084084084084081', cvc: '408', expiryMonth: 4, expiryYear: 21);
    Charge charge = Charge()
      ..accessCode = transactionRef['access_code']
      ..card = card
      ..amount = double.parse(fee.toString()).toInt() * 100
      ..reference = transactionRef['reference']
      ..email = authProvider.user.email;
    return PaystackPlugin.checkout(context, charge: charge);
  }

  Future<Map<String, String>> initializeTransaction(
      BuildContext context, PickUpActivity summary, fee) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    http.Response response = await http.post('$domain/initializeTransaction',
        body: JsonEncoder().convert({
          'email': authProvider.user.email,
          'userId': authProvider.firebaseUser.uid,
          'amount': double.parse(fee.toString().trim()).toInt(),
          'details': {
            'from':
                authProvider.user.firstName + " " + authProvider.user.lastName,
            'to': summary.receiversName,
            'fromLocationName': summary.pickupLocation.name,
            'toLocationName': summary.dropOffLocation.name,
            'fromCoords': summary.pickupLocation.latitude.toString() +
                "," +
                summary.pickupLocation.longitude.toString(),
            'toCoords': summary.dropOffLocation.latitude.toString() +
                "," +
                summary.dropOffLocation.longitude.toString(),
            'fromContact': authProvider.user.phoneNumber,
            'toContact': summary.receiversPhone
          }
        }),
        headers: {'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      Map body = JsonDecoder().convert(response.body);
      if (!body['successful']) {
        throw (body['message']);
      }
      print(body['data']['data']['reference']);
      return {
        'access_code': body['data']['data']['access_code'],
        'reference': body['data']['data']['reference']
      };
    }
    throw ('Server Error');
  }

  Future<Map<String, String>> initializeWalletTransaction(
      BuildContext context, fee) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    http.Response response =
        await http.post('$domain/initializeWalletTransaction',
            body: JsonEncoder().convert({
              'email': authProvider.user.email,
              'userId': authProvider.firebaseUser.uid,
              'amount': double.parse(fee.toString().trim()).toInt()
            }),
            headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Map body = JsonDecoder().convert(response.body);
      if (!body['successful']) {
        throw (body['message']);
      }
      print(body['data']['data']['reference']);
      return {
        'access_code': body['data']['data']['access_code'],
        'reference': body['data']['data']['reference']
      };
    }
    throw ('Server Error');
  }
}
