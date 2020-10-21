import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_socket_io/core/viewmodels/model.dart';
import 'package:login_socket_io/ui/views/login_view.dart';
import 'package:login_socket_io/ui/views/home_view.dart';

class LoginHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Model model = Provider.of(context);
    return FutureBuilder(
      future: model.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('An error has occurred!'));
        } else {
          return model.isValidate ? HomeView() : LoginView();
        }
      },
    );
  }
}
