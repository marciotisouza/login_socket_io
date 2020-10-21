class ModelException implements Exception {
  static const Map<String, String> errors = {
    "OPERATION_NOT_ALLOWED": "Operation not allowed!",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "Try later!",
    "EMAIL_NOT_FOUND": "Email not found!",
    "INVALID_PASSWORD": "invalid password!",
    "USER_DISABLED": "User disabled!",
    "INVALID_EMAIL": "Invalid email!",
    "INCONSISTENT_DATA": "Inconsistent Data!",
  };

  final String key;

  const ModelException(this.key);

  @override
  String toString() {
    if(errors.containsKey(key)) {
      return errors[key];
    } else {
      return "An authentication error has occurred!";
    }
  }
}
