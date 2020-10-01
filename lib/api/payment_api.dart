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

  Future<CheckoutResponse> beginTransaction(
      BuildContext context, Map<String, String> transactionRef) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    PaymentCard card = PaymentCard(
        number: '4084084084084081', cvc: '408', expiryMonth: 4, expiryYear: 21);
    Charge charge = Charge()
      ..accessCode = transactionRef['access_code']
      ..card = card
      ..amount = 300000
      ..reference = transactionRef['reference']
      ..email = authProvider.user.email;
    return PaystackPlugin.checkout(context, charge: charge);
  }

  Future<Map<String, String>> initializeTransaction(
      BuildContext context, PickUpActivity summary) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    http.Response response = await http.post('$domain/payment/initialize',
        body: JsonEncoder().convert({
          'amount': 300000,
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
      print(body['data']['data']['reference']);
      return {
        'access_code': body['data']['data']['access_code'],
        'reference': body['data']['data']['reference']
      };
    }
    throw ('Server Error');
  }
}
