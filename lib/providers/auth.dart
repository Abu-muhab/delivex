import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:node_auth/models/user.dart' as UserModel;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

const String domain =
    'https://us-central1-delivery-client-5f214.cloudfunctions.net';

class AuthProvider extends ChangeNotifier {
  UserModel.User user;
  User firebaseUser;
  bool fetchingUserDetails = false;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      this.firebaseUser = firebaseUser;
      if (firebaseUser != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .snapshots()
            .listen((userDetails) {
          if (userDetails.data() != null) {
            user = UserModel.User.formJson(userDetails.data());
            notifyListeners();
          } else {
            user = UserModel.User();
            notifyListeners();
          }
        });
      }
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> signUp(
      String email, String password, BuildContext context) async {
    http.Response response =
        await http.get('$domain/signUp?email=$email&password=$password');
    if (response.statusCode == 200) {
      Map body = JsonDecoder().convert(response.body);
      if (body['successful'] == true) {
        login(email, password).then((value) {
          Navigator.pushReplacementNamed(context, "home");
        });
      } else {
        throw (body['error']['message']);
      }
    } else {
      throw ('Something went wrong. Try again');
    }
  }
}
