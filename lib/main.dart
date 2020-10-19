import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/views/home_view.dart';
import 'ui/views/login_home.dart';
import 'core/viewmodels/model.dart';
import 'utils/app_routes.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Model(),
      child: MaterialApp(
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.AUTH_HOME: (ctx) => LoginHome(),
          AppRoutes.HOME: (ctx) => HomeView(),
        },
      ),
    );
  }
}
