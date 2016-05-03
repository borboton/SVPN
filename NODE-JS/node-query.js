
//load the oracledb library
var oracledb = require('oracledb');
var dbConfig = require('./dbconfig.js');
//load the simple oracledb
var SimpleOracleDB = require('simple-oracledb');

//modify the original oracledb library
SimpleOracleDB.extend(oracledb);

//from this point connections fetched via oracledb.getConnection(...) or pool.getConnection(...)
//have access to additional functionality.
oracledb.getConnection(function onConnection(error, connection) {
    if (error) {
        //handle error
    } else {
        //work with new capabilities or original oracledb capabilities
    connection.query('SELECT department_id, department_name FROM departments WHERE manager_id < :id', [110], function onResults(error, results) {
    if (error) {
    //handle error...
    } else {
    //print the 4th row DEPARTMENT_ID column value
    console.log(results[3].DEPARTMENT_ID);
     }
    });

    }
});


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

      console.log('Connection was successful!');
    connection.query('SELECT * from MIBS where ID_MIB = 1' , function onResults(error, results) {
    if (error) {
    //handle error... 
      } else {
    //print the 4th row DEPARTMENT_ID column value 
    console.log(results[3].DEPARTMENT_ID);
     }
    });

    connection.execute(
/*
   'SELECT elemento, alarma, total FROM(SELECT elemento,alarma,SUM(cantidad) total, TRUNC(fecha_insercion_inicial) fecha FROM resumen_mensajes_log WHERE TRUNC(fecha_insercion_inicial) > SYSDATE - 7 AND tipo_mensaje = 'syslog' GROUP BY TRUNC (fecha_insercion_inicial), elemento, alarma, tipo_mensaje ORDER BY total DESC ',

/*
        "SELECT * " +
        "FROM mibs "  +
        "WHERE ID_MIB = 1",
*/
//      [180],

      function(err, result)
      {
        if (err) {
          console.error(err.message);
          doRelease(connection);
          return;
        }
        console.log(result.metaData);
       console.log(result.rows);
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
