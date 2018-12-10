#!/bin/bash
links=()
links_array=()

background(){

	wget "$1" -q -O  "proxeiro.txt"
	if [ $? == 0 ]
	then
		newHash=`md5sum proxeiro.txt | awk '{print $1}'`
		arrayPosition=-100
		
		for j in "${!links_array[@]}"	
		do
			if [ "$1" == "${links_array[$j]}" ]
			then
				arrayPosition=${j}
				
				break
			fi
		done
		if [ $arrayPosition == -100 ]
		then
			links_array+=(${1})
			hash_array+=(${newHash})
			echo "$1 $newHash" >> memory.txt 
			echo "$1 INIT"  
		else
			if [ $newHash != ${hash_array[$arrayPosition]} ]
			then 
				hash_array[${arrayPosition}]="$newHash"
				echo "$1"		
			fi
			
		fi
	else
		>&2 echo "$1 FAILED"
	fi




}


while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "Input is: $line"
	links+=($line) 
done < links.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
	string_array=($line)
	links_array+=(${string_array[0]})
	hash_array+=(${string_array[1]})   
done < memory.txt


for i in "${links[@]}"
do	
	background $i &
done

 > memory.txt
for ((j=0;j<${#links_array[@]};++j));
do	
	echo "${links_array[j]} ${hash_array[j]}" >> memory.txt
done
