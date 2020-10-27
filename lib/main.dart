import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ui/views/home_view.dart';
import './ui/views/login_home.dart';
import './core/viewmodels/model.dart';
import './utils/app_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Model(),
      child: MaterialApp(
        initialRoute: AppRoutes.AUTH_HOME,
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.AUTH_HOME: (ctx) => LoginHome(),
          AppRoutes.HOME: (ctx) => HomeView(),
        },
      ),
    );
  }
}
