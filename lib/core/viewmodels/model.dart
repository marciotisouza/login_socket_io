import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:login_socket_io/exceptions/model_exception.dart';
import 'package:login_socket_io/components/Connector.dart' as connector;
import 'package:login_socket_io/ui/validation/validation_itens.dart';

class Model extends ChangeNotifier {
  BuildContext rootBuildContext;

  ValidationItens _email = ValidationItens('tester@gmail.com', null);
  ValidationItens _password = ValidationItens('teste123', null);
  var _user = '';

  ValidationItens get email => _email;
  ValidationItens get password => _password;

  get user => _user;
  get isVisible => _isVisible;
  get isValidate => _isValidate;
  get isValid => _isValid;

  bool _isValid = false;
  bool _isVisible = false;
  bool _isValidate = false;
  //Map<String, String> _response = {};
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  set isValidate(value) {
    _isValidate = value;
    notifyListeners();
  }

  bool isValidEmail(String value, bool mostrar) {
    bool isValidate = false;
    if (value != null) {
      isValidate = EmailValidator.validate(value);
    }
    if (isValidate == true) {
      _email = ValidationItens(value, null);
    } else {
      if (mostrar == true) {
        _email = ValidationItens(value, "Email is not valid !");
      } else {
        _email = ValidationItens(value, null);
      }
    }
    _isValid = isValidate;
    return isValidate;
  }

  bool isValidPassword(String value, bool mostrar) {
    var isValidate = true;
    if (value.length < 6) {
      if (mostrar == true) {
        _password =
            ValidationItens(value, "Password must be at least 6 characters !");
      } else {
        _password = ValidationItens(value, null);
      }
      isValidate = false;
    } else {
      _password = ValidationItens(value, null);
    }
    return isValidate;
  }

  Future<void> login() async {
    return _authenticate();
  }

  Future<void> _authenticate() async {
    var search = true;
    try {
      if (this.isValidEmail(_email.value, true) == false) {
        search = false;
        var modelException = ModelException("INVALID_EMAIL");
        throw modelException;
      }
      if (this.isValidPassword(_password.value, true) == false) {
        search = false;
        var modelException = ModelException("INVALID_PASSWORD");
        throw modelException;
      }
      if (search == true) {
        await connector.validate(_email.value, _password.value)
        .then((data) {
          print(data[0]['status']);
          print("Validate recieved from server : $data");
          resposta(data[0]);
        });
      }
    } on ModelException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resposta(response) {
    if (response["status"] == "ok") {
      _user = response["user"];
      _isValidate = true;
      notifyListeners();
    } else {
      throw ModelException("INCONSISTENT_DATA");
    }
    return Future.value();
  }

  Future<void> tryAutoLogin() async {
    await connector.connectToServer();
    List envio = [
      "envio",
      {"type": "mensagem", "mensagem": "envio da mensagem"}
    ];
    await connector.enviarMesamgem(envio);
    if (isValidate) {
      return Future.value();
    }

    return Future.value();
  }

  void logout() {
    _isValidate = false;
    notifyListeners();
  }
}
