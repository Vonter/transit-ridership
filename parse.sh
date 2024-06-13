#!/bin/bash

IFS=$'\n';
BASEDIR="raw/BMTC"

mkdir -p ${BASEDIR}/PDFs
mkdir -p ${BASEDIR}/CSVs
touch "shakti.csv"

mv OneDrive_* Shakti.zip
unzip Shakti.zip
rm Shakti.zip

mv Shakti\ Ridership/* "${BASEDIR}/PDFs"
rmdir Shakti\ Ridership
tabula -b ${BASEDIR}/PDFs -f CSV -o CSVs -p all
mv ${BASEDIR}/PDFs/*.csv raw/BMTC/CSVs

for csv in $(ls "${BASEDIR}/CSVs");
do 
  csv="${BASEDIR}/CSVs/$csv"
  echo $csv
  date=$(grep -Eo '[0-9\/]{5,}' $csv | head -n 1)
  passengers=$(grep -Eo '[0-9\.,]{5,}' $csv | head -n 15 | sed 's/,//g' | tr '\n' ',')
  csv_line="$date,$passengers"
  echo $csv_line >> shakti.csv
done

cat shakti.csv | grep -v 'date' | sort -u > shakti
sed -i '1idate,ksrtc_total,bmtc_total,nwkrtc_total,kkrtc_total,all_total,ksrtc_women,bmtc_women,nwkrtc_women,kkrtc_women,all_women,ksrtc_value,bmtc_value,nwkrtc_value,kkrtc_value,all_value,' shakti
rm shakti.csv
mv shakti "csv/BMTC/Shakti.csv"
