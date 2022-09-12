#!/bin/bash
clear
echo  "############################"
echo  "##created.by mehran.safari##"
echo  "##        2022            ##"
echo  "############################"
##############
echo -n " Enter index name to lookup:"
read INAME
####
FROZENPATH="/frozendata"
echo " Default Splunk Frozen Indexes Path is "$FROZENPATH". is it ok? (y to continue or n to give new path):"
read  ANSWER3;
case "$ANSWER3" in
"y")
echo -e "OK Deafult Frozen Index Path Selected.";;
"n")
echo -e "Enter NEW Frozen Index Path:";
read FROZENPATH;;
esac
####
find "$FROZENPATH/$INAME" -type d -iname "db_*" -print > "./frozendb.txt"
echo -n " Enter starting date you need("MM/DD/YYYY HH:MM:SS"):"
read SDATE
echo -n " Enter end date you need("MM/DD/YYYY HH:MM:SS"):"
read EDATE
##############
BSDATE=$(date -d  "$SDATE" +%s)
BEDATE=$(date -d  "$EDATE" +%s)
#############
FILE='./frozendb.txt'
 while read line; do
          LOGSTART=`echo $line | cut -d "_" -f3`;
          LOGEND=`echo $line | cut -d "_" -f2`;
if [[ $BSDATE -le $LOGEND && $BEDATE -gt  $LOGSTART ]]; then
echo -e "******************************"
echo -e "Frozen Log Path You want: $line"
HLOGSTART=`date -d @"$LOGSTART"`
HLOGEND=`date -d @"$LOGEND"`
LOGSIZE=`du -hs "$line" | cut -d "/" -f1`
echo -e "*** this Bucket contains logs from: $HLOGSTART"
echo -e "*** this Bucket contains logs to: $HLOGEND "
echo -e "**** The Size Of This Log Is: $LOGSIZE"
echo -e "$line" >> "./frozenmatched.txt"
echo -e "******************************"
#else
#echo "not in data range you want: $line"
fi
done<$FILE
############
sudo rm -rf "./frozendb.txt"
echo "Do you Want to Unfrozen this Logs?(y to copy): "
read  ANSWER
FILE2='./frozenmatched.txt'
INDEXPATH="/opt/splunk/var/lib/splunk"
DST="$INDEXPATH/$INAME/thaweddb/"
if [[ "$ANSWER" == "y" ]]; then
echo " Default Destination is "$DST". is it ok? (y to continue or n to give new path):"
read  ANSWER2;
case "$ANSWER2" in
"y")
echo -e "OK Deafult Destination Selected.";;
"n")
echo -e "Enter NEW Destination Path:";
read DST;;
esac
while read line2; do
        sudo cp -R "$line2" "$DST"
        echo -e "Executing copy of $line2 to $DST DONE."
	echo -e "$DST$(basename $line2)"
	sudo /opt/splunk/bin/splunk rebuild "$DST$(basename $line2)" $INAME --ignore-read-error
done<$FILE2

fi
sudo rm -rf "./frozenmatched.txt"
##########
echo " Do you want to restart splunk service? (y to continue or n to exit):"
read  ANSWER4;
if [[ "$ANSWER4" == "y" ]]; then
sudo /opt/splunk/bin/splunk restart
fi
##########
echo     "################################"
echo  -e "## GOOD LUCk WITH BEST REGARDS##"
echo     "################################"
#########
