# Splunk_FrozenData_FIND_by_DATE_and_Restore
You can Archive Your Old Logs In Splunk. but when you need an old log from specific date you will be lost in a big mountain of files.
each frozen bucket file contains start and end date of logs archived in rhat file but unfotunetly in binary date format.
so in this bash script you give the #frozenpath and your #indexername then the script converts your date to binary format and gives you following information:
1.list folders that contain logs in time range you intered befor
2.gives the size of each folder
3. converts the binary to human readable date format and gives you time range that each bucket contains logs
then it asks for recovering the bucket by copying it to thawed path of the indexer (asks for path) and rebuild the index for you
then asks for splunk restart
