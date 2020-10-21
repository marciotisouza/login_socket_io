import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_socket_io/core/viewmodels/model.dart';
import 'package:login_socket_io/utils/app_routes.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context, listen: false);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Welcome ${model.user}!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.AUTH_HOME,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Exit'),
            onTap: () {
              Provider.of<Model>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
