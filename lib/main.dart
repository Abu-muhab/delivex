import 'package:flutter/material.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:node_auth/providers/location_provider.dart';
import 'package:node_auth/views/login.dart';
import 'package:node_auth/views/pickup_home.dart';
import 'package:node_auth/views/select_location.dart';
import 'package:node_auth/views/signup.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => LocationProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        "signUp": (context) => SignUp(),
        "login": (context) => Login(),
        "select_location": (context) => WhereToScreen(),
        "home": (context) =>
            Consumer<AuthProvider>(builder: (context, authProvider, _) {
              if (authProvider.authStatus == AuthStatus.isLoggedOut) {
                return Login();
              }

              //splash screen
              if (authProvider.user == null) {
                return Scaffold(
                  body: Container(
                    child: Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ),
                  ),
                );
              }

              return PickUpHome();
            })
      },
      initialRoute: 'home',
    );
  }
}
