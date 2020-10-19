import 'dart:async';
import "package:flutter_socket_io/flutter_socket_io.dart";
import "package:flutter_socket_io/socket_io_manager.dart";

// The URL of the server.
String serverURL = "http://192.168.0.60:8088";

// The one and only SocketIO instance.
SocketIO _io;

// ------------------------------ NONE-MESSAGE RELATED METHODS ------------------------------

/// Connect to the server.  Called once from LoginDialog.
///
Future<void> connectToServer(final Function inCallback) async {

  print("## Connector.connectToServer(): serverURL = $serverURL");
  // Connect to server and when the connect mesage comes back, call the specified callback.
  _io = SocketIOManager().createSocketIO(serverURL, "/", query: "", socketStatusCallback :
    (inData) {
      print("## Connector.connectToServer(): callback(1): inData = $inData");
      if (inData == "connect") {
        print("## Connector.connectToServer(): callback: Connected to server");
        // Hook up message listeners.
        // Call the callback so the app can continue to start up.
        inCallback();
      }
    }
  );

// THIS IS ONLY FOR DEVELOPMENT SO THAT WE GET A FRESH SOCKET AFTER A HOT RELOAD (THE ABOVE CALLBACK WILL NOT HAVE EXECUTED BECAUSE A SOCKET ALREADY EXISTS, BUT WE NEED IT TO, SO THIS EFFECTIVELY FORCES IT)
_io.destroy();
_io = SocketIOManager().createSocketIO(serverURL, "/", query: "", socketStatusCallback :
  (inData) {
    print("## Connector.connectToServer(): callback(2): inData = $inData");
    if (inData == "connect") {
      print("## Connector.connectToServer(): callback: Connected to server");
      inCallback();
    }
  }
);

  _io.init();
  _io.connect();

} /* End connectToServer(). */


// ------------------------------ MESSAGE SENDER METHODS ------------------------------


/// Validate the user.  Called from LoginDialog when there were no stored credentials for the user.
///
/// @param inUserName The username they entered.
/// @param inPassword The password they entered.
/// @param inCallback The function to call when the response comes back.  Is passed the status.
Future<void> validate(final String inUserName, final String inPassword, final Function inCallback) async {

  print("## Connector.validate(): inUserName = $inUserName, inPassword = $inPassword");

  // Call server to validate.
  await _io.sendMessage("validate",
    "{ \"userName\" : \"$inUserName\", \"password\" : \"$inPassword\" }",
    (inData) {
      print("## Connector.validate(): callback: inData = $inData");
      // Call the specified callback, passing it the response.
      inCallback(inData);
   }
  );

} /* End validate(). */
