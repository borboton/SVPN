var nodemailer = require('nodemailer');
var oracledb = require('oracledb');
var dbConfig = require('./dbconfig.js');
var contenidoHtml = '' ;
var id_polling = 1 ;

oracledb.getConnection({ 

    user          : dbConfig.user,
    password      : dbConfig.password,
    connectString : dbConfig.connectString
  },
  function(err, connection){
    if (err) {
      console.error(err.message);
      return;
    }
    console.log('Connection was successful!');

connection.execute(
      'select nombre, \n' +
      '       modelo, \n' +
      '       marca \n' +
      'from equipos \n' +
      'where id_polling = :id_polling \n' +
      'and ROWNUM < 10' , 
     {
       id_polling: id_polling // bind var
     },

  function(err, result){
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
        
    contenidoHtml = results + "</table>";
    doRelease(connection);  

    var transport = nodemailer.createTransport("Sendmail", "/usr/sbin/sendmail")
    var mailList = 'root@unknown';

    var mailOptions = {
        generateTextFromHTML: true,
        from: '"SVPN Fault Management" <root@unknown>', // sender address
        to: mailList,  // list of receivers
        subject: 'Resumen Mensajes Syslog', // Subject line
        html: contenidoHtml // html body
    };
    //console.log('2 ' + contenidoHtml);

    transport.sendMail(mailOptions, function(error, info){

    if(error){
        return console.log(error);
    }
    // console.log('sendMail ' + contenidoHtml) ;
    // console.log('Message sent: ' + info.response);
    });
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

