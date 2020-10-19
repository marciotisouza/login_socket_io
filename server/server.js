// construct an HTTP server, wrapped in an Socket.IO server, and start it up.
const io = require("socket.io")(require("http").createServer(function(){}).listen(8088));

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
  io.on("validate", (inData, inCallback) => {

    console.log("\n\nMSG: validate");

    console.log(`inData = ${JSON.stringify(inData)}`);

    Search(inData.userName,inData.password,'login_socket_io')
    .then( response => {
      console.log("User logged in");
      console.log(response);
      inCallback({ status : "ok" , user : response["user"] });
    })
    .catch( erros => {
      console.log("Password incorrect");
      inCallback({ status : "fail" });
    })

  }); /* End validate handler. */

}); /* End connection event handler. */


console.log("Server ready");

function Search(email,senha,database){
  return new Promise((resolve, reject) => {
    // Conecta com a base MySql
    const connection = require("mysql").createConnection({
      host     : 'localhost',
      port     : 3306,
      user     : 'user',
      password : 'password',
      database : database
    });
    connection.query('SELECT * FROM `perfil`  WHERE `PER_EMA` = ?', 
                    [email],
                    function (error, results, fields) {
      if (error){
        //throw error
        reject(false) 
      } 
      if( results.length > 0 ){
        var result = results[0] ;
        console.log(result)
        /*if( result['PER_PAS'] === senha ){
          resolve(true) 
        }*/
        resolve({ user : result["PER_NOM"] }) 
      }else{
        reject(false) 
      }
    })
  })
}
