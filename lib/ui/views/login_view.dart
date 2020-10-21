import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_socket_io/exceptions/model_exception.dart';
import 'package:login_socket_io/core/viewmodels/model.dart';
import 'package:login_socket_io/ui/shared/globals.dart';
import 'package:login_socket_io/ui/widgets/button_widget.dart';
import 'package:login_socket_io/ui/widgets/textfield_widget.dart';
import 'package:login_socket_io/ui/widgets/wave_widget.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;

  void _showErrorDialog(String msg, model, context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login failed !'),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: Text('Close'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    Model model = Provider.of(context, listen: false);

    try {
      await model.login();
    } on ModelException catch (error) {
      _showErrorDialog(error.toString(), model, context);
    } catch (error) {
      _showErrorDialog("An unexpected error has occurred !", model, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final model = Provider.of<Model>(context);

    return Scaffold(
      backgroundColor: Global.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height - 200,
            color: Global.mediumBlue,
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 3.7 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 3.0,
              color: Global.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'hero',
                  child: SizedBox(
                    height: 60,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Login Socket-io',
                  style: TextStyle(
                    color: Global.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _form,
              child: ListView(
                shrinkWrap: true,
                padding:
                    EdgeInsets.symmetric(vertical: keyboardOpen ? 70 : 230),
                children: <Widget>[
                  TextFieldWidget(
                    hintText: 'Email',
                    errorText: model.email.error,
                    initialValue: model.email.value,
                    obscureText: false,
                    prefixIconData: Icons.mail_outline,
                    suffixIconData: model.isValid ? Icons.check : Icons.error,
                    onChanged: (value) {
                      model.isValidEmail(value, false);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFieldWidget(
                        hintText: 'Password',
                        errorText: model.password.error,
                        initialValue: model.password.value,
                        obscureText: model.isVisible ? false : true,
                        prefixIconData: Icons.lock_outline,
                        suffixIconData: model.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onChanged: (value) {
                          model.isValidPassword(value, false);
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Global.mediumBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    ButtonWidget(
                      title: 'Log in',
                      hasBorder: false,
                      onTap: _submit,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
