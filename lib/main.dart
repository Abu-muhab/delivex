import 'package:flutter/material.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:node_auth/providers/location_provider.dart';
import 'package:node_auth/providers/orders_provider.dart';
import 'package:node_auth/views/login.dart';
import 'package:node_auth/views/orders_view.dart';
import 'package:node_auth/views/pickup_home.dart';
import 'package:node_auth/views/pickup_summary.dart';
import 'package:node_auth/views/select_location.dart';
import 'package:node_auth/views/signup.dart';
import 'package:node_auth/widgets/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => LocationProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(
          primaryColor: kLeichtPrimaryColor,
          accentColor: kLeichtAccentColor,
          floatingActionButtonTheme: Theme.of(context)
              .floatingActionButtonTheme
              .copyWith(backgroundColor: kLeichtPrimaryColor),
          tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
              labelStyle: TextStyle(color: kLeichtPrimaryColor, fontSize: 15),
              labelColor: kLeichtPrimaryColor,
              indicator: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: kLeichtPrimaryColor, width: 3))))),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        "signUp": (context) => SignUp(),
        "login": (context) => Login(),
        "select_location": (context) => WhereToScreen(),
        "pickup_summary": (context) => PickUpSummaryPage(),
        'orders': (context) => Orders(),
        "home": (context) =>
            Consumer<AuthProvider>(builder: (context, authProvider, _) {
              if (authProvider.authStatus == AuthStatus.isLoggedOut) {
                return Login();
              }

              //splash screen
              if (authProvider.user == null) {
                return SplashScreen();
              }

              return PickUpHome();
            })
      },
      initialRoute: 'home',
    );
  }
}
