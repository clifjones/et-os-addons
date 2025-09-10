#!/bin/bash

# checking for existing requests
#R=$(grep -l  "Grib" /home/dufour43-away/.wl2k/mailbox/KK4FQB/out/*.b2f)

#if [ -n "$R" ]
#then
#rm $R
#fi

#get GPS cordinates Lat/Lon
X="$(gpspipe -w -n 10 |grep lat|tail -n1|cut -d":" -f9|cut -d"," -f1)"
Y="$(gpspipe -w -n 10 |grep lon|tail -n1|cut -d":" -f10|cut -d"," -f1)"

# adding + or - 25 to longitude, and + or -12 to latitude
A=$(echo "scale=4; $X+12" | bc -l)
B=$(echo "scale=4; $X-12" | bc -l) 
C=$(echo "scale=4; $Y-25" | bc -l)
D=$(echo "scale=4; $Y+25" | bc -l)

# Sending the GRIB request to pat (this is for weather)
curl http://localhost:8080/api/mailbox/out -F "date=$(date -u \
+'%Y-%m-%dT%H:%M:%SZ')" -F 'subject=Grib' -F 'to=query@saildocs.com' \
-F "body=send gfs:$A,$B,$C,$D= \
|2,2|6,12..96|PRESS,WIND,GUST,= \
CAPE,RAIN,CLOUDS,AIRTMP,WAVES"
