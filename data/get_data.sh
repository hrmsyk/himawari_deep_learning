#!/usr/bin/env bash

FIRST_DATETIME="2023-08-01 00:00:00"
#LAST_DATETIME="2020-07-20 23:00:00"
LAST_DATETIME="2023-08-10 00:00:00"
USER="ftp"
PASS="anonymous"
CURRENT_DATETIME=${FIRST_DATETIME}
FIRST_SEC=`date +%s -d "${FIRST_DATETIME}"`
LAST_SEC=`date +%s -d "${LAST_DATETIME}"`
CURRENT_SEC=`date +%s -d "${CURRENT_DATETIME}"`
while [ ${CURRENT_SEC} -le ${LAST_SEC} ]; do
   CURRENT_DOY=`date +%j -d "${CURRENT_DATETIME}"`
   YYYY=`date +%Y -d "${CURRENT_DATETIME}"`
   YY=`date +%y -d "${CURRENT_DATETIME}"`
   MM=`date +%m -d "${CURRENT_DATETIME}"`
   DD=`date +%d -d "${CURRENT_DATETIME}"`
   HH=`date +%H -d "${CURRENT_DATETIME}"`
   CURRENT_DATE=`date +%F -d "${CURRENT_DATETIME}"`
   if [ ! -d "${YYYY}/${MM}/${DD}" ]; then
      mkdir -p "${YYYY}/${MM}/${DD}"
   fi
### ftp://ftp.cpc.ncep.noaa.gov/precip/CMORPH_V0.x/RAW/8km-30min/2020/202008/CMORPH_V0.x_RAW_8km-30min_2020082621.gz
   URL_PRE=http://weather.is.kochi-u.ac.jp/sat/hdse
   FILE=hs.${YYYY}${MM}${DD}${HH}.jpg
# http://weather.is.kochi-u.ac.jp/sat/hdse/2023/08/01/hs.2023080100.jpg
   URL=${URL_PRE}/${YYYY}/${MM}/${DD}/${FILE}
   OUTPUT_FILE=${YYYY}/${MM}/${DD}/${FILE}
   echo ${URL}
   echo ${OUTPUT_FILE}
   if [ -f "${OUTPUT_FILE}" ]; then
      FILESIZE=`\ls -l1 ${OUTPUT_FILE} | awk -F" " '{print $5}'`
      if [ ${FILESIZE} -le 300000 ]; then
         echo "delete small file: ${OUTPUT_FILE} ${FILESIZE}"
         rm -f ${OUTPUT_FILE}
      fi
   fi
   wget --wait=1 ${URL} -O ${OUTPUT_FILE}
   sleep 1
   CURRENT_DATETIME=`date --rfc-3339=seconds -d "${CURRENT_DATETIME} 1 hour"` # For while loop index
   CURRENT_SEC=`date +%s -d "${CURRENT_DATETIME}"`
done

