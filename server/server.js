const io = require("socket.io")(require("http").createServer(function () { }).listen(8088));

/**
 * Handle the socket connection event.  All other events must be hooked up inside this.
 */
io.on("connection", io => {


  console.log("\n\nConnection established with a client");


  // --------------------------------------------- USER MESSAGES ---------------------------------------------


  /**
   * Client emits this to validate the user.
   *
   * inData
   *   { userName : "", password : "" }
   *
   * Callback
   *   { status : "ok|fail|created" }
   * Broadcast (only if status=created)
   *   newUser <the users collection>
   */
  io.on("validate", function (data) {

    console.log("\n\nMSG: validate");

    let args = Array.prototype.slice.call(arguments);
    fn = args.pop();
    var email = data['userName'];
    var password = data['password'];
    Search(email, password, 'login_socket_io')
      .then(response => {
        console.log("User logged in");
        fn({ status: "ok", user: response["user"] });
      })
      .catch(erros => {
        console.log("Password incorrect");
        fn({ status: "fail" });
      })

  }); /* End validate handler. */

  io.on("message", function (data) {
    let args = Array.prototype.slice.call(arguments);
    console.log(args, arguments.length);
    let message = args[1];
    io.emit('message','retorno com sucesso !!!');
  });

}); /* End connection event handler. */


console.log("Server ready");

function Search(email, senha, database) {
  console.log(email);
  return new Promise((resolve, reject) => {
    // Conecta com a base MySql
    const connection = require("mysql").createConnection({
      host: 'localhost',
      port: 3306,
      user: 'runner',
      password: 'runner@20@12',
      database: database
    });
    connection.query('SELECT * FROM `perfil`  WHERE `PER_EMA` = ?',
      [email],
      function (error, results, fields) {
        if (error) {
          reject(false)
        }
        if (results.length > 0) {
          var result = results[0];
          resolve({ user: result["PER_NOM"] })
        } else {
          reject(false)
        }
      })
  })
}
