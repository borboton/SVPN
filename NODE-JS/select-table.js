var oracledb = require('oracledb');
var dbConfig = require('./dbconfig.js');
var nodemailer = require('nodemailer');

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
    var id_polling = 1 
    connection.execute(
      'select nombre, \n' +
      '       modelo, \n' +
      '       marca \n' +
      'from equipos \n' +
      'where id_polling = :id_polling \n' +
      'and ROWNUM < 10' ,
      {
        id_polling: id_polling
      },

      function(err, result)
      {
        if (err) {
          console.error(err.message);
          doRelease(connection);
          return;
        } 
     //   console.log(result.rows.length);
        var results = "<table class='table'>" 
        var cant = result.rows.length;

        for( i=0 ; i < cant ; i++ ){

            var row = result.rows[i]
            results = results + "<tr>"

            row.forEach(function (entry) {
            results = results + "<td>" + entry + "</td>"
            });

            results = results + "</tr>"

        }
        
        console.log(results) ;
        doRelease(connection);  

        return results + "</table>"
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


