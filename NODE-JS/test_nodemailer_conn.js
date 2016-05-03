var nodemailer = require("nodemailer");

var contact = {subject: 'Resumen Mensajes syslog', message: "Resumen Mensajes syslog", email: 'root@unknown'};
var to = "x304300@unknown";
var transporter = nodemailer.createTransport();

transporter.sendMail({
  from: contact.email,
  to: to,
  subject: contact.subject,
  text: contact.message

}, function(error, info){
    if(error){
        console.log(error);
    }else{
        console.log('Message sent: ' + info.response);
    }
});
