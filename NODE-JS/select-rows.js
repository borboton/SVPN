var oracledb = require('oracledb');
var dbConfig = require('./dbconfig.js');

oracledb.getConnection(
  {

    user          : dbConfig.user,
    password      : dbConfig.password,
    connectString : dbConfig.connectString
  },
  function(err, connection) 
  {
    if (err) {
      console.error(err.message);
      return;
    }
    //console.log('Connection was successful!');
    connection.execute(
      "select nombre, modelo, marca from equipos where ROWNUM < 10 " ,

      function(err, result)
      {
        if (err) {
          console.error(err.message);
          doRelease(connection);
          return;
        }
        //console.log(result.metaData);
        //console.log(result.rows);

        var cars = ["BMW", "Volvo", "Saab", "Ford"];
        var text = "";
        var i;

        for (i = 0; i < cars.length; i++) {
          text += cars[i] + "<br>";
        }

        //console.log(text);
        doRelease(connection);
      });
  });

function doRelease(connection)
{
  connection.release(
    function(err) {
      if (err) {
        console.error(err.message);
      }
    });
}
