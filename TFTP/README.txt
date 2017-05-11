8888b.  88 888888 888888      dP""b8  dP"Yb  8b    d8 88""Yb    db    88""Yb 888888 88""Yb 
 8I  Yb 88 88__   88__       dP   `" dP   Yb 88b  d88 88__dP   dPYb   88__dP 88__   88__dP 
 8I  dY 88 88""   88""       Yb      Yb   dP 88YbdP88 88"""   dP__Yb  88"Yb  88""   88"Yb  
8888Y"  88 88     88          YboodP  YbodP  88 YY 88 88     dP""""Yb 88  Yb 888888 88  Yb 


* CONFIGURACION
Hay 8 constantes a tener en cuenta:

Imprime el log en stdout (Y/N)
DEBUG="N"

Borra el archivo de configuracion descargado al finalizar el proceso de comparación (Y/N)
DELETE_CONF_FILE="N"

Cantidad de archivos que se mantendran como histórico
Ej. 5
MAX_FILES_QTY=5

Array con los patrones a excluir (distingue mayusculas de minusculas y admite regexp)
Ej. Excluirá lineas que contengan "NOMBRE" o "FECHA"
EXCLUDE_PATTERNS=("NOMBRE" "FECHA")

Ruta al directorio donde buscara los archivos de configuración nuevos
Ej.
FTP_FILES_PATH="/home/hernan/sources/telecom/telecom/linux-difference/FTP"

Ruta donde buscara y guardara los archivos de configuracion historicos
Ej.
CONF_FILES_PATH="/home/hernan/sources/telecom/telecom/linux-difference/CONF"

Path donde guardara el log de ejecución
Ej.
LOG_PATH="$BASEDIR/log"

Nombre de archivo de log (en este caso se guarda con la fecha de ejecución)
Ej.
LOG_FILE_NAME="$(date +'%Y-%m-%d %H:%M:%S').log"

* PRECONDICIONES
1) Se asume que los archivos de configuración descargados de los equipos se encuentran en un directorio accesible por el script.
2) El directorio de descarga de los archivos y el de almacenaje son distintos
3) El nombre de los archivos descargados de los equipos sigue el siguiente patron: nombre_del_dispositivo.*
Ej.: cisco677.txt o hp3430.conf 
4) El nombre de los archivos historicos (si hubiera) debe seguir el siguiente patron: nombre_del_dispositivo_yyyymmddHHMMSS.*
Ej.: cisco677_20170417114513.txt o hp3430_20170417114600.conf 

* USO 
Una vez descargados los archivos y configuradas las constantes se procederá a la ejecución del archivo diff.sh

Como resultado se verán guardados aquellos archivos que sufrieran modificaciones respecto a su última versión guardada o que no tuvieran archivos anteriores. 
