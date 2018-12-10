#!/bin/bash
#Argz parameter the .tar.gz file to extract
mkdir folder
mkdir untar

tar -xzf $1 -C untar
cd ./untar

for file in $(find . -type f -name '*.txt');
do
	while IFS='' read -r line || [[ -n "$line" ]]; do
			cd .. 
			cd untar
			git clone "$line"
			if [ $? == 0 ]
			then		
				echo "$line Cloning OK"
				
			else
				>&2 echo "$line Failed"
			fi
			cd .. 
			cd untar			
			break
	done < $file
done

cd ..
cd folder

for assignment in $(ls);
do
	echo "$assignment:"
	cd $assignment
	directories=$(find . -not -path '*/\.*' -type d | wc -l)
	txts=$(find . -not -path '*/\.*' -type f -name '*.txt' | wc -l)
	others=$(find . -not -path '*/\.*' -type f ! -name '*.txt' | wc -l)
	echo "Number of directories: $directories"
	echo "Number of txt files: $txts"
	echo "Number of other files: $others"
	cd ..

done
