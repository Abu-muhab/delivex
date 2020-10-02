import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:node_auth/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

const String domain = 'https://node-flutter.herokuapp.com';
// const String domain = 'http://localhost:8080';
// const String domain = 'http://192.168.43.91:8080';

class AuthProvider extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.isLoggedOut;
  SharedPreferences prefs;
  User user;
  Timer authStateListener;
  bool fetchingUserDetails = false;
  AuthProvider() {
    // IO.Socket socket = IO.io(domain, <String, dynamic>{
    //   'transports': ['websocket'],
    // }).connect();
    // socket.on('connect', (data) {
    //   print('connected');
    // });
    authStateListener = Timer.periodic(Duration(milliseconds: 200), (_) async {
      String token = await getEncodedToken();
      if (token != null) {
        if (authStatus != AuthStatus.isLoggedIn) {
          authStatus = AuthStatus.isLoggedIn;
          notifyListeners();
        }
        if (authStatus == AuthStatus.isLoggedIn &&
            user == null &&
            fetchingUserDetails == false) {
          fetchingUserDetails = true;
          loadUserDetails(tokenDecoder(token)).then((value) {
            fetchingUserDetails = false;
          }).catchError((err) {
            fetchingUserDetails = false;
            print(err);
          });
        }
      } else {
        if (authStatus != AuthStatus.isLoggedOut) {
          authStatus = AuthStatus.isLoggedOut;
          notifyListeners();
        }
      }
    });
  }

  Future<SharedPreferences> getSharedPreferences() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
      return prefs;
    } else {
      return prefs;
    }
  }

  Future<bool> loadUserDetails(String token) async {
    http.Response response = await http.get('$domain/auth/userinfo',
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      Map body = JsonDecoder().convert(response.body);
      if (!body['successful']) {
        throw (body['message']);
      }
      print(body['data']);
      user = User.formJson(body['data']);
      notifyListeners();
      return true;
    }
    throw ('Server Error');
  }

  Future<User> login(String email, String password) async {
    http.Response response = await http.post('$domain/auth/login',
        body: JsonEncoder().convert({"email": email, "password": password}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      Map body = JsonDecoder().convert(response.body);
      if (!body['successful']) {
        throw (body['message']);
      }
      saveToken(body['data']['token']);
      user = User.formJson(body['data']);
      notifyListeners();
      return user;
    }
    throw ('Server Error');
  }

  void signOut() {
    deleteEncodedToken();
  }

  Future<User> signUp(String email, String password, String firstName,
      String lastName, String phoneNumber) async {
    http.Response response = await http.post('$domain/auth/signup',
        body: JsonEncoder().convert({
          "email": email,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
          "phoneNumber": phoneNumber
        }),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      Map body = JsonDecoder().convert(response.body);
      if (!body['successful']) {
        throw (body['message']);
      }
      saveToken(body['data']['token']);
      user = User.formJson(body['data']);
      notifyListeners();
      return user;
    }
    print(response.body);
    throw ('Server Error');
  }

  void saveToken(String token) async {
    SharedPreferences prefs = await getSharedPreferences();
    prefs.setString('encodedToken', tokenEncoder(token));
  }

  void deleteEncodedToken() async {
    SharedPreferences prefs = await getSharedPreferences();
    prefs.setString('encodedToken', '');
  }

  Future<String> getEncodedToken() async {
    try {
      String token;
      SharedPreferences prefs = await getSharedPreferences();
      token = prefs.getString('encodedToken');
      return token == '' ? null : token;
    } catch (err) {
      return null;
    }
  }

  String tokenEncoder(String token) {
    return token;
  }

  String tokenDecoder(String encodedToken) {
    return encodedToken;
  }
}

enum AuthStatus { isLoggedIn, isLoggedOut }
