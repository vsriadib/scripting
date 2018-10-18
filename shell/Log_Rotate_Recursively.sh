#!/bin/bash

#
# Name: Log_Rotate_Recursively
# Purpose: 
#   This script rotates the large log files based on the given size 
#   Copies the existing large file with date as suffix and then truncates
#   the orginal file. 
#   
#

echo ""
echo "Begin: Log_Rotate_Recursively.sh"
echo `date`

basepath=$1
size=$2


if [ "$basepath" = "" ] && [ "$size" = "" ]
then
  echo "Provide basepath and size"
  exit
fi

cd $1 
pwd

#Find specific log files recursively in all sub folders
file=$(find . -type f \( -name "stderr" -o -name "stdout" -o -name "user.log" \) -size +$size -exec ls -lh {} \;)

#Using awk to get all the file names
file1=$(echo "$file" | awk '{ print $9 }')

#Loop thruough the file names
array=($(echo "$file1" | sed 's/ / /g'))
for el in "${array[@]}"; do
    echo "el = $el"

    dirname="${el%/*}" # get directory/path name
    filename="${el##*/}"  # get filename

    if [ "$filename" == "stderr" ] || [ "$filename" == "stdout" ] || [ "$filename" == "user.log" ]
    then
	echo "Copying the file"
	echo "Dir Name------"$dirname
	echo "File Name------"$filename
        #Go to directories
	cd $dirname
        
	#Copy and truncate the file
	cp "$filename" "$filename"_$(date +%F)
	echo "$(tail -1000 $filename)" > $filename
	echo "Copy and Truncate of $filename has been Completed"
    fi
    cd $1

done
 
#####################
echo "End: Log_Rotate.sh"
echo "" 
