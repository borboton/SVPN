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
        //console.log(result.metaData);
        console.log(result.rows.length);
        //console.log(result.rows.item);
        

        result.rows.forEach(function(row) {

         var job = {};
            job.nombre = row[0];
            job.modelo = row[1];
            job.marca = row[2];
        console.log (job);

        });
        /*
        var i
        for( i=0 ; i < result.rows.length ; i++ ){
        } */
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
