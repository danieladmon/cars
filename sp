#!/bin/bash
#
# use to count by years the results
# example: 
# daniel@LTdadmon-S8T5A:~/cars$ cm BRZ -f | grep -iwa "PREMIUM" | sp
# 2012 - 2
# 2013 - 2
# 2014 - 3
#
# Total:  7

tmpFile="/tmp/output-sp.txt"

if [ -p /dev/stdin ]; then
        while IFS= read line; do
                output=$(echo "${line}" | awk -F"|" '{print $1, $10, $7}' | sed 's/"//g' >> $tmpFile)
        done
fi

if [[ -f $tmpFile ]]; then
        output=$(cat $tmpFile | sort -k2 -n | uniq &> $tmpFile)
        years=$(awk -F" " '{print $2}' $tmpFile | sort | uniq)
        for y in $years;
        do
                count=$(awk '$2=="'$y'"' $tmpFile | sort -n | wc -l)
                echo $y - $count
        done
        echo -e "\nTotal: " $(wc -l < $tmpFile)
else
        echo "Error: there is no results for the query"
fi

rm -f $tmpFile
