import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/viewmodels/model.dart';
import '../../ui/views/login_view.dart';
import '../../ui/views/home_view.dart';

class LoginHome extends StatefulWidget {

  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Model model = Provider.of(context);

    return FutureBuilder(
      future: model.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return model.isValidate ? HomeView() : LoginView();
        }
      },
    );
  }
}
