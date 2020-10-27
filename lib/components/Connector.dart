import 'dart:async';
import "dart:convert";
import 'package:adhara_socket_io/adhara_socket_io.dart';

// The URL of the server.
const String URI = "http://192.168.0.60:8088";
SocketIO sockets;
// The one and only SocketIO instance.
SocketIOManager manager;

// ------------------------------ NONE-MESSAGE RELATED METHODS ------------------------------

/// Connect to the server.  Called once from LoginDialog.
///
Future<void> connectToServer() async {
  manager = SocketIOManager();

  print("## Connector.connectToServer(): serverURL = $URI");
  SocketIO socket = await manager.createInstance(SocketOptions(
      //Socket IO server URI
      URI,
      nameSpace: "/",
      //Query params - can be used for authentication
      query: {
        "auth": "--SOME AUTH STRING---",
        "info": "new connection from adhara-socketio",
        "timestamp": DateTime.now().toString()
      },
      //Enable or disable platform channel logging
      enableLogging: false,
      transports: [
        Transports.WEB_SOCKET /*, Transports.POLLING*/
      ] //Enable required transport
      ));
  socket.onConnect((data) {
    print("connected...");
  });
  socket.onConnectError(pprint);
  socket.onConnectTimeout(pprint);
  socket.onError(pprint);
  socket.onDisconnect(pprint);
  socket.on("validate", (data) => pprint(data));
  socket.on("message", (data) => pprint(data));
  socket.connect();
  sockets = socket;
}
// ------------------------------ MESSAGE SENDER METHODS ------------------------------

/// Validate the user.  Called from LoginDialog when there were no stored credentials for the user.
///
/// @param inUserName The username they entered.
/// @param inPassword The password they entered.
Future<List> validate(final String inUserName, final String inPassword) async {
  print(
      "## Connector.validate(): inUserName = $inUserName, inPassword = $inPassword");
  var response;
  await sockets.emitWithAck("validate", [
    {"userName": inUserName, "password": inPassword}
  ]).then((data) {
    // this callback runs when this specific message is acknowledged by the server
    pprint("ACK recieved from server : $data");
    response = data;
    return Future.value(response);
  });
  return Future.value(response);
} /* End validate(). */

Future<void> enviarMesamgem(final List inData) async {
  // Call server to validate.
  print("## Connector.emit(): ");
  await sockets.emit("message", inData);
}

pprint(data) {
  if (data is Map) {
    data = json.encode(data);
  }
  print(data);
}
