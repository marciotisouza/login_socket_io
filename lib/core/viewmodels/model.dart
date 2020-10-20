import 'dart:async';
import "dart:convert";
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:email_validator/email_validator.dart';
import '../../components/Connector.dart' as connector;
import '../../ui/validation/validation_itens.dart';
import '../../exceptions/model_exception.dart';

class Model extends ChangeNotifier {
  BuildContext rootBuildContext;

  ValidationItens _email = ValidationItens('teste@gmail.com', null);
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
        _email = ValidationItens(value, "O email não é válido !!!");
      } else {
        _email = ValidationItens(value, null);
      }
    }
    _isValid = isValidate;
    notifyListeners();
    return isValidate;
  }

  bool isValidPassword(String value, bool mostrar) {
    var isValidate = true;
    if (value.length < 6) {
      if (mostrar == true) {
        _password =
            ValidationItens(value, "A senha tem que ter no minimo 6 caracteres");
      } else {
        _password = ValidationItens(value, null);
      }
      isValidate = false;
    } else {
      _password = ValidationItens(value, null);
    }
    notifyListeners();
    return isValidate;
  }

  Future<void> login() async {
    return _authenticate();
  }

  Future<void> _authenticate() async {
    var search = true;
    if (this.isValidEmail(_email.value, true) == false ){
        search = false;
    } 
    if( this.isValidPassword(_password.value, true) == false) {
        search = false;
    }
    if( search == true ){
      await connector.connectToServer(() async {
        await connector.validate(_email.value, _password.value, (inStatus) {
          var _response = jsonDecode(inStatus);
          if (_response["status"] == "ok") {
            _user = _response["user"];
            _isValidate = true;
            notifyListeners();
          } else {
            _isValidate = false;
            var modelException = ModelException("OPERATION_NOT_ALLOWED");
            return throw modelException;
          }
        });
      });
    }
  }

  Future<void> tryAutoLogin() async {
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
