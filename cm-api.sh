
#!/bin/bash

search=$(echo $1 | sed 's/\ /|/g')

carPlate=""
isNum=false
tmpFile="/tmp/output.txt"
url="https://data.gov.il/api/3/action/datastore_search?resource_id=053cea08-09bc-40ec-8f7a-156f0677aff3&limit=99999"
url_Degem="https://data.gov.il/api/3/action/datastore_search?resource_id=142afde2-6228-49f9-8a29-9b6c3a0cbe40"
error_cmd="Usage: $0 <search> (-c [count per year] / -r [models] / -n [count total] / -f [info] / -a [info for all])"

if [ $# == 0 ]; then
  echo $error_cmd
  exit 1
fi

case "$2" in
        -c)
                curl -s "$url&q=$search" | jq .result.records[].shnat_yitzur | sort  > $tmpFile
                if [[ -f $tmpFile ]]; then
                        years=$(awk -F" " '{print $1}' $tmpFile | sed 's/"//g' | sort | uniq)
                        for y in $years;
                        do
                                count=$(sed 's/"//g' $tmpFile | awk '$1=='$y'' | sort -n | wc -l)
                                echo $y - $count
                        done
                        echo -e "\nTotal: " $(wc -l < $tmpFile)
                        #rm $tmpFile
                else
                        echo "Error: there is no results for the query"
                fi
        ;;
        -r)
                curl -s "$url&q=$search" | jq .result.records[].ramat_gimur | sed 's/\ /-/g' | sort  > $tmpFile
                if [[ -f $tmpFile ]]; then
                        years=$(awk -F" " '{print $1}' $tmpFile | sort | uniq | sed 's/\"//g')
                        for y in $years;
                        do
                                count=$(grep $y $tmpFile | sort -n | wc -l)
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
                if ! [[ "$1" =~ ^[0-9]{7,8}$ ]]; then
                        echo "Please enter vaild plate number"
                        exit 1;
                fi
                output=$(curl -s "$url&q='$search'" | jq ".result.records[] | select(.mispar_rechev == $search)")
                if [ ${#1} == 7 ]; then
                        carPlate=$(echo $1 | sed -re 's/([0-9])([0-9]{5})($|[^0-9])/\1-\2\3/' | sed -re 's/([0-9])([0-9]{2})($|[^0-9])/\1-\2\3/')
                elif [ ${#1} == 8 ]; then
                        carPlate=$(echo $1 | sed -e 's/[0-9]\{3\}/&-/g')
                fi

                if ! [[ -z $output ]]; then
                        year=$(echo $output | awk -F"," '{print $11}' | awk '{print $2}')
                        degem=$(echo $output | awk -F"," '{print $6}' | awk '{print $2}')
                        model=$(echo $output | awk -F"," '{print $24}' | awk '{print $2}')
                        gimur=$(echo $output | awk -F"," '{print $8}' | awk '{print $2}')
                        testu=$(echo $output | awk -F"," '{print $14}' | awk '{print $2}')
                        degemNum=$(echo $output | awk -F"," '{print $7}' | awk '{print $2}')
                                                vinNum=$(echo $output | awk -F"," '{print $16}' | awk '{print $2}')
                        output2=$(curl -s "$url_Degem&q='$degem'" | jq ".result.records[] | select(.shnat_yitzur == $year) | select(.degem_nm == $degemNum) | {kvuzat_agra_cd,nefah_manoa,automatic_ind,koah_sus}")
                        if ! [[ -z "$output2" ]]; then
                                kbutza=$(echo $output2 | awk -F"," '{print $1}' | awk '{print $3}')
                                gear=$(echo $output2 | awk -F"," '{print $3}' | awk '{print $2}')
                                cc=$(echo $output2 | awk -F"," '{print $2}' | awk '{print $2}')
                                hq=$(echo $output2 | awk -F"," '{print $4}' | awk '{print $2}')
                                if [ "$gear" == "0" ]; then gear="Manual"; else gear="Automatic"; fi
                                if [ -z "$carPlate" ]; then carnum=$search; else carnum=$carPlate; fi
                                echo -e "$model - $gimur - $cc cc - $hq hp - $year\n$carnum\nVIN number: $vinNum\nGear: $gear\nCode degem: $degemNum\nKbutzat rishoi: $kbutza\nTest until: $testu" | sed 's/"//g; s/T00:00:00//g'
                        else
                                echo "Error: there is no results for the query"
                        fi
                else
                        echo "Error: there is no results for the query"
                fi
        ;;
        *)
                echo $error_cmd
                exit 1
        ;;
esac
