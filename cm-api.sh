#!/bin/bash

search=$1
carPlate=""
isNum=false
tmpFile="/tmp/output.txt"
url="https://data.gov.il/api/3/action/datastore_search?resource_id=053cea08-09bc-40ec-8f7a-156f0677aff3&limit=99999"
url_Degem="https://data.gov.il/api/3/action/datastore_search?resource_id=142afde2-6228-49f9-8a29-9b6c3a0cbe40"

if [ $# == 0 ]; then
  echo $0: "Usage: CM <search> (-c / -n / -f / -a)"
  exit 1
fi

if [[ $1 =~ ^[0-9]+$ ]]; then
	isNum=true
	if [ ${#1} == 7 ]; then
		search=$(echo $1 | sed 's/^/0/')
		carPlate=$(echo $1 | sed -re 's/([0-9])([0-9]{5})($|[^0-9])/\1-\2\3/' -re 's/([0-9])([0-9]{2})($|[^0-9])/\1-\2\3/')
	elif [ ${#1} == 8 ]; then
		carPlate=$(echo $1 | sed -e 's/[0-9]\{3\}/&-/g')
	fi
fi

case "$2" in
	-c)
		curl -s "$url&q=$search" | jq .result.records[].shnat_yitzur | sort  > $tmpFile
		if [[ -f $tmpFile ]]; then
			years=$(awk -F" " '{print $1}' $tmpFile | sort | uniq)
			for y in $years;
			do
				count=$(awk '$1=="'$y'"' $tmpFile | sort -n | wc -l)
				echo $y - $count
			done
			echo -e "\nTotal: " $(wc -l < $tmpFile)
			rm $tmpFile
		else
			echo "Error: there is no results for the query"
		fi
	;;
	-n)
		curl -s "$url&q='$search'" | jq ".result.records[]._id" | wc -l
	;;
	-f)
		curl -s "$url&q='$search'" | jq ".result.records[] | del(._id,.rank,.tozeret_nm,.baalut,.sug_degem,.ramat_eivzur_betihuty,.kvutzat_zihum)"
	;;
	-a)
		if  [ "$isNum" = false ]; then
			echo "Please enter vaild plate number"
			exit 1;
		fi
		output=$(curl -s "$url&q='$search'" | jq ".result.records[] | select(.mispar_rechev == $search)")
		if ! [[ -z $output ]]; then
			year=$(echo $output | awk -F"," '{print $11}' | awk '{print $NF}')
			degem=$(echo $output | awk -F"," '{print $6}' | awk '{print $NF}')
			model=$(echo $output | awk -F"," '{print $17}' | awk '{print $NF}')
			gimur=$(echo $output | awk -F"," '{print $8}' | awk '{print $NF}')
			testu=$(echo $output | awk -F"," '{print $14}' | awk '{print $NF}')
			output2=$(curl -s "$url_Degem&q='$degem'" | jq ".result.records[] | select(.shnat_yitzur == $year) | select(.kinuy_mishari == $model)")
			
			if ! [[ -z "$output2" ]]; then
				kbutza=$(echo $output2 | awk -F"," '{print $10}' | awk '{print $NF}')
				gear=$(echo $output2 | awk -F"," '{print $21}' | awk '{print $NF}')
				cc=$(echo $output2 | awk -F"," '{print $11}' | awk '{print $NF}')
				hq=$(echo $output2 | awk -F"," '{print $32}' | awk '{print $NF}')
				if [ "$gear" == "0" ]; then gear="Manual"; else gear="Automatic"; fi
				if [ -z "$carPlate" ]; then carnum=$search; else carnum=$carPlate; fi
				echo -e "$model - $gimur - $cc cc - $hq hp\n$carnum\n$year\nGear: $gear\nRishoi: $kbutza\nTest until: $testu" | sed 's/"//g; s/T00:00:00//g'
			else
				echo "Error: there is no results for the query"
			fi
		else
			echo "Error: there is no results for the query"
		fi
	;;
	*)
		echo $0: "Usage: CM <search> (-c / -n / -f / -a)"
		exit 1
	;;
esac
