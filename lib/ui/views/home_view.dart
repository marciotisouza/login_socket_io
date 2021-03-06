import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:login_socket_io/core/viewmodels/model.dart';
import "package:login_socket_io/ui/widgets/app_drawer.dart";

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("login-socket-io"),
      ),
      drawer : AppDrawer(),
      body: Center(
        child: Text(model.user),
      ),
    );
  }
}
