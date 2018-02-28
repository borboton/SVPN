#!/bin/bash
export SVPN_HOME=/svpn
export SVPN_LOG=/svpn/log
export LOGNAME=x304300
. ${SVPN_HOME}/conf/.auth
. ${SVPN_HOME}/conf/db.env

from="SCANNET Fault Management <scannet@teco.com.ar>"
fecha=`date +%c`
date=`date "+%Y-%m-%d_%H"`
sqlfile=/svpn/scripts/sql/$1.sql
user="$2"
csvfile=${SVPN_HOME}/interfaz/tx/equality/Disponibilidad_semanal_${date}.csv
subject="ScanNET Disponibilidad ADSL"
boundary="ZZ_/afg6432dfgkl.94531q"
ownboundary="unique-boundary-$RANDOM"

echo  "DISPOSITIVO;PORCENTAJE_PERIODO;MINUTOS_INDISPONIBLE;MINUTOS;CANTIDAD_ALARMAS;MODELO;ZONA;CLIENTE" > $csvfile

log(){
    echo $(date "+%Y-%m-%d %H:%M:%S")" - $1"  
}

log "[ Inicio generacion de archivo csv ]" >> ${SVPN_LOG}/scriptReporteGenerico.log 
$ORACLE_HOME/bin/sqlplus -S ${DBUSER}/${DBPASS}@${ORACLE_SID} @$sqlfile $user >> $csvfile 
address=$(cat /svpn/scripts/address/emailadress.txt)

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

  <span>Scan<b>NET</b></span>

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
