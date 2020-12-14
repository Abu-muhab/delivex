import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:node_auth/providers/location_provider.dart';
import 'package:node_auth/providers/orders_provider.dart';
import 'package:node_auth/views/edit_account.dart';
import 'package:node_auth/views/login.dart';
import 'package:node_auth/views/orders_view.dart';
import 'package:node_auth/views/overview.dart';
import 'package:node_auth/views/pickup_summary.dart';
import 'package:node_auth/views/select_location.dart';
import 'package:node_auth/views/settings.dart';
import 'package:node_auth/views/signup.dart';
import 'package:node_auth/widgets/page_holder.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        'settings': (context) => Settings(),
        'edit_account': (context) => EditAccount(),
        'overview': (context) => Overview(),
        "home": (context) =>
            Consumer<AuthProvider>(builder: (context, authProvider, _) {
              if (authProvider.firebaseUser == null) {
                return Login();
              }
              return PageHolder();
            })
      },
      initialRoute: 'home',
    );
  }
}
