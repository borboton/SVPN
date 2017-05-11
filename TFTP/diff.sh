#!/bin/bash
BASEDIR=/scannet/Tools/TFTP
#################################
#								#
#	CONFIGURATION PROPERTIES	#
#								#
#################################

#Prints log in stdout
DEBUG="Y" 

#Deletes the configuration file at the end
DELETE_CONF_FILE="N"

#Max files quantity for device
MAX_FILES_QTY=5

#Array of patterns to exclude from files
EXCLUDE_PATTERNS=()

#Download FTP file path
FTP_FILES_PATH="$BASEDIR/FTP"

#Configuration files path
CONF_FILES_PATH="$BASEDIR/CONF"

#Log path
LOG_PATH="$BASEDIR/log"

#Log file name
LOG_FILE_NAME="$(date +'%Y-%m-%d %H:%M:%S').log"

#################################
#								#
#			FUNCTIONS			#
#								#
#################################

get_device_files_qty()
{
	log "Calculando cantidad de archivos historicos para el dispositivo: $deviceName"
	historyFilesQty=$(ls $CONF_FILES_PATH/$deviceName* 2> /dev/null | wc -l)
	log "Se encontraron $historyFilesQty archivos historicos"
}

get_last_device_file()
{
	log "Buscando el ultimo archivo de configuracion guardado para el dispositivo: $deviceName"
	cd $CONF_FILES_PATH
	lastDeviceFile=""
	lastFileDate=0
	for file in $deviceName*; do 
 		fileDate=$(date -d "$(get_date_from_file $file | sed -r 's/(.{8})(..)(..)(..)/\1 \2:\3:\4/')" +'%s')
 		if [ $fileDate -gt $lastFileDate ]; then
 			lastDeviceFile=$file
 			lastFileDate=$(date -d "$(get_date_from_file $lastDeviceFile | sed -r 's/(.{8})(..)(..)(..)/\1 \2:\3:\4/')" +'%s')
 		fi
 	done; 
 	if [ -z "$lastDeviceFile" ]; then
 		log "No se encontraron archivos de configuracion guardados para el dispositivo"
 	else
 		log "El ultimo archivo guardado es: $lastDeviceFile"
 	fi
}

get_oldest_device_file()
{
	log "Buscando el archivo de configuracion mas antiguo para el dispositivo: $deviceName"
	cd $CONF_FILES_PATH
	firstDeviceFile=""
	firstFileDate=$(date +'%s')
	for file in $deviceName*; do #Like ls 
 		fileDate=$(date -d "$(get_date_from_file $file | sed -r 's/(.{8})(..)(..)(..)/\1 \2:\3:\4/')" +'%s')
 		if [ $fileDate -lt $firstFileDate ]; then
 			firstDeviceFile=$file
 			firstFileDate=$(date -d "$(get_date_from_file $firstDeviceFile | sed -r 's/(.{8})(..)(..)(..)/\1 \2:\3:\4/')" +'%s')
 		fi
 	done;
 	if [ -z "$firstDeviceFile" ]; then
 		log "No se encontraron archivos de configuracion guardados para el dispositivo"
 	else
 		log "El archivo más antiguo es: $firstDeviceFile"
 	fi
}

get_compare_files_command()
{
	cmd=""
	if [ ${#EXCLUDE_PATTERNS[@]} -ne 0 ]; then
		for pattern in ${EXCLUDE_PATTERNS[@]}; do
			if [ -z "$cmd" ]; then
				cmd="grep -v $pattern $1 "
			else
				cmd+="| grep -v $pattern "
			fi	
		done;
	else
		cmd="cat $1"
	fi
	echo $cmd
}

get_date_from_file()
{	
	arr=(${1//'_'/$'\n'})
	arr=(${arr[1]//'.'/$'\n'})
	echo ${arr[0]}
}

get_device_name_from_file()
{
	fileArr=(${1//'.'/$'\n'})
	deviceName=${fileArr[0]}
}

save_new_file()
{
	log "Guardando archivo de configuración nuevo: $confFile"
	fileArr=(${confFile//'.'/$'\n'})
	cp $FTP_FILES_PATH/$confFile $CONF_FILES_PATH/${fileArr[0]}_$(date +'%Y%m%d%H%M%S').${fileArr[1]}
	log "Archivo nuevo guardado con el nombre: ${fileArr[0]}_$(date +'%Y%m%d%H%M%S').${fileArr[1]}"
}

delete_oldest_file()
{
	log "Eliminando archivo historico mas viejo: $firstDeviceFile"
	get_oldest_device_file
	rm "$CONF_FILES_PATH/$firstDeviceFile"
	log "Archivo eliminado."
}

delete_conf_file()
{
	log "Eliminando archivo de configuracion descargado: $confFile"
	rm $FTP_FILES_PATH/$confFile
	log "Archivo eliminado."
}

log()
{
	mkdir -p $LOG_PATH
	echo "$1" >> "$LOG_PATH/$LOG_FILE_NAME"
	if [ "$2" == "-v" ] || [ "$DEBUG" == "Y" ]; then
		echo $1
	fi
}

run()
{
	cd $FTP_FILES_PATH

	for confFile in *; do
		get_device_name_from_file $confFile
		get_device_files_qty
		if [ $historyFilesQty -eq 0 ]; then
			save_new_file
		else
			get_last_device_file
			cmd1=$(get_compare_files_command $FTP_FILES_PATH/$confFile)
			cmd2=$(get_compare_files_command $CONF_FILES_PATH/$lastDeviceFile)
			result=$(diff <(eval $cmd1) <(eval $cmd2))
			if [ -z "$result" ]; then 
				log "El archivo: $confFile es igual al archivo $lastDeviceFile"
				if [ "$DELETE_CONF_FILE" == "Y" ]; then
					delete_conf_file
				fi
			else
				echo 'distintos'
				save_new_file
				if [ $historyFilesQty -ge $MAX_FILES_QTY ]; then
					delete_oldest_file
				fi;
			fi
		fi
	done;
}

run
