#! /bin/bash
#
# Author : Alban MUSSI - @BitInTheSkud - 25 sept 2017
#
# Description : 
#    This script can be run on a single host to backup all your domain
#    hosted on Amazon Route 53. 
# 
# Pre-requisites: 
#    - cli53 is installed and is in your PATH. see https://github.com/barnybug/cli53
#    - If you want to run this script as a batch, create a user for this purpose
#      with limited IAM access to route 53. 
#
# Next:
#    - add purge of old archive 
#    - compress and archive directory 
# 

#--
# Variables

DATE_LOG="$(date +"%b%d %H:%M:%S")"
DATE_FILE="$(date +"%d%m%Y-%Hh%Mm%Ss")"
OUTPUT_DIR="Backup_Route_53.${DATE_FILE}"
LOG_FILE="${OUTPUT_DIR}/script_run.log"
BASENAME=$(basename $0)
HOSTNAME=$(uname -n|cut -d'.' -f1)


#--
# Functions

function _usage() {
   printf "NAME:\n"
   printf "\t%s - backup all your AWS route 53 domain\n"
   printf "USAGE:\n"
   printf "\t%s"
   exit 1
}

#---
# Pre-checks 

type cli53 > /dev/null 2>&1 
if [ $? -ne 0 ] ; then
   echo "error: command cli53 not found."
   exit 2
fi 


#--
# Main

[ -d ${OUTPUT_DIR} ] || mkdir ${OUTPUT_DIR}  

echo "${DATE_LOG} ${HOSTNAME} INFO: Starting script ${BASENAME}" | tee -a ${LOG_FILE} 

for DOMAIN in $(cli53 list | awk '!/^ID.*Name/ {print $2}'| xargs) ; do

    echo "${DATE_LOG} ${HOSTNAME} INFO: starting export for domain ${DOMAIN}" | tee -a  ${LOG_FILE} 
    # Run export command
    OUTPUT_FILE="${OUTPUT_DIR}/${DOMAIN}"
    cli53 export $DOMAIN > ${OUTPUT_FILE} 2>&1

    RET_CODE=$?
    if [ ${RET_CODE} -ne 0 ] ; then
      echo "${DATE_LOG} ${HOSTNAME} ERROR: export for domain ${DOMAIN} return code is ${RET_CODE}" | tee -a ${LOG_FILE}
    else
      echo "${DATE_LOG} ${HOSTNAME} INFO: export for domain ${DOMAIN} return code is ${RET_CODE}" | tee -a ${LOG_FILE}
    fi 
    
    # check number of line (should have at least 1 record) 
    # Which probably mean you don't have any record for this domain
    if [ $(wc -l ${OUTPUT_FILE}|awk '{print $1}') -le 6 ] ; then
      echo "${DATE_LOG} ${HOSTNAME} WARNING: ${DOMAIN} has less than 6 line in the backup file"  | tee -a ${LOG_FILE} 
    fi

    # file exist and should not be empty.
    if [ ! -s ${OUTPUT_FILE} ] ; then
      echo "${DATE_LOG} ${HOSTNAME} CRITICAL: ${DOMAIN} backup file does not exist or is empty" | tee -a ${LOG_FILE} 
    fi 
done

echo "${DATE_LOG} ${HOSTNAME} INFO: end export of all domain" | tee -a ${LOG_FILE}
echo "log file available in ${LOG_FILE}..."
