#!/bin/bash
export SVPN_HOME=/svpn
export SVPN_LOG=/svpn/log
export LOGNAME=x304300
. ${SVPN_HOME}/conf/.auth
. ${SVPN_HOME}/conf/db.env
fecha=`date +%c`
from="SCANNET Fault Management <scannet@teco.com.ar>"
subject="ScanNET Disponibilidad"
ownboundary="unique-boundary-$RANDOM"
address=$(cat /svpn/scripts/address/emailadress.txt)

csvfile=$1
log(){
    echo $(date "+%Y-%m-%d %H:%M:%S")" - $1"  
}

for to in ${address} ; do 
    file=${csvfile}
    log "[ Enviando mail to $to ... ]" >> ${SVPN_LOG}/scriptReporteGenerico.log
    sleep 1s
{
printf '%s\n' "From: $from
To: $to
Subject: $subject
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=\"${ownboundary}\"

--${ownboundary}
Mime-Version: 1.0
Content-Type: text/html; charset=\"us-ascii\"
Content-Transfer-Encoding: 7bit

<body bgcolor=#F2F2F2 lang=ES link=blue vlink=purple style='tab-interval:35.4pt'>
    <div class=WordSection1>
        <div align=center>
        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=100% style='width:100.0%;background:#F2F2F2;mso-background-themecolor:background1;mso-background-themeshade:242;border-collapse:collapse;mso-yfti-tbllook:1184;mso-padding-alt:0cm 0cm 0cm 0cm'>
        <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'>
        <td valign=top style='padding:0cm 0cm 0cm 0cm'>
            <div align=center>
            <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=560 style='width:420.0pt;border-collapse:collapse;mso-yfti-tbllook:1184;mso-padding-alt:0cm 0cm 0cm 0cm'>
            <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes;height:29.15pt'>
            <td width='87%' valign=top style='width:87.5%;padding:15.0pt 38.25pt 15.0pt 38.25pt;height:29.15pt'>
            <p class=MsoNormal align=center style='mso-margin-top-alt:auto;mso-margin-bottom-alt:auto;text-align:center'>
            <b><span style='font-size:18.0pt;mso-bidi-font-size:11.0pt;font-family:Consolas;'>Scan</span></b>
            <span style='font-size:18.0pt;mso-bidi-font-size:11.0pt;font-family:Consolas;;color:#7F7F7F;mso-themecolor:background1;mso-themeshade:128;mso-style-textfill-fill-color:#7F7F7F;mso-style-textfill-fill-themecolor:background1;mso-style-textfill-fill-alpha:100.0%;mso-style-textfill-fill-colortransforms:lumm=50000'>NET</span>
            </p>
            </td>
            </tr>
            </table>
            </div>
         </td>
         </tr>
        </table>
        </div>
        <div align=center>
        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=50% style='display:table;border:dotted windowtext 1.0pt;border-top:none;mso-border-top-alt:dotted windowtext .5pt;mso-border-alt:dotted windowtext .5pt;padding:0cm 0cm 0cm 0cm;height:100.0pt;border-collapse:collapse;margin: 20px;border-spacing:0px;border-color:#F0F0F0;width:50.0%;background:#F2F2F2;mso-background-themeshade:242;mso-yfti-tbllook:1184;mso-padding-alt:0cm 0cm 0cm 0cm;font-size:10.0pt;font-family:Verdana,sans-serif;'>
        <tr><th style='text-align:left;padding:10px;font-size:18px;'>Título</th></tr>
        <tr align='center'>
        <td>
            <table class=MsoNormalTable border=1 cellspacing=5 cellpadding=5 width='100%' 
            style='display:table;
                    border-collapse:collapse;
                    border-spacing:0px;                  
                    border:outset #A6A6A6 1.0pt;
                    mso-border-themeshade:166;
                    mso-border-alt:outset #A6A6A6 .75pt;
                    width:98.0%;                   
                    mso-background-themecolor:background1;
                    mso-background-themeshade:242;
                    mso-yfti-tbllook:1184;
                    mso-padding-alt:0cm 0cm 0cm 0cm;
                    font-size:10.0pt;
                    font-family:Verdana,sans-serif;'>
            <tr>
                <td style='padding: 5px;'>Nombre Reporte: </td>
                <td style='padding: 5px;'></td>
            </tr>
            <tr>
                <td style='padding: 5px;'>Archivo: </td>
                <td style='padding: 5px;'>${csvfile}</td>                 
            </tr>
            <tr>
                <td style='padding: 5px;'>Fecha Ejecucion</td>
                <td style='padding: 5px;'>${fecha}</td>
            </tr>
            </table>
        </td>
        </tr>
        <tr><td style='text-align:left;padding:10px;font-size:10px;'>Telecom Argentina 2018</td>
        </tr>
        </table>
        </div>
    </div>
</body>


--${ownboundary}
"
printf '%s\n' "--${ownboundary}
Mime-Version: 1.0
Content-Type: $mimetype
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"$(basename "$file")\"
"
base64 "$file" 
echo
printf '%s\n' "--${ownboundary}--"
} |sendmail -t -oi 
done 2>> ${SVPN_LOG}/scriptReporteGenerico.log 
