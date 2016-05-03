var nodemailer = require('nodemailer'); 
//var transport = nodemailer.createTransport();
//var transport = nodemailer.createTransport("direct", {debug: true});
var transport = nodemailer.createTransport("Sendmail", "/usr/sbin/sendmail")

/*
var mailOptions = {
    generateTextFromHTML: true,
    from: '"SVPN Fault Management" <root@unknown>', // sender address
    to: 'root@unknown', //, x304300@unknown', // list of receivers
    subject: 'Resumen Mensajes Syslog', // Subject line
 //   text: 'Resumen Mensajes Syslog body text', // plaintext body
    html: '<h3>Resumen Mensajes Syslog body html</h3>' // html body

}*/


transport.sendMail({
    from: '"SVPN Fault Management" <root@unknown>', // sender address
    to: 'root@unknown, x304300@unknown', // list of receivers
    subject: 'Resumen Mensajes Syslog', // Subject line
    text: 'Resumen Mensajes Syslog body text', // plaintext body
    html: '<h3>Resumen Mensajes Syslog body html</h3>' // html body

}, console.error);

// send mail with defined transport object
transport.sendMail(function(error, response){
    if(error){

        console.log('Mensaje log error');
        console.log(error);

    } else {

        console.log('Enviando mensaje...');
        console.log("Message sent: " + response.message);
    }
});
