import 'package:flutter/material.dart';

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
}
